//
//  CustomTextField.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI
import Combine

struct FloatingTextField: View {
    
    let placeholderText: String
    @State private var text: String = ""
    
    let animation: Animation = .spring(response: 0.1, dampingFraction: 0.6)
    
    @State private var placeholderOffset: CGFloat = 0
    @State private var scaleEffectValue: CGFloat = 1.0
    @State private var errorMessage: String? = nil
    @State private var isEditing: Bool = false
    
    var isDescripcionTextfield: Bool = false
    
    private var onTextAction: ((_ oldValue: String, _ newValue: String) -> ())?
    
    init(text: String, placeholderText: String, isDescripcionTextfield: Bool = false, onTextAction: ((_: String, _: String) -> Void)? = nil) {
        self.text = text
        self.placeholderText = placeholderText
        self.isDescripcionTextfield = isDescripcionTextfield
        self.onTextAction = onTextAction
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .cornerRadius(10)
            
            ZStack(alignment: .leading) {
                placeholderBanner
                if isDescripcionTextfield {
                    textEditorComponent
                } else {
                    textfieldComponent
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15)
                                                               ))
        }
        .padding(.bottom, 10)
        .frame(height: isDescripcionTextfield ? 150 : 50)
        
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

extension FloatingTextField {
    
    private var placeholderBanner: some View {
        Text(placeholderText)
            .foregroundStyle(Color.cyan)
            .font(text.isEmpty ? .headline : .caption)
            .offset(y: isDescripcionTextfield ? placeholderOffset - 40 : placeholderOffset)
            .scaleEffect(scaleEffectValue, anchor: .leading)
            .animation(animation, value: text.isEmpty)
    }
    
    private var textfieldComponent: some View {
        TextField("", text: $text, onEditingChanged: { isEditing in
            withAnimation {
                placeholderOffset = isEditing || !text.isEmpty ? -20 : 0
                scaleEffectValue = isEditing || !text.isEmpty ? 0.85 : 1
            }
        })
        .font(.headline)
        .foregroundStyle(Color.white)
        .padding(.top, 10)
        .onReceive(Just(text)) { newValue in
            //.onChange(of: text) { oldValue, newValue in
            withAnimation {
                placeholderOffset = newValue.isEmpty ? 0 : -20
                scaleEffectValue = newValue.isEmpty ? 1 : 0.85
            }
            onTextAction?("", newValue)
            //onTextAction?(oldValue, newValue)
            
        }
    }
    
    private var textEditorComponent: some View {
        TextEditor(text: $text)
        //.colorMultiply(Color.black.opacity(0.7))
            .foregroundStyle(Color.white)
            .font(.headline)
            .padding(.top, 10)
            .frame(height: 120) // Ajustar altura para permitir 4 líneas
        //.scrollContentBackground(.hidden) // Para mantener el fondo oscuro
            .onReceive(Just(text)) { newValue in
                //.onChange(of: text) { oldValue, newValue in
                withAnimation {
                    placeholderOffset = newValue.isEmpty ? -10 : -25
                    scaleEffectValue = newValue.isEmpty ? 1 : 0.85
                }
                onTextAction?("", newValue)
                //onTextAction?(oldValue, newValue)
            }
    }
    
    public func onTextChange(_ onTextAction: @escaping ((_ oldValue: String, _ newValue: String) -> ())) -> Self {
        var view = self
        view.onTextAction = onTextAction
        return view
    }
    
    public func setErrorMessage(_ message: String?) {
        self.errorMessage = message
    }
}
