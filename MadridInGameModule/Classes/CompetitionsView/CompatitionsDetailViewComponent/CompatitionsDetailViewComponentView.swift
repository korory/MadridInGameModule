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
}

struct CompatitionsDetailViewComponentView: View {
    @ObservedObject var viewModel: CompetitionsDetailViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            VStack(alignment: .leading, spacing: 5) {
                titleBanner
                dropdownTitle
                //dropdownSplitSelectorComponent
                //tabBarComponent
            }
        }
    }
    
    private var titleBanner: some View {
        Text((viewModel.competitionsInformation.game?.banner)!)//viewModel.competitionsInformation.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.5), radius: 5)
            .padding(.leading, 10)
            .padding(.bottom, 5)
    }
    
    private var dropdownTitle: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Splits", underlineColor: Color.cyan)
                .padding(.leading, 15)
        }
    }
    
//    private var dropdownSplitSelectorComponent: some View {
//        let options = viewModel.competitionsInformation.allSplitsAvailable.map { DropdownSingleSelectionModel(title: $0.title, isOptionSelected: viewModel.markFirstOptionDefault(title: $0.title)) }
//        
//        return DropdownSingleSelectionComponentView(options: options, onOptionSelected: { optionSelected in
//            viewModel.selectOption(option: optionSelected)
//        })
//        .padding(.top, 15)
//        .padding(.leading, 15)
//        .padding(.trailing, 15)
//    }
    
//    private var tabBarComponent: some View {
//        Group {
//            if let selectedSplit = viewModel.optionTabSelected {
//                TabView(selection: $viewModel.selectedTab) {
//                    DetailSectionView(title: "Sobre esta competición...", content: selectedSplit.overviewDescription, image: viewModel.competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Overview", systemImage: "info.circle")
//                        }
//                        .tag(Tab.overview)
//                    
//                    DetailSectionView(title: "DETALLES", content: selectedSplit.details, image: viewModel.competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Detalles", systemImage: "person.2")
//                        }
//                        .tag(Tab.teams)
//                    
//                    DetailSectionView(title: "REGLAS", content: selectedSplit.rules, image: viewModel.competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Reglas", systemImage: "clock")
//                        }
//                        .tag(Tab.schedule)
//                    
//                    DetailSectionView(title: "CONTACTO", content: selectedSplit.contact, image: viewModel.competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Contacto", systemImage: "info.circle.fill")
//                        }
//                        .tag(Tab.results)
//                }
//                .accentColor(.blue)
//                .padding(.top)
//            } else {
//                Text("No hay información disponible.")
//                    .foregroundColor(.white)
//                    .padding()
//            }
//        }
//    }
}

//struct CompatitionsDetailViewComponentView: View {
//    let competitionsInformation: CompetitionsDetailModel
//    @State private var optionTabSelected: SplitsModel?
//    @State private var selectedTab: Tab = .overview
//    
//    init(competitionsInformation: CompetitionsDetailModel) {
//        self.competitionsInformation = competitionsInformation
//        self.optionTabSelected = competitionsInformation.allSplitsAvailable.first
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.black
//                .ignoresSafeArea(.all)
//            VStack(alignment: .leading, spacing: 10) {
//                titleBanner
//                dropdownSplitSelectorComponent
//                tabBarComponent
//            }
//        }
//    }
//    
//    private func markFirstOptionDefault(title: String) -> Bool {
//        return title == competitionsInformation.allSplitsAvailable.first?.title
//    }
//}
//
//extension CompatitionsDetailViewComponentView {
//    private var titleBanner: some View {
//        Text(competitionsInformation.title)
//            .font(.largeTitle)
//            .fontWeight(.bold)
//            .foregroundColor(.white)
//            .shadow(color: Color.black.opacity(0.5), radius: 5)
//            .padding(.leading, 10)
//            .padding(.bottom, 5)
//    }
//    
//    private var dropdownSplitSelectorComponent: some View {
//        let options = competitionsInformation.allSplitsAvailable.map { DropdownSingleSelectionModel(title: $0.title, isOptionSelected: markFirstOptionDefault(title: $0.title)) }
//        
//        return DropdownSingleSelectionComponentView(options: options, onOptionSelected: { optionSelected in
//            if let selectedModel = competitionsInformation.allSplitsAvailable.first(where: { $0.title == optionSelected.title }) {
//                self.optionTabSelected = selectedModel
//            }
//        })
//    }
//    
//    private var tabBarComponent: some View {
//        Group {
//            // Usamos un Optional Binding para asegurarnos de que optionTabSelected no sea nil
//            if let selectedSplit = optionTabSelected {
//                TabView(selection: $selectedTab) {
//                    DetailSectionView(title: "Sobre esta competición...", content: selectedSplit.overviewDescription, image: competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Overview", systemImage: "info.circle")
//                        }
//                        .tag(Tab.overview)
//                    
//                    DetailSectionView(title: "DETALLES", content: selectedSplit.details, image: competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Detalles", systemImage: "person.2")
//                        }
//                        .tag(Tab.teams)
//                    
//                    DetailSectionView(title: "REGLAS", content: selectedSplit.rules, image: competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Reglas", systemImage: "clock")
//                        }
//                        .tag(Tab.schedule)
//                    
//                    DetailSectionView(title: "CONTACTO", content: selectedSplit.contact, image: competitionsInformation.allSplitsAvailable.first!.bannerImage)
//                        .tabItem {
//                            Label("Contacto", systemImage: "info.circle.fill")
//                        }
//                        .tag(Tab.results)
//                }
//                .accentColor(.blue)
//                .padding(.top)
//            } else {
//                // Mostrar un mensaje o una vista alternativa en caso de que no haya splits disponibles
//                Text("No hay información disponible.")
//                    .foregroundColor(.white)
//                    .padding()
//            }
//        }
//    }
    
    struct DetailSectionView: View {
        var title: String
        var content: String
        var image: UIImage
        
        var body: some View {
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .padding()
                            .shadow(color: Color.black.opacity(0.5), radius: 10)
                        
                        Text(title.uppercased())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Text(content)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.bottom)
                }
            }
        }
    }

