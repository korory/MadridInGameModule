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
    private let environmentManager = EnvironmentManager()

    var imageId: String?
    
    var body: some View {
        loadImageView
    }
    
    // Extracted image loading logic to avoid repetition
    @ViewBuilder
    private var loadImageView: some View {
        if let imageId {
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(imageId)")) { phase in
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
        } else {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
                .foregroundColor(.white)
                .overlay(bottomOverlay, alignment: .bottom)
        }
    }

    // Bottom overlay for "Pulsar para cambiar" text
    private var bottomOverlay: some View {
        Group {
                Text("Pulsar para cambiar")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
                    .padding(5)
        }
    }
}

struct NonCachedAsyncImage<Placeholder: View, ErrorView: View, Content: View>: View {
    let url: URL?
    let disableCache: Bool
    let placeholder: () -> Placeholder
    let errorView: () -> ErrorView
    let content: (Image) -> Content

    @State private var loadedImage: Image? = nil
    @State private var isLoading = false
    @State private var hasError = false

    var body: some View {
        Group {
            if isLoading {
                placeholder()
            } else if hasError {
                errorView()
            } else if let image = loadedImage {
                content(image)
            } else {
                placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        isLoading = true
        hasError = false
        loadedImage = nil
        
        guard let url else {
            hasError = true
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        if disableCache {
            request.cachePolicy = .reloadIgnoringCacheData
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let _ = error {
                    hasError = true
                    return
                }

                guard let data = data, let uiImage = UIImage(data: data) else {
                    hasError = true
                    return
                }

                loadedImage = Image(uiImage: uiImage)
            }
        }
        .resume()
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
}

// MARK: - Coordinator Extension
extension ImagePicker {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
