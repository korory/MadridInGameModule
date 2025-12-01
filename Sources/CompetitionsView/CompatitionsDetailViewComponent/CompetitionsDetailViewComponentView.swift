//
//  CompetitionsDetailViewComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

enum Tab {
    case overview
    case teams
    case schedule
    case results
    case tournaments
}

struct CompetitionsDetailViewComponentView: View {
    @ObservedObject var viewModel: CompetitionsDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 5) {
                titleBanner
                    .zIndex(10) // Asegurar que el banner esté por encima
                if viewModel.competitionsInformation.splits?.isEmpty == false {
                    
                    dropdownSplitSelectorComponent
                        .zIndex(5) // Dropdown por encima del TabView pero debajo del banner
                    
                    tabBarComponent
                        .zIndex(1) // TabView con menor zIndex
                } else {
                    Text("No hay información disponible.".localized)
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
        .onAppear() {
            viewModel.getFirstOptionSelected()
        }
    }
    
    private var titleBanner: some View {
        HStack (spacing: 25){
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44) // Área de toque más grande
            .contentShape(Rectangle()) // Asegurar que toda el área sea tocable
            
            Text((viewModel.competitionsInformation.title)!)
                .font(.madridInGameiOSFont(size: 25))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 5)
                .padding(.bottom, 8)
                .padding(.top, 7)
            
            Spacer()
        }
        .padding(.leading, 20)
        .background(Color.clear) // Fondo transparente pero interactuable
    }
    
    private var dropdownTitle: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Splits".localized, underlineColor: Color.cyan)
        }
        .padding(.leading, 20)
    }
    
    private var dropdownSplitSelectorComponent: some View {
        let options = viewModel.competitionsInformation.splits?.map { split in
            DropdownSingleSelectionModel(title: split.name ?? "", isOptionSelected: ((viewModel.competitionsInformation.splits?.first) != nil))
        } ?? []
        
        return DropdownSingleSelectionComponentView(options: options, textTop: "Splits".localized, onOptionSelected: { optionSelected in
            //viewModel.getFirstOptionSelected()
        })
        .padding(.top, 2)
        .padding(.leading, 15)
        .padding(.trailing, 15)
    }
    
    private var tabBarComponent: some View {
        Group {
            if viewModel.optionTabSelected != nil {
                TabView(selection: $viewModel.selectedTab) {
                    DetailSectionView(title: "Sobre esta competición...".localized, content: viewModel.competitionsInformation.overview, image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Overview".localized, systemImage: "info.circle")
                        }
                        .tag(Tab.overview)
                    
                    DetailSectionView(title: "Detalles".localized, content: viewModel.competitionsInformation.details, image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Detalles".localized, systemImage: "person.2")
                        }
                        .tag(Tab.teams)
                    
                    DetailSectionView(title: "Reglas".localized, content: viewModel.competitionsInformation.rules, image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Reglas".localized, systemImage: "clock")
                        }
                        .tag(Tab.schedule)
                    
                    DetailSectionView(title: "Contacto".localized, content: viewModel.competitionsInformation.contact, image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Contacto".localized, systemImage: "info.circle.fill")
                        }
                        .tag(Tab.results)
                    
                    DetailsTournamentView(title: "Torneos".localized, content: viewModel.optionTabSelected?.tournaments, image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Torneos".localized, systemImage: "trophy.fill")
                        }
                        .tag(Tab.tournaments)
                }
                .accentColor(.cyan)
                .padding(.top)
                .clipped() // Evita que el contenido se extienda fuera de sus límites

            } else {
                Text("No hay información disponible.".localized)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
