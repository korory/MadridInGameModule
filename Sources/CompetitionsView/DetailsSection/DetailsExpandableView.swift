//
//  DetailsExpandableView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

import SwiftUI

struct DetailsExpandableView: View {
    var title: String
    var content: String?
    var image: String
    var environmentManager = EnvironmentManager()
    @State private var decodedContent: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(image)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .tint(.purple)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .frame(height: 100)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .cornerRadius(15)
                                .frame(width: 280, height: 100)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    Text(title.uppercased())
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)

                    if !decodedContent.isEmpty {
                        ExpandableDetailCellView(title: title, content: decodedContent)
                    } else {
                        Text("No hay información disponible.".localized)
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom)
            }
        }
        .onAppear {
            decodedContent = content?.decoded ?? ""
        }
    }
}
