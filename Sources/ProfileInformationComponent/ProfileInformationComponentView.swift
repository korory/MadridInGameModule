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
                LoadingView(message: "Actualizando Perfil....")
            } else {
                VStack(spacing: 10) {
                    titleComponent
                    ScrollView {
                        componentAvatarSelector
                        formComponent
                    }
                    .padding()
                    
                    editButton
                        .padding(.bottom, 10)
                }
                .onDisappear(perform: {
                    self.viewModel.isEditing = false
                })
                .padding(.top, 10)
                
                if viewModel.showToastSuccess {
                    ToastMessage(message: "¡Perfil Actualizado!", duration: 2, success: true) {
                        self.viewModel.showToastSuccess = false
                    }
                } else if viewModel.showToastFailure {
                    ToastMessage(message: "Problema al actualizar perfil", duration: 2, success: false) {
                        self.viewModel.showToastFailure = false
                    }
                }
            }
        }
    }
}

extension ProfileInformationComponentView {
    private var titleComponent: some View {
        HStack {
            Text("SOBRE MÍ")
                .font(.custom("Madridingamefont-Regular", size: 20))
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    private var formComponent: some View {
        VStack(alignment: .leading, spacing: 20) {
            if viewModel.isEditing {
                FloatingTextField(text: viewModel.firstName, placeholderText: "Nombre")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.firstName = newValue
                    }
                FloatingTextField(text: viewModel.lastName, placeholderText: "Apellidos")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.lastName = newValue
                    }
                FloatingTextField(text: viewModel.dni, placeholderText: "DNI")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.dni = newValue
                    }
                FloatingTextField(text: viewModel.email, placeholderText: "Email")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.email = newValue
                    }
                FloatingTextField(text: viewModel.username, placeholderText: "Nick")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.username = newValue
                    }
                FloatingTextField(text: viewModel.phone, placeholderText: "Teléfono (Opcional)")
                    .onTextChange { oldValue, newValue in
                        self.viewModel.phone = newValue
                    }
            } else {
                ProfileInfoView(text: viewModel.firstName, label: "Nombre")
                ProfileInfoView(text: viewModel.lastName, label: "Apellidos")
                ProfileInfoView(text: viewModel.dni, label: "DNI")
                ProfileInfoView(text: viewModel.email, label: "Email")
                ProfileInfoView(text: viewModel.username, label: "Nick")
                ProfileInfoView(text: viewModel.phone, label: "Teléfono")
            }
        }
        .padding(.bottom, 20)
    }
    
    private var componentAvatarSelector: some View {
        AvatarComponentView(viewModel: AvatarViewModel(selectedImage: viewModel.newAvatar, imageId: viewModel.avatar), enablePress: viewModel.isEditing, imageSelected: { image in
            viewModel.newAvatar = image
        })
        .padding(.bottom, 20)
    }
    
    private var editButton: some View {
        VStack (alignment: .center){
            if !viewModel.isEditing {
                CustomButton(text: "Editar", needsBackground: true, backgroundColor: .cyan, pressEnabled: true, widthButton: 280, heightButton: 20) {
                    viewModel.toggleEditing()
                }
                //.padding(.bottom, 10)
                .padding()
            } else {
                HStack {
                    CustomButton(text: "Descartar", needsBackground: false, backgroundColor: Color.cyan, pressEnabled: true, widthButton: 150, heightButton: 30) {
                        viewModel.discardChanges()
                    }
                    
                    CustomButton(text: "Guardar", needsBackground: true, backgroundColor: Color.cyan, pressEnabled: true, widthButton: 150, heightButton: 30) {
                        Task {
                            await viewModel.saveChanges()
                        }
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
                .font(.custom("Madridingamefont-Regular", size: 14))
                .foregroundColor(.gray.opacity(1.0))
            Spacer()
            Text(text)
                .font(.custom("Madridingamefont-Regular", size: 14))
                .foregroundColor(.white)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15)))
    }
}
