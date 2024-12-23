//
//  TeamReservationCellComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct TeamReservationCellComponentView: View {
    @ObservedObject var viewModel: TeamReservationCellComponentViewModel
    let action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
            
            VStack (alignment: .leading, spacing: 15){
                iconDateAndRemoveBannerComponent
                trainningLocationComponent
                trainningHoursPlayersComponent
                playersCarouselComponent
                if (!viewModel.descriptionText.isEmpty) {
                    descriptionComponent
                }
                seeDetailsAndEditButtonsComponent
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 10))
    }
}

extension TeamReservationCellComponentView {
    
    private var iconDateAndRemoveBannerComponent: some View {
        HStack (spacing: 10){
            Image(systemName: viewModel.trainingLocationImage)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.yellow)
                .padding(.trailing, 2)
            
            Text(viewModel.dateSelected)
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
            
            Spacer()
            
            Button {
                viewModel.performAction(.removeCell, action: action)
            } label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.red)
            }
        }
    }
    
    private var trainningLocationComponent: some View {
        VStack (alignment: .leading){
            if #available(iOS 16.0, *) {
                Text(viewModel.getTrainingLocationText())
                    .foregroundStyle(Color.white.opacity(0.7))
                    .fontWeight(.bold)
            } else {
                Text(viewModel.getTrainingLocationText())
                    .foregroundStyle(Color.white.opacity(0.7))
                    .font(.footnote.weight(.bold))
            }
        }
    }
    
    private var trainningHoursPlayersComponent: some View {
        HStack {
            Text(viewModel.hoursSelected.count > 1
                 ? "Horas: \(viewModel.hoursSelected.joined(separator: ", "))"
                 : "Hora: \(viewModel.hoursSelected.joined(separator: ", "))")
            .font(.system(size: 15))
            .foregroundStyle(Color.white)
        }
    }
    
    private var playersCarouselComponent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.players, id: \.id) { player in
                    VStack {
                        Image(uiImage: player.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    private var descriptionComponent: some View {
        ScrollView {
            Text(viewModel.descriptionText)
                .font(.body)
                .foregroundStyle(Color.white)
                .lineLimit(nil)
        }
        .frame(height: 70)
    }
    
    private var seeDetailsAndEditButtonsComponent: some View {
        HStack () {
            
            Spacer()
            
            Button {
                action(.seeDetails)
            } label: {
                HStack {
                    Image(systemName: "eye")
                        .resizable()
                        .frame(width: 28, height: 20)
                        .foregroundStyle(Color.cyan)
                    
                    Text("Ver detalles")
                        .foregroundStyle(Color.cyan)
                }
            }
            
            Spacer()
            
            Button {
                action(.editTraining)
            } label: {
                Text("Editar")
                    .foregroundStyle(Color.red)
                
            }
            
            Spacer()
        }
    }
}


