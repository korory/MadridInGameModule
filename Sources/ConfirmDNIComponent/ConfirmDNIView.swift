import SwiftUI

// MARK: - Document Type

enum DocumentType: CaseIterable {
    case dniId, nie, passport

    var label: String {
        switch self {
        case .dniId:    return "DNI / ID"
        case .nie:      return "NIE"
        case .passport: return "Pasaporte".localized
        }
    }

    var confirmTitle: String {
        switch self {
        case .dniId:    return "Confirma tu DNI / ID".localized
        case .nie:      return "Confirma tu NIE".localized
        case .passport: return "Confirma tu Pasaporte".localized
        }
    }

    var introTitle: String {
        switch self {
        case .dniId:    return "Introduce y confirma tu DNI / ID".localized
        case .nie:      return "Introduce y confirma tu NIE".localized
        case .passport: return "Introduce y confirma tu Pasaporte".localized
        }
    }

    var validationError: String {
        switch self {
        case .dniId:
            return "El documento no corresponde a ningún formato de DNI o ID europeo reconocido.".localized
        case .nie:
            return "El NIE debe comenzar con X, Y o Z, seguido de 7 dígitos y una letra.".localized
        case .passport:
            return "El pasaporte no corresponde a ningún formato reconocido.".localized
        }
    }

    func validate(_ value: String) -> Bool {
        switch self {
        case .dniId:    return DocumentValidator.validateDNI(value) || DocumentValidator.validateEuropeanID(value)
        case .nie:      return DocumentValidator.validateNIE(value)
        case .passport: return DocumentValidator.validatePassport(value)
        }
    }
}

// MARK: - Document Validator

private enum DocumentValidator {

    // MARK: DNI — 8 digits + check letter with digit verification

    static func validateDNI(_ value: String) -> Bool {
        let upper = value.uppercased()
        guard NSPredicate(format: "SELF MATCHES %@", "^[0-9]{8}[A-Z]$").evaluate(with: upper) else { return false }
        return checkDigitValid(upper)
    }

    // MARK: NIE — X/Y/Z + 7 digits + check letter with digit verification

    static func validateNIE(_ value: String) -> Bool {
        let upper = value.uppercased()
        guard NSPredicate(format: "SELF MATCHES %@", "^[XYZ][0-9]{7}[A-Z]$").evaluate(with: upper) else { return false }
        return checkDigitValid(upper)
    }

    // Shared check-digit validation for DNI and NIE
    private static func checkDigitValid(_ upper: String) -> Bool {
        let validChars = "TRWAGMYFPDXBNJZSQVHLCKET"
        var normalized = upper
        if normalized.hasPrefix("X")      { normalized = "0" + normalized.dropFirst() }
        else if normalized.hasPrefix("Y") { normalized = "1" + normalized.dropFirst() }
        else if normalized.hasPrefix("Z") { normalized = "2" + normalized.dropFirst() }
        guard let number = Int(normalized.dropLast()),
              let expected = validChars.enumerated().first(where: { $0.offset == number % 23 })?.element
        else { return false }
        return upper.last.map(String.init) == String(expected)
    }

    // MARK: European national ID cards

    static func validateEuropeanID(_ value: String) -> Bool {
        let input = value.uppercased()
        return euIdPatterns.contains {
            NSPredicate(format: "SELF MATCHES[c] %@", $0).evaluate(with: input)
        }
    }

    // Per-country national ID card number patterns.
    // Sources: official document specifications and ICAO/EU standards.
    private static let euIdPatterns: [String] = [
        // AT – Austria Personalausweis: letter + 8 alphanumeric
        "^[A-Z][A-Z0-9]{8}$",
        // BE – Belgium eID: 12 digits
        "^[0-9]{12}$",
        // BG – Bulgaria national ID: 10 digits (EGN)
        "^[0-9]{10}$",
        // CH – Switzerland AHV (not EU but common in Spain): 13 digits
        "^[0-9]{13}$",
        // CY – Cyprus: K or P + 8 digits
        "^[KP][0-9]{8}$",
        // CZ – Czech Republic: 9 or 10 digits
        "^[0-9]{9,10}$",
        // DE – Germany Personalausweis: 9 alphanumeric (letter + 8 chars)
        "^[A-Z0-9]{9}$",
        // DK – Denmark CPR: 10 digits (DDMMYY + 4)
        "^[0-9]{10}$",
        // EE – Estonia personal code: 11 digits
        "^[0-9]{11}$",
        // FI – Finland HETU: DDMMYY + separator (-, +, A) + 3 digits + control char
        "^[0-9]{6}[-+A][0-9]{3}[0-9A-FHJ-NPR-Y]$",
        // FR – France CNI: 12 digits (new) or 9 alphanumeric (old)
        "^[0-9F][0-9]{11}$",
        "^[0-9A-Z]{9}$",
        // GR – Greece: 1-2 letters + 6-7 digits
        "^[A-Z]{1,2}[0-9]{6,7}$",
        // HR – Croatia OIB: 11 digits
        "^[0-9]{11}$",
        // HU – Hungary: 6 digits + 2 letters
        "^[0-9]{6}[A-Z]{2}$",
        // IE – Ireland PPS: 7 digits + 1-2 letters
        "^[0-9]{7}[A-Z]{1,2}$",
        // IT – Italy CIE: 2 letters + 5 digits + 2 letters OR 2 letters + 7 digits + 2 letters
        "^[A-Z]{2}[0-9]{5}[A-Z]{2}$",
        "^[A-Z]{2}[0-9]{7}[A-Z]{2}$",
        // LT – Lithuania personal code: 11 digits
        "^[0-9]{11}$",
        // LU – Luxembourg: 13 digits
        "^[0-9]{13}$",
        // LV – Latvia: old format NNNNNN-NNNNN, new format 32-digit starting with 3-9
        "^[0-9]{6}-[0-9]{5}$",
        "^[3-9][0-9]{10}$",
        // MT – Malta: 7 digits + letter
        "^[0-9]{7}[A-Z]$",
        // NL – Netherlands: 9 alphanumeric
        "^[A-Z0-9]{9}$",
        // NO – Norway personnummer (Schengen): 11 digits
        "^[0-9]{11}$",
        // PL – Poland: 3 letters + 6 digits
        "^[A-Z]{3}[0-9]{6}$",
        // PT – Portugal Cartão de Cidadão: 8 digits + digit + 2 letters + digit
        "^[0-9]{8}[0-9][A-Z]{2}[0-9]$",
        // RO – Romania CNP: 13 digits
        "^[0-9]{13}$",
        // SE – Sweden personnummer: 10 or 12 digits (with optional separator)
        "^[0-9]{10}$",
        "^[0-9]{12}$",
        "^[0-9]{6}[-+][0-9]{4}$",
        // SI – Slovenia EMŠO: 13 digits
        "^[0-9]{13}$",
        // SK – Slovakia: 9 or 10 digits
        "^[0-9]{9,10}$",
    ]

    // MARK: Passport — per-country regex (mirrors validator.js)

    static func validatePassport(_ value: String) -> Bool {
        let input = value.uppercased()
        return passportPatterns.contains {
            NSPredicate(format: "SELF MATCHES[c] %@", $0).evaluate(with: input)
        }
    }

    private static let passportPatterns: [String] = [
        "^A[0-9]{8}$",                             // AF
        "^[A-Z]{2}[0-9]{7}$",                      // AM, BY, JP, LY, PK, PL
        "^[A-Z]{3}[0-9]{6}[A-Z0-9]$",              // AR
        "^[A-Z][0-9]{7}$",                          // AT, AU, CH, IN
        "^[A-Z]{2}[0-9]{6}$",                       // BE, BR, CA, NZ, UA
        "^[0-9]{9}$",                                // BG, DK, DZ, GB, RU, US
        "^[GE][0-9]{8}$",                            // CN
        "^[KPE][0-9]{8}$",                           // CY
        "^[0-9]{8}$",                                // CZ, SE, SK
        "^[CFGHJKLMNPRTVWXYZ0-9]{9}$",              // DE
        "^[A-Z][0-9]{7}$|^[A-Z]{2}[0-9]{7}$",      // EE
        "^[A-Z0-9]{9}$",                             // ES, IT, LU
        "^[A-Z0-9][0-9]{8}$",                       // FI
        "^[0-9]{2}[A-Z]{2}[0-9]{5}$",               // FR
        "^[AEK][0-9]{7}$",                           // GR
        "^[A-Z]{2}[0-9]{6}[A-Z]$",                  // HR
        "^[A-Z]{2}[0-9]{6}$|^[A-Z]{2}[0-9]{7}$",   // HU
        "^[A-Z0-9]{2}[0-9]{7}$",                    // IE
        "^[A-Z][0-9]{8}$",                           // IR, MX, TH, TR
        "^A[0-9]{7}$",                               // IS
        "^[MS][0-9]{8}$",                            // KR
        "^[A-Z0-9]{8}$",                             // LT
        "^[A-Z0-9]{2}[0-9]{7}$",                    // LV
        "^[KL][0-9]{8}$",                            // MO
        "^[AHK][0-9]{8}$",                           // MY
        "^[A-Z]{2}[0-9]{7}$|^[A-Z][0-9]{8}$",      // MZ
        "^[A-Z]{2}[A-Z0-9][0-9]{6}[A-Z]$",         // NL
        "^[A-Z]{1,2}[0-9]{6,7}[A-Z]?$",             // PH
        "^[A-Z][0-9]{6}$",                           // PT
        "^[0-9]{8,9}$",                              // RO
        "^[A-Z][0-9]{7}$",                           // SL
    ]
}

// MARK: - View

struct ConfirmDNIView: View {
    var serverError: String? = nil
    let action: (String) -> Void

    @State private var documentType: DocumentType = .dniId
    @State private var inputValue: String = ""
    @State private var isValid: Bool = true
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                titleAndSubtitleComponent
                documentTypePicker
                inputField
                textComponent
                HStack { acceptButton; cancelButton }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
            .padding()
            .shadow(radius: 10)
        }
    }
}

// MARK: - Subviews

extension ConfirmDNIView {

    private var titleAndSubtitleComponent: some View {
        VStack(spacing: 8) {
            Text(documentType.confirmTitle)
                .font(.madridInGameiOSFont(size: 23))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .animation(.none, value: documentType)

            Text(documentType.introTitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
                .animation(.none, value: documentType)
        }
    }

    private var documentTypePicker: some View {
        HStack(spacing: 0) {
            ForEach(DocumentType.allCases, id: \.label) { type in
                pickerButton(type)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.cyan.opacity(0.5), lineWidth: 1))
    }

    private func pickerButton(_ type: DocumentType) -> some View {
        Button(action: {
            documentType = type
            inputValue = ""
            isValid = true
            errorMessage = nil
        }) {
            Text(type.label)
                .font(.madridInGameiOSFont(size: 13))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(documentType == type ? Color.cyan : Color.white.opacity(0.12))
                .foregroundColor(documentType == type ? Color.black : Color.white)
        }
    }

    private var inputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            FloatingTextField(text: inputValue, placeholderText: documentType.label)
                .onTextChange { _, newValue in
                    inputValue = newValue
                    isValid = documentType.validate(newValue)
                    errorMessage = isValid ? nil : documentType.validationError
                }

            if let error = serverError ?? errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }
        }
    }

    private var textComponent: some View {
        Text("Importante: Debes llevar tu documento de identidad contigo para poder acceder al centro la primera vez y validar tu usuario.".localized)
            .font(.madridInGameiOSFont(size: 12))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }

    private var acceptButton: some View {
        CustomButton(
            text: "Aceptar".localized,
            needsBackground: true,
            backgroundColor: isValid ? Color.cyan : Color.gray,
            pressEnabled: isValid,
            widthButton: 160,
            heightButton: 50
        ) { action(inputValue) }
        .padding(.top, 8)
    }

    private var cancelButton: some View {
        CustomButton(
            text: "Cancelar".localized,
            needsBackground: true,
            backgroundColor: Color.cyan,
            pressEnabled: true,
            widthButton: 160,
            heightButton: 50
        ) { action("") }
        .padding(.top, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfirmDNIView(action: { _ in })
    }
}
