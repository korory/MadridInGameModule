//
//  TournamentCellView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 11/2/25.
//

import SwiftUI
import Foundation

struct TournamentCellView: View {
    let date: String
    let name: String
    let statusString: String
    
    var body: some View {
        VStack {
            HStack {
                rectangleDateNumber
                tornamentNameAndStatus
                Spacer()
            }
            .padding()
            
            subscribeButton
        }
        .background(Color.black.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

extension TournamentCellView {
    
    private var rectangleDateNumber: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.pink, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 70, height: 70)
                .overlay(
                    VStack {
                        Text(getDayAndMonth()?.day ?? "")
                            .font(.custom("Madridingamefont-Regular", size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(getDayAndMonth()?.month ?? "") // Cambia este segundo día si es necesario
                            .font(.custom("Madridingamefont-Regular", size: 10))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                )
            Spacer()
        }
    }
    
    private var tornamentNameAndStatus: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(name)
                .font(.custom("Madridingamefont-Regular", size: 20))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            Text(statusString.capitalized)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
    }
    
    
    private var subscribeButton: some View {
        HStack (alignment: .center, spacing: 5){
            Text("Inscríbete")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            Image(systemName: "chevron.forward.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
        }
        .padding(.top, 2)
        .padding(.bottom, 20)
    }
    
    func getDayAndMonth() -> (day: String, month: String)? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: date) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
            let day = dayFormatter.string(from: date)
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            monthFormatter.locale = Locale(identifier: "es_ES")
            let month = monthFormatter.string(from: date)
            
            return (day: day, month: month)
        } else {
            return nil
        }
    }
}

