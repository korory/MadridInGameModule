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
    var acceptTitle: String?
    var cancelTitle: String?
    let rejectedAction: () -> Void
    let acceptedAction: () -> Void
    
    var body: some View {
        VStack (alignment: .center, spacing: 20){
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
            .font(.madridInGameiOSFont(size: 25))
            .foregroundStyle(Color.white)
    }
    
    private var subtitleBanner: some View {
        Text(subtitle)
            .font(.madridInGameiOSFont(size: 17))
            .foregroundStyle(Color.white)
    }
    
    private var confirmCancelButtonsComponent: some View {
        HStack {
            CustomButton(text: acceptTitle ?? "Aceptar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 165, heightButton: 50) {
                acceptedAction()
            }
                         .padding(.trailing, 10)
            CustomButton(text: cancelTitle ?? "Rechazar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 165, heightButton: 50) {
                rejectedAction()
            }
        }
    }
}
