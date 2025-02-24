//
//  AvatarComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//

import SwiftUI
import PhotosUI

//struct AvatarComponentView: View {
//    @StateObject var viewModel = AvatarViewModel()
//    
//    var imageSelected: (UIImage) -> Void
//    
//    var body: some View {
//        VStack {
//            if let selectedImage = viewModel.selectedImage {
//                Image(uiImage: selectedImage)
//                    .resizable()
//                    .frame(width: 140, height: 140)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
//                    .onAppear {
//                        imageSelected(selectedImage)
//                    }
//                
//            } else {
//                circularImageComponent
//            }
//        }
//        .onTapGesture {
//            viewModel.showActionSheet = true
//        }
//        .actionSheet(isPresented: $viewModel.showActionSheet) {
//            ActionSheet(
//                title: Text("Selecciona una opción"),
//                buttons: [
//                    .default(Text("Cámara")) {
//                        viewModel.selectCamera()
//                    },
//                    .default(Text("Galería")) {
//                        viewModel.selectGallery()
//                    },
//                    .cancel()
//                ]
//            )
//        }
//        .sheet(isPresented: $viewModel.showImagePicker) {
//            ImagePicker(isCamera: $viewModel.isCamera, selectedImage: $viewModel.selectedImage, imageSelected: imageSelected)
//        }
//    }
//}
//
//extension AvatarComponentView {
//    private var circularImageComponent: some View {
//        Image(systemName: "person.circle")
//            .resizable()
//            .frame(width: 140, height: 140)
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
//    }
//}

import SwiftUI
import PhotosUI

struct AvatarComponentView: View {
    @StateObject var viewModel = AvatarViewModel()
    
    var externalImage: UIImage?
    var enablePress: Bool
    var imageSelected: (UIImage) -> Void
    
    var body: some View {
        VStack {
            if let selectedImage = viewModel.selectedImage ?? externalImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                    .onAppear {
                        imageSelected(selectedImage)
                    }
                
            } else {
                circularImageComponent
            }
        }
        .onTapGesture {
            if (enablePress) {
                viewModel.showActionSheet = true
            }
        }
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("Selecciona una opción"),
                buttons: [
                    .default(Text("Cámara")) {
                        viewModel.selectCamera()
                    },
                    .default(Text("Galería")) {
                        viewModel.selectGallery()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(isCamera: $viewModel.isCamera, selectedImage: $viewModel.selectedImage, imageSelected: imageSelected)
        }
    }
}

extension AvatarComponentView {
    private var circularImageComponent: some View {
        Image(systemName: "person.circle")
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
    }
}

//#Preview {
//    AvatarComponentView(imageSelected: { image in }) // Ejemplo de imagen externa
//}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isCamera: Bool
    @Binding var selectedImage: UIImage?
    
    var imageSelected: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = isCamera ? .camera : .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = UIImage() as? UIImage {
                parent.selectedImage = image
                parent.imageSelected(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

//#Preview {
//    AvatarComponentView(imageSelected: { image in })
//}
