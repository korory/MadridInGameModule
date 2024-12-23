//
//  AvatarViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//


import SwiftUI
import PhotosUI

class AvatarViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage?
    @Published var isCamera = false
    @Published var showActionSheet = false

    func selectCamera() {
        isCamera = true
        showImagePicker = true
    }

    func selectGallery() {
        isCamera = false
        showImagePicker = true
    }
}
