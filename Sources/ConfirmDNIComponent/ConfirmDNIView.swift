import SwiftUI

struct ConfirmDNIView: View {
    let action: (String) -> Void
    @State private var dni: String = ""
    @State private var isDNIValid: Bool = true
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                titleAndSubtitleComponent

                VStack(alignment: .leading, spacing: 8) {
                    FloatingTextField(text: dni, placeholderText: "DNI")
                        .onTextChange { oldValue, newValue in
                            dni = newValue
                            isDNIValid = validateDNI(newValue)
                            errorMessage = isDNIValid ? nil : "El DNI debe tener 8 dígitos seguidos de una letra mayúscula."
                        }

                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }
                }

                textComponent

                HStack {
                    acceptButton
                    cancelButton
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
            .padding()
            .shadow(radius: 10)
        }
    }
}

extension ConfirmDNIView {
    private var titleAndSubtitleComponent: some View {
        VStack(spacing: 8) {
            Text("Confirma tu DNI")
                .font(.madridInGameiOSFont(size: 25))
                .foregroundStyle(Color.white)

            Text("Introduce y confirma tu DNI")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.85))
        }
    }

    private var textComponent: some View {
        Text("Importante: Debes llevar tu DNI contigo para poder acceder al centro la primera vez y validar tu usuario.")
            .font(.madridInGameiOSFont(size: 12))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }

    private var acceptButton: some View {
        CustomButton(
            text: "Aceptar",
            needsBackground: true,
            backgroundColor: isDNIValid ? Color.cyan : Color.gray,
            pressEnabled: isDNIValid,
            widthButton: 180,
            heightButton: 50
        ) {
            action(dni)
        }
        .padding(.top, 12)
    }

    private var cancelButton: some View {
        CustomButton(
            text: "Cancel",
            needsBackground: true,
            backgroundColor: Color.cyan,
            pressEnabled: true,
            widthButton: 180,
            heightButton: 50
        ) {
            action("")
        }
        .padding(.top, 12)
    }

    private func validateDNI(_ dni: String) -> Bool {
        let dniRegex = "^[0-9]{8}[A-Za-z]$"
        return NSPredicate(format: "SELF MATCHES %@", dniRegex).evaluate(with: dni)
    }
}

#Preview {
    ConfirmDNIView(action: { _ in })
}
