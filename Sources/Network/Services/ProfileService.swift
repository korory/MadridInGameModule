//
//  ProfileService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 21/2/25.
//

import SwiftUI

class ProfileInformation {
    
    func updateInformationProfile(_ user: UserModel?, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard let user = user, let userId = user.id else {
            completion(.failure(NSError(domain: "Invalid User", code: 400, userInfo: nil)))
            return
        }
        
        let userParams: [String: Any] = [
            "id" : user.id ?? "",
            "username" : user.username ?? "",
            "email" : user.email ?? "",
            "dni" : user.dni ?? "",
            "first_name" : user.firstName ?? "",
            "last_name" : user.lastName ?? "",
            "avatar" : user.avatar ?? "",
            "phone" : user.phone ?? "",
        ]
        
        Task {
            do {
                let updatedUser: UserModel = try await DirectusService.shared.sendRequest(
                    endpoint: "users/\(userId)",
                    method: .PATCH,
                    body: userParams
                )
                print("Usuario actualizado: \(updatedUser)")
                completion(.success(updatedUser)) // Devolver el usuario actualizado
            } catch {
                print("Error al actualizar usuario: \(error)")
                completion(.failure(error)) // Llamar el completion con el error
            }
        }
    }
}
