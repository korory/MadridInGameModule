import SwiftUI

struct ProfileInformationComponentView: View {
    @StateObject private var viewModel: ProfileInformationViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ProfileInformationViewModel())
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView(message: "Actualizando Perfil...".localized)
            } else {
                VStack(spacing: 10) {
                    titleComponent
                    ScrollView {
                        componentAvatarSelector
                            .actionSheet(isPresented: $viewModel.showActionSheet) {
                                ActionSheet(
                                    title: Text("Selecciona una opción".localized),
                                    buttons: [
                                        .default(Text("Cámara".localized)) {
                                            viewModel.selectCamera()
                                        },
                                        .default(Text("Galería".localized)) {
                                            viewModel.selectGallery()
                                        },
                                        .cancel()
                                    ]
                                )
                            }
                        formComponent
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                    
                    editButton
                        .padding(.bottom, 10)
                }
                .onDisappear(perform: {
                    self.viewModel.isEditing = false
                })
                .padding(.top, 10)
                
                if viewModel.showToastSuccess {
                    ToastMessage(message: "¡Avatar Actualizado!".localized, duration: 2, success: true) {
                        self.viewModel.showToastSuccess = false
                    }
                } else if viewModel.showToastFailure {
                    ToastMessage(message: "Problema al actualizar el avatar".localized, duration: 2, success: false) {
                        self.viewModel.showToastFailure = false
                    }
                }
            }
        }
        .onAppear {
            viewModel.selectedImage = nil
        }
        .onTapGesture {
            viewModel.showActionSheet = true
        }
        .fullScreenCover(isPresented: $viewModel.showImagePicker) {
            ImagePicker(isCamera: $viewModel.isCamera, selectedImage: $viewModel.selectedImage, imageSelected: { image in
                Task {
                    viewModel.isLoading = true
                    await viewModel.saveChanges(image: image)
                    viewModel.isLoading = false
                }
            })
            .ignoresSafeArea()
        }
    }
}

extension ProfileInformationComponentView {
    private var titleComponent: some View {
        HStack {
            Text("SOBRE MÍ".localized)
                .font(.madridInGameiOSFont(size: 20))
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    private var formComponent: some View {
        VStack(alignment: .leading, spacing: 20) {
//            if viewModel.isEditing {
//                FloatingTextField(text: viewModel.firstName, placeholderText: "Nombre")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.firstName = newValue
//                    }
//                FloatingTextField(text: viewModel.lastName, placeholderText: "Apellidos")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.lastName = newValue
//                    }
//                FloatingTextField(text: viewModel.dni, placeholderText: "DNI")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.dni = newValue
//                    }
//                FloatingTextField(text: viewModel.email, placeholderText: "Email")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.email = newValue
//                    }
//                FloatingTextField(text: viewModel.username, placeholderText: "Nick")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.username = newValue
//                    }
//                FloatingTextField(text: viewModel.phone, placeholderText: "Teléfono (Opcional)")
//                    .onTextChange { oldValue, newValue in
//                        self.viewModel.phone = newValue
//                    }
//            } else {
            ProfileInfoView(text: viewModel.firstName, label: "dashboard.profile.about.form.name".localized)
            ProfileInfoView(text: viewModel.lastName, label: "dashboard.profile.about.form.surname".localized)
            ProfileInfoView(text: viewModel.dni, label: "dashboard.profile.about.form.dni".localized)
            ProfileInfoView(text: viewModel.email, label: "dashboard.profile.about.form.email".localized)
            ProfileInfoView(text: viewModel.username, label: "dashboard.profile.about.form.nick".localized)
            ProfileInfoView(text: viewModel.phone, label: "dashboard.profile.about.form.phone".localized)
            //}
        }
        .padding(.bottom, 20)
    }
    
    private var componentAvatarSelector: some View {
        AvatarComponentView(imageId: viewModel.avatar)
        .padding(.bottom, 20)
    }
    
    private var editButton: some View {
        VStack (alignment: .center){
            if !viewModel.isEditing {
                CustomButton(text: "dashboard.profile.about.title".localized, needsBackground: true, backgroundColor: .cyan, pressEnabled: true, widthButton: 280, heightButton: 20) {
                    viewModel.openSafariToPersonalArea()//toggleEditing()
                    //viewModel.toggleEditing()
                }
                //.padding(.bottom, 10)
                .padding()
            } else {
                HStack {
                    CustomButton(text: "dashboard.profile.about.form.discard".localized, needsBackground: false, backgroundColor: Color.cyan, pressEnabled: true, widthButton: 150, heightButton: 30) {
                        viewModel.discardChanges()
                    }
                    
                    CustomButton(text: "dashboard.profile.about.form.save".localized, needsBackground: true, backgroundColor: Color.cyan, pressEnabled: true, widthButton: 150, heightButton: 30) {
//                        Task {
//                            await viewModel.saveChanges()
//                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 10)
    }
}

struct ProfileInfoView: View {
    var text: String
    var label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.madridInGameiOSFont(size: 14))
                .foregroundColor(.gray.opacity(1.0))
            Spacer()
            Text(text)
                .font(.madridInGameiOSFont(size: 14))
                .foregroundColor(.white)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15)))
    }
}

