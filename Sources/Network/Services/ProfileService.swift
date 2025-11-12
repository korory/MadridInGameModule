//
//  ProfileService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 21/2/25.
//

import SwiftUI

class ProfileInformation {
    
    func updateInformationProfile(_ user: UserModel?, completion: @escaping (Result<AvatarModel, Error>) -> Void) {
        
        guard let user = user, let userId = user.id else {
            completion(.failure(NSError(domain: "Invalid User", code: 400, userInfo: nil)))
            return
        }
        
        let userParams: [String: Any] = [
//            "id" : user.id ?? "",
//            "username" : user.username ?? "",
//            "email" : user.email ?? "",
//            "dni" : user.dni ?? "",
//            "first_name" : user.firstName ?? "",
//            "last_name" : user.lastName ?? "",
            "avatar" : user.avatar ?? "",
            //"phone" : user.phone ?? "",
        ]
        
        Task {
            do {
                let updatedUser: AvatarModelResponse = try await DirectusService.shared.sendRequest(
                    endpoint: "users/\(userId)",
                    method: .PATCH,
                    body: userParams
                )
                Logger.shared.log("Usuario actualizado: \(updatedUser)")
                completion(.success(updatedUser.data)) // Devolver el usuario actualizado
            } catch {
                Logger.shared.log("Error al actualizar usuario: \(error)")
                completion(.failure(error)) // Llamar el completion con el error
            }
        }
    }
    
    func updateSingleDNIInformationProfile(userId: String, dni: String?, completion: @escaping (Result<DniModel, Error>) -> Void) {
        
        let userParams: [String: Any] = [
//            "id" : user.id ?? "",
//            "username" : user.username ?? "",
//            "email" : user.email ?? "",
//            "dni" : user.dni ?? "",
//            "first_name" : user.firstName ?? "",
//            "last_name" : user.lastName ?? "",
            "dni" : dni ?? "",
            //"phone" : user.phone ?? "",
        ]
        
        Task {
            do {
                let updatedUser: DniModelResponse = try await DirectusService.shared.sendRequest(
                    endpoint: "users/\(userId)",
                    method: .PATCH,
                    body: userParams
                )
                Logger.shared.log("Usuario actualizado: \(updatedUser)")
                completion(.success(updatedUser.data)) // Devolver el usuario actualizado
            } catch {
                Logger.shared.log("Error al actualizar usuario: \(error)")
                completion(.failure(error)) // Llamar el completion con el error
            }
        }
    }
}

struct AvatarModelResponse: Codable {
    let data : AvatarModel
}

struct AvatarModel: Codable {
    let avatar: String?
}

struct DniModelResponse: Codable {
    let data : DniModel
}

struct DniModel: Codable {
    let dni: String?
}
