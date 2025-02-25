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
        
        let userParams: [String: String] = [
            //"email": user.email as Any,
            "username": user.username ?? "",
//            "dni": user.dni as Any,
//            "first_name": user.firstName as Any,
//            "last_name": user.lastName as Any,
            //"avatar": user.avatar as Any,
            //"phone": user.phone as Any
        ]

        Task {
            do {
                let updatedUser: [UserModelResponse] = try await DirectusService.shared.sendRequest(
                    endpoint: "users/\(userId)",
                    method: .PATCH,
                    body: userParams
                )
                print("Usuario actualizado: \(updatedUser)")
            } catch {
                print("Error al actualizar usuario: \(error)")
            }
        }
    }
}
