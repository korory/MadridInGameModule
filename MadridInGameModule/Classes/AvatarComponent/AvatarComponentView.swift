////
////  AvatarComponentView.swift
////  CalendarComponent
////
////  Created by Arnau Rivas Rivas on 11/10/24.
////
//
import SwiftUI
import PhotosUI

struct AvatarComponentView: View {
    @StateObject var viewModel: AvatarViewModel
    var enablePress: Bool
    var imageSelected: (UIImage) -> Void
    
    var body: some View {
        VStack {
            if enablePress {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .onAppear {
                            imageSelected(selectedImage)
                        }
                } else {
                    loadImageView
                }
            } else {
                loadImageView
            }
        }
        .onAppear {
            viewModel.selectedImage = nil
        }
        .onTapGesture {
            if enablePress {
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
    
    // Extracted image loading logic to avoid repetition
    private var loadImageView: some View {
        AsyncImage(url: URL(string: "\(viewModel.environmentManager.getBaseURL())/assets/\(viewModel.imageId)")) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 50, height: 50)
                    .tint(.purple)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .overlay(bottomOverlay, alignment: .bottom)
            case .failure:
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .overlay(bottomOverlay, alignment: .bottom)
            @unknown default:
                EmptyView()
            }
        }
        .onAppear {
            self.viewModel.selectedImage = nil
        }
    }

    // Bottom overlay for "Pulsar para cambiar" text
    private var bottomOverlay: some View {
        Group {
            if enablePress {
                Text("Pulsar para cambiar")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
                    .padding(5)
            }
        }
    }
}

// MARK: - ImagePicker corregido
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
            if let image = info[.originalImage] as? UIImage {
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


//struct AvatarComponentView: View {
//    @StateObject var viewModel: AvatarViewModel
//    var enablePress: Bool
//    var imageSelected: (UIImage) -> Void
//    
//    var body: some View {
//        VStack {
//            if enablePress {
//                if let selectedImage = viewModel.selectedImage {
//                Image(uiImage: selectedImage)
//                    .resizable()
//                    .frame(width: 140, height: 140)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
//                    .onAppear {
//                        imageSelected(selectedImage)
//                    }
//                } else {
//                    AsyncImage(url: URL(string: "\(viewModel.environmentManager.getBaseURL())/assets/\(viewModel.imageId)")) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView()
//                                .frame(width: 50, height: 50)
//                                .tint(.purple)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 140, height: 140)
//                                .clipShape(Circle())
//                                .overlay(
//                                    Group {
//                                        if enablePress {
//                                            Text("Pulsar para cambiar")
//                                                .foregroundColor(.white)
//                                                .font(.caption)
//                                                .padding(8)
//                                                .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
//                                                .padding(5)
//                                        }
//                                    },
//                                    alignment: .bottom
//
//                                )
//                        case .failure:
//                            Image(systemName: "person.circle")
//                                .resizable()
//                                .frame(width: 140, height: 140)
//                                .clipShape(Circle())
//                                .foregroundColor(.white)
//                                .overlay(
//                                    Group {
//                                        if enablePress {
//                                            Text("Pulsar para cambiar")
//                                                .foregroundColor(.white)
//                                                .font(.caption)
//                                                .padding(8)
//                                                .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
//                                                .padding(5)
//                                        }
//                                    },
//                                    alignment: .bottom
//                                )
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                }
//            } else {
//                AsyncImage(url: URL(string: "\(viewModel.environmentManager.getBaseURL())/assets/\(viewModel.imageId)")) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(width: 50, height: 50)
//                            .tint(.purple)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 140, height: 140)
//                            .clipShape(Circle())
//                            .overlay(
//                                Group {
//                                    if enablePress {
//                                        Text("Pulsar para cambiar")
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                            .padding(8)
//                                            .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
//                                            .padding(5)
//                                    }
//                                },
//                                alignment: .bottom
//
//                            )
//                    case .failure:
//                        Image(systemName: "person.circle")
//                            .resizable()
//                            .frame(width: 140, height: 140)
//                            .clipShape(Circle())
//                            .foregroundColor(.white)
//                            .overlay(
//                                Group {
//                                    if enablePress {
//                                        Text("Pulsar para cambiar")
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                            .padding(8)
//                                            .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
//                                            .padding(5)
//                                    }
//                                },
//                                alignment: .bottom
//                            )
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//            }
//        }
//        .onAppear(perform: {
//            self.viewModel.selectedImage = nil
//        })
//        .onTapGesture {
//            if (enablePress) {
//                viewModel.showActionSheet = true
//            }
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
//// MARK: - ImagePicker corregido
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var isCamera: Bool
//    @Binding var selectedImage: UIImage?
//    
//    var imageSelected: (UIImage) -> Void
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = isCamera ? .camera : .photoLibrary
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        var parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.selectedImage = image
//                parent.imageSelected(image)
//            }
//            picker.dismiss(animated: true)
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//        }
//    }
//}
