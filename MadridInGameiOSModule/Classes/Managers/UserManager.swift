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
    
    func getUser() -> UserModel? {
        return user
    }
    
    func setSelectedTeam(_ team: TeamModelReal) {
        self.user?.selectedTeam = team
    }

    func getSelectedTeam() -> TeamModelReal? {
        return self.user?.selectedTeam
    }
    
    struct TeamResponse: Codable {
        let data: [TeamModelReal]
    }
    
    struct TrainningsResponseModel: Codable {
        let data: [TrainningsModel]
    }

    private init() {}
    
    func initializeUser(withEmail email: String, userName: String, dni: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ["filter[email][_eq]": email]

        Task {
            do {
                let response: [String: [UserModel]] = try await DirectusService.shared.request(
                    endpoint: "users",
                    method: .GET,
                    parameters: parameters
                )

                if let users = response["data"], var user = users.first {
                    self.user = user

                    fetchTeamsByUser(userId: user.id ?? "") { result in
                        switch result {
                        case .success(let teams):
                            user.teamsResponse = teams
                            self.user = user
                            completion(.success(()))
                        case .failure(let error):
                            print(error)
                            completion(.failure(error))
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
    
    func registerUserIntoDatabase(email: String, userName: String, dni: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let userParams: [String: Any] = [
            "email" : email,
            "username" : userName,
            "dni" : dni,
            //            "first_name" : user.firstName ?? "",
            //            "avatar" : user.avatar ?? "",
            //            "phone" : user.phone ?? "",
        ]
        
        Task {
            do {
                let updatedUser: UserModelResponse = try await DirectusService.shared.sendRequest(
                    endpoint: "users",
                    method: .POST,
                    body: userParams
                )
                
                print("Usuario actualizado: \(updatedUser)")
                self.user = updatedUser.data
                completion(.success(()))
            } catch {
                print("Error al actualizar usuario: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeamsByUser(userId: String, completion: @escaping (Result<[TeamModelReal], Error>) -> Void) {
        let parameters = ["filter[users][users_id][_eq]": userId]
        let fields = "id,name,description,picture,apply_membership,status,discord,users.roles.name,users.users_id.id,users.users_id.username,users.users_id.avatar, competitions.competitions_id,date_edited"

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
    
    func fetchUserTrainings(userId: String, completion: @escaping (Result<[TrainningsModel], Error>) -> Void) {
        guard let userTrainingIds = user?.trainings else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay entrenamientos disponibles en el perfil del usuario."])))
            return
        }

        Task {
            do {
                var allTrainings: [TrainningsModel] = []

                for trainingId in userTrainingIds {
                    let parameters = ["filter[id][_eq]": "\(trainingId)"]
                    let trainingResponse: TrainingUserConnectionResponseModel = try await DirectusService.shared.request(
                        endpoint: "trainings_users",
                        method: .GET,
                        parameters: parameters
                    )

                    if let trainingId = trainingResponse.data?.first?.trainingsId {
                        let trainingParameters = ["filter[id][_eq]": "\(trainingId)"]
                        let eventResponse: TrainningsResponseModel = try await DirectusService.shared.request(
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
        guard let userGammingSpacesIds = user?.gamingSpaceReserves, !userGammingSpacesIds.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay entrenamientos disponibles en el perfil del usuario."])))
            return
        }

        Task {
            do {
                var allGammingSpaces: [LoanModel] = []

                for gammingSpaceId in userGammingSpacesIds {
                    let parameters = ["filter[id][_eq]": "\(gammingSpaceId)"]
                    guard let gammingResponse: GamingSpaceResponse = try await DirectusService.shared.request(
                        endpoint: "gaming_space_reserves",
                        method: .GET,
                        parameters: parameters
                    ), let gammingInfo = gammingResponse.data.first else {
                        continue
                    }

                    var updatedGammingInfo = gammingInfo

                    if let userGammingSpacesTimesIds = gammingInfo.times {
                        for gammingSpaceTimeId in userGammingSpacesTimesIds {
                            let timeParameters = ["filter[id][_eq]": "\(gammingSpaceTimeId)"]
                            guard let gammingTimeResponse: GamingSpacesReservationIds = try await DirectusService.shared.request(
                                endpoint: "gaming_space_reserves_gaming_space_times",
                                method: .GET,
                                parameters: timeParameters
                            ), let gammingSpaceTimesId = gammingTimeResponse.data.first?.gamingSpaceTimesId else {
                                continue
                            }

                            let timeInfoParameters = ["filter[id][_eq]": "\(gammingSpaceTimesId)"]
                            let gammingSpaceTimeResponse: GamingSpacesReservationTime = try await DirectusService.shared.request(
                                endpoint: "gaming_space_times",
                                method: .GET,
                                parameters: timeInfoParameters
                            )

                            updatedGammingInfo.gammingSpacesTimesComplete.append(contentsOf: gammingSpaceTimeResponse.data)
                        }
                    }

                    allGammingSpaces.append(updatedGammingInfo)
                }

                completion(.success(allGammingSpaces))
            } catch {
                completion(.failure(error))
            }
        }
    }

//
//    func fetchUserGameSpace(userId: String, completion: @escaping (Result<[LoanModel], Error>) -> Void) {
//        guard let userGammingSpacesIds = user?.gamingSpaceReserves, !userGammingSpacesIds.isEmpty else {
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay entrenamientos disponibles en el perfil del usuario."])))
//            return
//        }
//
//        Task {
//            do {
//                var allGammingSpaces: [LoanModel] = []
//
//                for gammingSpaceId in userGammingSpacesIds {
//                    let parameters = ["filter[id][_eq]": "\(gammingSpaceId)"]
//                    guard let gammingResponse: GamingSpaceResponse = try? await DirectusService.shared.request(
//                        endpoint: "gaming_space_reserves",
//                        method: .GET,
//                        parameters: parameters
//                    ), let gammingInfo = gammingResponse.data.first else {
//                        continue
//                    }
//
//                    var updatedGammingInfo = gammingInfo
//
//                    if let userGammingSpacesTimesIds = gammingInfo.times {
//                        for gammingSpaceTimeId in userGammingSpacesTimesIds {
//                            let timeParameters = ["filter[id][_eq]": "\(gammingSpaceTimeId)"]
//                            guard let gammingTimeResponse: GamingSpacesReservationIds = try? await DirectusService.shared.request(
//                                endpoint: "gaming_space_reserves_gaming_space_times",
//                                method: .GET,
//                                parameters: timeParameters
//                            ), let gammingSpaceTimesId = gammingTimeResponse.data.first?.gamingSpaceTimesId else {
//                                continue
//                            }
//
//                            let timeInfoParameters = ["filter[id][_eq]": "\(gammingSpaceTimesId)"]
//                            guard let gammingSpaceTimeResponse: GamingSpacesReservationTime = try? await DirectusService.shared.request(
//                                endpoint: "gaming_space_times",
//                                method: .GET,
//                                parameters: timeInfoParameters
//                            ) else {
//                                continue
//                            }
//
//                            updatedGammingInfo.gammingSpacesTimesComplete.append(contentsOf: gammingSpaceTimeResponse.data)
//                        }
//                    }
//
//                    allGammingSpaces.append(updatedGammingInfo)
//                }
//
//                completion(.success(allGammingSpaces))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
}
