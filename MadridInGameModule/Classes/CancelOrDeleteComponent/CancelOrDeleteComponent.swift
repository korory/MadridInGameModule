//
//  CancelOrDeleteComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct CancelOrDeleteComponent: View {
    var title = ""
    var subtitle = ""
    let rejectedAction: () -> Void
    let aceptedAction: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            titleBanner
            if !subtitle.isEmpty {
                subtitleBanner
            }
            confirmCancelButtonsComponent
        }
    }
}

extension CancelOrDeleteComponent {
    private var titleBanner: some View {
        Text(title)
            .font(.largeTitle)
            .foregroundStyle(Color.white)
    }
    
    private var subtitleBanner: some View {
        Text(subtitle)
            .font(.body)
            .foregroundStyle(Color.white)
    }
    
    private var confirmCancelButtonsComponent: some View {
        HStack {
            CustomButton(text: "Aceptar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 180, heightButton: 50) {
                aceptedAction()
            }
                         .padding(.trailing, 10)
            CustomButton(text: "Rechazar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 180, heightButton: 50) {
                rejectedAction()
            }
        }
    }
}
