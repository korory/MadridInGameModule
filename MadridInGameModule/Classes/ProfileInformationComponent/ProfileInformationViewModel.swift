//
//  ProfileInformationViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//

import Combine
import SwiftUI

class ProfileInformationViewModel: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var dni: String
    @Published var email: String
    @Published var username: String
    @Published var phone: String
    @Published var avatar: UIImage?
    @Published var isEditing: Bool = false
    @Published var showToastSuccess = false
    @Published var showToastFailure = false


    
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
        self.avatar = nil
    }
    
    func discardChanges() {
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        dni = user?.dni ?? ""
        email = user?.email ?? ""
        username = user?.username ?? ""
        phone = user?.phone ?? ""
        avatar = nil
        isEditing = false
    }
    
    func saveChanges() {
        ProfileInformation().updateInformationProfile(
            UserModel(
                id: self.user?.id, status: self.user?.status,
                username: username, email: email, dni: dni,
                token: self.user?.token, firstName: firstName,
                lastName: lastName, avatar: self.user?.avatar,
                reservesAllowed: self.user?.reservesAllowed, phone: phone,
                trainings: self.user?.trainings,
                gamingSpaceReserves: self.user?.gamingSpaceReserves,
                invitations: self.user?.invitations)
        ) { result in
            switch result {
            case .success:
                print("Perfil actualizado correctamente")
                self.showToastSuccess = true
                self.isEditing = false
            case .failure(let error):
                print(
                    "Error al actualizar perfil: \(error.localizedDescription)")
                self.showToastFailure = true
                self.isEditing = false
            }
        }
        
        //        print("Cambios guardados:")
        //        print("Nombre: \(firstName)")
        //        print("Apellidos: \(lastName)")
        //        print("DNI: \(dni)")
        //        print("Email: \(email)")
        //        print("Nick: \(username)")
        //        print("Teléfono: \(phone)")
        //isEditing = false
    }
    
    func toggleEditing() {
        isEditing.toggle()
    }
    
    func updateAvatar(_ image: UIImage?) {
        avatar = image
    }
}
