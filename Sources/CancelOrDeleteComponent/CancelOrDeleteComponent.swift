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
        VStack(spacing: 0) {
            // Icono decorativo
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan.opacity(0.8), .purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, 16)

            // Título
            Text(title)
                .font(.madridInGameiOSFont(size: 25))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)

            // Subtítulo
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.madridInGameiOSFont(size: 17))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            }

            // Botones
            VStack(spacing: 10) {
                // Botón principal (aceptar/confirmar)
                Button(action: acceptedAction) {
                    Text(acceptTitle ?? "Aceptar".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.cyan)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }

                // Botón secundario (cancelar/rechazar)
                Button(action: rejectedAction) {
                    Text(cancelTitle ?? "Rechazar".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                        .foregroundColor(.white.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 8)
        }
    }
}
