//
//  ExpandableDetailCellView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 31/3/25.
//

import SwiftUI

struct ExpandableDetailCellView: View {
    let icon: String        // SF Symbol name
    let title: String
    let description: String
    let color: Color
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 0) {
            headerRow
            if isExpanded {
                expandedContent
            }
        }
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color.opacity(0.45), Color.black.opacity(0.75)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }

    private var headerRow: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    )

                Text(title)
                    .font(.madridInGameiOSFont(size: 16))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: isExpanded ? "chevron.up" : "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }

    private var expandedContent: some View {
        Text(description)
            .font(.body)
            .foregroundColor(.white.opacity(0.85))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .transition(.opacity)
    }
}
