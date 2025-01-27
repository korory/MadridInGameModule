import SwiftUI

struct ProfileInformationComponentView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dni: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var phone: String = ""
    @State private var avatar: UIImage? = UIImage()
    
    var user: User?
    
    init(user: User?) {
        self.user = user
        _firstName = State(initialValue: user?.firstName ?? "")
        _lastName = State(initialValue: user?.lastName ?? "")
        _dni = State(initialValue: user?.dni ?? "")
        _email = State(initialValue: user?.email ?? "")
        _username = State(initialValue: user?.username ?? "")
        _phone = State(initialValue: user?.phone ?? "")
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 40) {
                ScrollView {
                    titleComponent
                    componentAvatarSelector
                    formComponent
                    buttonsDiscardSaveComponent
                }
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

extension ProfileInformationComponentView {
    private var titleComponent: some View {
        HStack {
            Text("SOBRE MÍ")
                .font(.title)
                .bold()
                .foregroundStyle(Color.white)
            Spacer()
        }
    }
    
    private var formComponent: some View {
        VStack(alignment: .leading, spacing: 20) {
            FloatingTextField(text: firstName, placeholderText: "Nombre")
            FloatingTextField(text: lastName, placeholderText: "Apellidos")
            FloatingTextField(text: dni, placeholderText: "DNI")
            FloatingTextField(text: email, placeholderText: "Email")
            FloatingTextField(text: username, placeholderText: "Nick")
            FloatingTextField(text: phone, placeholderText: "Teléfono (Opcional)")
        }
        .padding(.bottom, 20)
    }
    
    private var componentAvatarSelector: some View {
        AvatarComponentView(imageSelected: { image in
            avatar = image
        })
        .padding(.bottom, 20)
    }
    
    private var buttonsDiscardSaveComponent: some View {
        HStack(spacing: 10) {
            CustomButton(text: "Descartar",
                         needsBackground: false,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 170, heightButton: 40) {
                discardChanges()
            }
            .padding(.trailing, 10)
            
            CustomButton(text: "Guardar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 170, heightButton: 40) {
                saveChanges()
            }
        }
    }
    
    private func discardChanges() {
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        dni = user?.dni ?? ""
        email = user?.email ?? ""
        username = user?.username ?? ""
        phone = user?.phone ?? ""
        avatar = nil
    }
    
    private func saveChanges() {
        // Lógica para guardar los datos
        print("Cambios guardados:")
        print("Nombre: \(firstName)")
        print("Apellidos: \(lastName)")
        print("DNI: \(dni)")
        print("Email: \(email)")
        print("Nick: \(username)")
        print("Teléfono: \(phone)")
    }
}
