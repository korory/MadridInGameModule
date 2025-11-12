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
//    @Published var selectedImage: UIImage?

    let environmentManager = EnvironmentManager()

    init(imageId: String?) {
        // Aquí ya no anulamos selectedImage, sino que lo asignamos si se pasa un valor
        self.imageId = imageId ?? ""
    }
}
