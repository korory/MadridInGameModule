//
//  UserManager.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 27/1/25.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private var user: UserModel?
    
    func setUser(user: UserModel) {
        self.user = user
    }
    
    func getUser() -> UserModel? {
        return user
    }
    
    func setSelectedTeam(_ team: TeamModelReal) {
        guard var u = self.user else { return }
        u.selectedTeam = team
        self.user?.selectedTeam = u.selectedTeam
    }

    func getSelectedTeam() -> TeamModelReal? {
        return self.user?.selectedTeam
    }
    
    func setAllTeamsUser(_ teams: [TeamModelReal]) {
        guard var u = self.user else { return }
        u.teamsResponse = teams
        self.user?.teamsResponse = u.teamsResponse
    }
    
    struct TeamResponse: Codable {
        let data: [TeamModelReal]
    }
    
    struct TrainingsResponseModel: Codable {
        let data: [TrainingsModel]
    }
    
    func setDNI(_ dni: String) {
        guard var u = self.user else { return }
        u.dni = dni
        self.user?.dni = u.dni
    }

    private init() {}
    
    func initializeUser(userInfo: MadridInGameUserData, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ["filter[email][_eq]": userInfo.email]
        
        Task {
            do {
                let response: [String: [UserModel]] = try await DirectusService.shared.request(
                    endpoint: "users",
                    method: .GET,
                    parameters: parameters
                )
                
                if let users = response["data"], var user = users.first {
                    if (self.user == nil) {
                        setUser(user: user)
                    }
                    
                    if let userId = user.id {
                        await updateUserInformation(userId: userId, userInfo: userInfo)
                        fetchTeamsByUser(userId: userId) { result in
                            switch result {
                            case .success(let teams):
                                user.teamsResponse = teams
                                self.setAllTeamsUser(teams)
                                //self.user = user
                                completion(.success(()))
                            case .failure(let error):
                                Logger.shared.log(error)
                                completion(.failure(error))
                            }
                        }
                    }
                } else {
                    //completion(.failure(NSError(domain: "No User Found", code: 0, userInfo: nil)))
                    registerUserIntoDatabase(userInfo: userInfo) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func initializeUser(withEmail email: String, userName: String, dni: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ["filter[email][_eq]": email]

        Task {
            do {
                let response: [String: [UserModel]] = try await DirectusService.shared.request(
                    endpoint: "users",
                    method: .GET,
                    parameters: parameters
                )

                if let users = response["data"], var user = users.first {
                    if (self.user == nil) {
                        setUser(user: user)
                    }
                    
                    if let userId = user.id {
                        fetchTeamsByUser(userId: userId) { result in
                            switch result {
                            case .success(let teams):
                                user.teamsResponse = teams
                                self.setAllTeamsUser(teams)
                                completion(.success(()))
                            case .failure(let error):
                                Logger.shared.log(error)
                                completion(.failure(error))
                            }
                        }
                    }
                } else {
                    //completion(.failure(NSError(domain: "No User Found", code: 0, userInfo: nil)))
                    registerUserIntoDatabase(email: email, userName: userName, dni: dni) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func registerUserIntoDatabase(userInfo: MadridInGameUserData, completion: @escaping (Result<Void, Error>) -> Void) {
        var userParams: [String: Any] = [
            "email" : userInfo.email,
            "username" : userInfo.userName,
        ]
        if let dni = userInfo.dni {
            userParams["dni"] = dni
        }
        if let name = userInfo.name {
            userParams["first_name"] = name
        }
        if let phone = userInfo.phone {
            userParams["phone"] = phone
        }
        if let lastName = userInfo.lastName {
            userParams["last_name"] = lastName
        }
        Task {
            do {
                let updatedUser: UserModelResponse = try await DirectusService.shared.sendRequest(
                    endpoint: "users",
                    method: .POST,
                    body: userParams
                )
                Logger.shared.log("Usuario registrado: \(updatedUser)")
                self.user = updatedUser.data
                completion(.success(()))
            } catch {
                // If registration failed due to a duplicate DNI, retry without it
                if userParams["dni"] != nil {
                    Logger.shared.log("Registration failed, retrying without dni: \(error)")
                    userParams.removeValue(forKey: "dni")
                    do {
                        let updatedUser: UserModelResponse = try await DirectusService.shared.sendRequest(
                            endpoint: "users",
                            method: .POST,
                            body: userParams
                        )
                        Logger.shared.log("Usuario registrado sin DNI: \(updatedUser)")
                        self.user = updatedUser.data
                        completion(.success(()))
                    } catch {
                        Logger.shared.log("Error al registrar usuario: \(error)")
                        completion(.failure(error))
                    }
                } else {
                    Logger.shared.log("Error al registrar usuario: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func registerUserIntoDatabase(email: String, userName: String, dni: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        var userParams: [String: Any] = [
            "email" : email,
            "username" : userName,
        ]
        if let dni {
            userParams["dni"] = dni
        }
        Task {
            do {
                let updatedUser: UserModelResponse = try await DirectusService.shared.sendRequest(
                    endpoint: "users",
                    method: .POST,
                    body: userParams
                )
                
                Logger.shared.log("Usuario actualizado: \(updatedUser)")
                self.user = updatedUser.data
                completion(.success(()))
            } catch {
                Logger.shared.log("Error al actualizar usuario: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateUserInformation(userId: String, userInfo: MadridInGameUserData) async {
        guard let user = self.user,
              let parameters = createUserParamsDictionary(from: user, using: userInfo) else {
            return
        }

        do {
            let updatedUser: UserModelResponse = try await DirectusService.shared.sendRequest(
                endpoint: "users/\(userId)",
                method: .PATCH,
                body: parameters
            )
            
            Logger.shared.log("Usuario actualizado: \(updatedUser)")
            self.user = updatedUser.data
        } catch {
            Logger.shared.log("Error al actualizar usuario: \(error)")
        }
    }
    
    func fetchTeamsByUser(userId: String, completion: @escaping (Result<[TeamModelReal], Error>) -> Void) {
        let parameters = ["filter[users][users_id][_eq]": userId]
        let fields = "id,name,description,picture,apply_membership,status,discord,users.roles.name,users.users_id.id,users.users_id.username,users.users_id.avatar,users.users_id.email,competitions.competitions_id,date_edited"

        Task {
            do {
                let response: TeamResponse = try await DirectusService.shared.request(
                    endpoint: "teams",
                    method: .GET,
                    parameters: parameters.merging(["fields": fields]) { _, new in new }
                )

                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserTrainings(userId: String, completion: @escaping (Result<[TrainingsModel], Error>) -> Void) {
        guard let userTrainingIds = user?.trainings else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay entrenamientos disponibles en el perfil del usuario."])))
            return
        }

        Task {
            do {
                var allTrainings: [TrainingsModel] = []

                for trainingId in userTrainingIds {
                    let parameters = ["filter[id][_eq]": "\(trainingId)"]
                    let trainingResponse: TrainingUserConnectionResponseModel = try await DirectusService.shared.request(
                        endpoint: "trainings_users",
                        method: .GET,
                        parameters: parameters
                    )

                    if let trainingId = trainingResponse.data?.first?.trainingsId {
                        let trainingParameters = ["filter[id][_eq]": "\(trainingId)"]
                        let eventResponse: TrainingsResponseModel = try await DirectusService.shared.request(
                            endpoint: "trainings",
                            method: .GET,
                            parameters: trainingParameters
                        )

                        if let trainingInfo = eventResponse.data.first {
                            allTrainings.append(trainingInfo)
                        }
                    }
                }
                completion(.success(allTrainings))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserGameSpace(userId: String, completion: @escaping (Result<[LoanModel], Error>) -> Void) {
        guard let userGamingSpacesIds = user?.gamingSpaceReserves, !userGamingSpacesIds.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay entrenamientos disponibles en el perfil del usuario."])))
            return
        }

        Task {
            do {
                var allGamingSpaces: [LoanModel] = []

                for gamingSpaceId in userGamingSpacesIds {
                    let parameters = ["filter[id][_eq]": "\(gamingSpaceId)"]
                    guard let gamingResponse: GamingSpaceResponse = try await DirectusService.shared.request(
                        endpoint: "gaming_space_reserves",
                        method: .GET,
                        parameters: parameters
                    ), let gamingInfo = gamingResponse.data.first else {
                        continue
                    }

                    var updatedGamingInfo = gamingInfo

                    if let userGamingSpacesTimesIds = gamingInfo.times {
                        for gamingSpaceTimeId in userGamingSpacesTimesIds {
                            let timeParameters = ["filter[id][_eq]": "\(gamingSpaceTimeId)"]
                            guard let gamingTimeResponse: GamingSpacesReservationIds = try await DirectusService.shared.request(
                                endpoint: "gaming_space_reserves_gaming_space_times",
                                method: .GET,
                                parameters: timeParameters
                            ), let gamingSpaceTimesId = gamingTimeResponse.data.first?.gamingSpaceTimesId else {
                                continue
                            }

                            let timeInfoParameters = ["filter[id][_eq]": "\(gamingSpaceTimesId)"]
                            let gamingSpaceTimeResponse: GamingSpacesReservationTime = try await DirectusService.shared.request(
                                endpoint: "gaming_space_times",
                                method: .GET,
                                parameters: timeInfoParameters
                            )

                            updatedGamingInfo.gamingSpacesTimesComplete.append(contentsOf: gamingSpaceTimeResponse.data)
                        }
                    }

                    allGamingSpaces.append(updatedGamingInfo)
                }

                completion(.success(allGamingSpaces))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension UserManager {
    private func createUserParamsDictionary(
        from user: UserModel,
        using data: MadridInGameUserData
    ) -> [String: Any]? {
        var params: [String: Any] = [:]

        func addParamIfChanged<T: Equatable>(_ key: String, _ oldValue: T?, _ newValue: T?) {
            if let newValue = newValue, newValue != oldValue {
                params[key] = newValue
            }
        }

        addParamIfChanged("email", user.email, data.email)
        addParamIfChanged("username", user.username, data.userName)

        let oldDni = user.dni ?? ""
        if oldDni.isEmpty, let newDni = data.dni, !newDni.isEmpty {
            params["dni"] = newDni
        }

        addParamIfChanged("first_name", user.firstName, data.name)
        addParamIfChanged("last_name", user.lastName, data.lastName)
        addParamIfChanged("phone", user.phone, data.phone)

        return params.isEmpty ? nil : params
    }
}
