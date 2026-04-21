//
//  ExpandableDetailCellView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

import SwiftUI

struct ExpandableDetailCellView: View {
    let title: String
    let content: String
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.madridInGameiOSFont(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.cyan)
                        .frame(width: 16, height: 16)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }

            if isExpanded {
                Text(content)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }

            Divider()
                .background(Color.white.opacity(0.15))
        }
        .background(Color.black.opacity(0.6))
        .cornerRadius(8)
    }
}
