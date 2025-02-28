//
//  ProfileInformationViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//

import Combine
import SwiftUI

@MainActor
class ProfileInformationViewModel: ObservableObject {
    @Published var newAvatar: UIImage?
    @Published var isEditing: Bool = false
    @Published var showToastSuccess = false
    @Published var showToastFailure = false
    @Published var isLoading = false

    var firstName: String
    var lastName: String
    var dni: String
    var email: String
    var username: String
    var phone: String
    var avatar: String?

    private let userManager = UserManager.shared
    private let user: UserModel?

    init() {
        self.user = userManager.getUser()
        self.firstName = user?.firstName ?? ""
        self.lastName = user?.lastName ?? ""
        self.dni = user?.dni ?? ""
        self.email = user?.email ?? ""
        self.username = user?.username ?? ""
        self.phone = user?.phone ?? ""
        self.avatar = user?.avatar ?? ""
    }

    func discardChanges() {
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        dni = user?.dni ?? ""
        email = user?.email ?? ""
        username = user?.username ?? ""
        phone = user?.phone ?? ""
        avatar = user?.avatar
        toggleEditing()
    }

    func saveChanges() async {
        self.isLoading = true
        var avatarId = self.user?.avatar

        if newAvatar != nil {
            do {
                avatarId = try await updateAvatar()
                self.avatar = avatarId
            } catch {
                print("Error al subir la imagen: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showToastFailure = true
                    self.isLoading = false
                }
                return
            }
        }
        
        ProfileInformation().updateInformationProfile(
            UserModel(
                id: self.user?.id, status: self.user?.status,
                username: username, email: email, dni: dni,
                token: self.user?.token, firstName: firstName,
                lastName: lastName, avatar: self.avatar,
                reservesAllowed: self.user?.reservesAllowed, phone: phone,
                address: self.user?.address,
                trainings: self.user?.trainings,
                gamingSpaceReserves: self.user?.gamingSpaceReserves,
                invitations: self.user?.invitations
            )
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let profile):
                    print("Perfil actualizado correctamente: \(profile)")
                    self.showToastSuccess = true
                    self.isEditing = false
                case .failure(let error):
                    print("Error al actualizar perfil: \(error.localizedDescription)")
                    self.showToastFailure = true
                }
            }
        }
    }


    func toggleEditing() {
        newAvatar = nil
        isEditing.toggle()
    }

    func updateAvatar() async throws -> String {
        guard let avatarPhoto = self.newAvatar else { return self.user?.avatar ?? "" }

        return try await withCheckedThrowingContinuation { continuation in
            UploadImageService().uploadImage(image: avatarPhoto, fileName: "\(UUID().uuidString.lowercased()).jpg") { result in
                switch result {
                case .success(let response):
                    if let data = response.data(using: .utf8) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(SendImageResponse.self, from: data)
                            let fileId = decodedResponse.data.id
                            print("Imagen subida con éxito. ID: \(fileId)")
                            continuation.resume(returning: fileId)
                        } catch {
                            print("Error al decodificar JSON: \(error)")
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(throwing: NSError(domain: "Error al procesar la respuesta", code: 0))
                    }
                case .failure(let error):
                    print("Error al subir la imagen: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
