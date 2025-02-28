//
//  AvatarViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//


import SwiftUI
import PhotosUI

class AvatarViewModel: ObservableObject {
    @Published var imageId: String
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage?
    @Published var isCamera = false
    @Published var showActionSheet = false

    let environmentManager = EnvironmentManager()

    init(selectedImage: UIImage?, imageId: String?) {
        // Aquí ya no anulamos selectedImage, sino que lo asignamos si se pasa un valor
        self.selectedImage = selectedImage
        self.imageId = imageId ?? ""
    }
    
    func selectCamera() {
        isCamera = true
        showImagePicker = true
    }

    func selectGallery() {
        isCamera = false
        showImagePicker = true
    }
}
