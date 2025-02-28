//
//  FloatingTextFieldViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//


import SwiftUI
import Combine

class FloatingTextFieldViewModel: ObservableObject {
    @Published var text: String
    var placeholderText: String
    var isDescripcionTextfield: Bool
    var errorMessage: String?
    
    private var onTextAction: ((_ oldValue: String, _ newValue: String) -> Void)?
    
    init(text: String = "", placeholderText: String, isDescripcionTextfield: Bool = false, onTextAction: ((String, String) -> Void)? = nil) {
        self.text = text
        self.placeholderText = placeholderText
        self.isDescripcionTextfield = isDescripcionTextfield
        self.onTextAction = onTextAction
    }
    
    func setText(_ newText: String) {
        let oldValue = self.text
        self.text = newText
        onTextAction?(oldValue, newText)
    }
    
    func setErrorMessage(_ message: String?) {
        self.errorMessage = message
    }
}
