//
//  RuleCellView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

import SwiftUI

struct RuleCellView: View {
    let index: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index)")
                .font(.madridInGameiOSFont(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 28, height: 28)
                .background(Color.cyan)
                .clipShape(Circle())

            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
