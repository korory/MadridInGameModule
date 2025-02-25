//
//  PullToRefreshScrollView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//

import SwiftUI

struct PullToRefreshScrollView<Content: View>: View {
    let content: () -> Content
    let refreshAction: () async -> Void

    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 50) // Espacio para la animación de refresh
                content()
            }
            .frame(maxWidth: .infinity)
        }
        .refreshable {
            await refreshAction()
        }
    }
}
