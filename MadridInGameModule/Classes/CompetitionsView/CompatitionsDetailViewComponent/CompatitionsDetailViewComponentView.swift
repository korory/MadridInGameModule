//
//  CompatitionsDetailViewComponentView.swift
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
    case tornaments
}

struct CompatitionsDetailViewComponentView: View {
    @ObservedObject var viewModel: CompetitionsDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 5) {
                titleBanner
                dropdownSplitSelectorComponent
                tabBarComponent
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
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    .foregroundStyle(.white)
            }
            
            Text((viewModel.competitionsInformation.title)!)
                .font(.custom("Madridingamefont-Regular", size: 25))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 5)
                .padding(.bottom, 8)
                .padding(.top, 7)
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    private var dropdownTitle: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Splits", underlineColor: Color.cyan)
        }
        .padding(.leading, 20)
    }
    
    private var dropdownSplitSelectorComponent: some View {
        let options = viewModel.competitionsInformation.splits?.map { split in
            DropdownSingleSelectionModel(title: split.name, isOptionSelected: ((viewModel.competitionsInformation.splits?.first) != nil))
        } ?? []
        
        return DropdownSingleSelectionComponentView(options: options, textTop: "Splits", onOptionSelected: { optionSelected in
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
                    DetailSectionView(title: "SOBRE ESTA COMPETICIÓN...", content: viewModel.competitionsInformation.overview ?? "", image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Overview", systemImage: "info.circle")
                        }
                        .tag(Tab.overview)
                    
                    DetailSectionView(title: "Detalles", content: viewModel.competitionsInformation.details ?? "", image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Detalles", systemImage: "person.2")
                        }
                        .tag(Tab.teams)
                    
                    DetailSectionView(title: "Reglas", content: viewModel.competitionsInformation.rules ?? "", image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Reglas", systemImage: "clock")
                        }
                        .tag(Tab.schedule)
                    
                    DetailSectionView(title: "Contacto", content: viewModel.competitionsInformation.contact ?? "", image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Contacto", systemImage: "info.circle.fill")
                        }
                        .tag(Tab.results)
                    
                    DetailsTournamentView(title: "Torneos", content: viewModel.optionTabSelected?.tournaments ?? [], image: viewModel.competitionsInformation.game?.banner ?? "")
                        .tabItem {
                            Label("Torneos", systemImage: "trophy.fill")
                        }
                        .tag(Tab.tornaments)
                }
                .accentColor(.cyan)
                .padding(.top)

            } else {
                Text("No hay información disponible.")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .ignoresSafeArea(.all)
    }
}


