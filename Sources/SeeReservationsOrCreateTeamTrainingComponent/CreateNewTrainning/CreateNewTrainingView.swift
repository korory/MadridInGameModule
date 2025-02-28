////
////  CreateNewTrainingView.swift
////  CalendarComponent
////
////  Created by Arnau Rivas Rivas on 16/10/24.
////
//
//import SwiftUI
//
//struct CreateNewTrainingView: View {
//    @ObservedObject var viewModel: CreateNewTrainingViewModel
//    let rejectAction: () -> Void
//    
//    var body: some View {
//        VStack (spacing: 20) {
//            if !viewModel.initialReservationDone {
//                titleBanner
//                addNewTrainingLocatioon
//                addNotesComponent
//                buttonsDiscardContinueComponent
//            } else {
//                ScrollView {
//                    VStack (spacing: 20) {
//                        titleBanner
//                        selectPlayersDropdownComponent
//                        if !viewModel.playersSelected.isEmpty {
//                            selectConsoleType
//                        }
//                        if viewModel.consoleSelected != "" {
//                            selectHours
//                        }
//                        reservationButton
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension CreateNewTrainingView {
//    private var titleBanner: some View {
//        Text(viewModel.initialReservationDone ? viewModel.locationSelected.title == "E-Sports Center" ? "Reservar espacio" : "Reservar espacio virtual" : "Añadir Entrenamiento")
//            .font(.title)
//            .foregroundStyle(Color.white)
//    }
//    
//    private var addNewTrainingLocatioon: some View {
//        VStack (alignment: .leading, spacing: 28){
//            TextWithUnderlineComponent(title: "Seleciona el sitio", underlineColor: Color.cyan)
//            
//            DropdownSingleSelectionComponentView(options: [
//                DropdownSingleSelectionModel(title: "E-Sports Center", isOptionSelected: false),
//                DropdownSingleSelectionModel(title: "Virtual", isOptionSelected: false)
//            ], onOptionSelected: { optionSelected in
//                viewModel.selectLocation(option: optionSelected)
//            })
//        }
//    }
//    
//    private var addNotesComponent: some View {
//        VStack (alignment: .leading, spacing: 28){
//            TextWithUnderlineComponent(title: "Notas", underlineColor: Color.cyan)
//            
//            FloatingTextField(text: viewModel.notes, placeholderText: "Notas (Optional)", isDescripcionTextfield: true)
//        }
//        .padding(.leading, 10)
//    }
//    
//    private var buttonsDiscardContinueComponent: some View {
//        HStack (spacing: 10){
//            CustomButton(text: "Descartar",
//                         needsBackground: false,
//                         backgroundColor: Color.cyan,
//                         pressEnabled: true,
//                         widthButton: 180, heightButton: 50) {
//                viewModel.discard()
//                rejectAction()
//            }
//            .padding(.trailing, 10)
//            
//            CustomButton(text: "Continuar",
//                         needsBackground: true,
//                         backgroundColor: Color.cyan,
//                         pressEnabled: true,
//                         widthButton: 180, heightButton: 50) {
//                viewModel.continueReservation()
//            }
//        }
//    }
//    
//    private var selectPlayersDropdownComponent: some View {
//        VStack (alignment: .leading, spacing: 28){
//            TextWithUnderlineComponent(title: "Jugadores", underlineColor: Color.cyan)
//            
//            DropdownMultipleSelectionComponentView(options: [
//                DropdownMultipleSelectionModel(title: "Player 1", isOptionSelected: false),
//                DropdownMultipleSelectionModel(title: "Player 2", isOptionSelected: false),
//                DropdownMultipleSelectionModel(title: "Player 3", isOptionSelected: false),
//                DropdownMultipleSelectionModel(title: "Player 4", isOptionSelected: false)
//            ], optionPressed: { optionSelectedText in
//                self.viewModel.addRemoveNewPlayer(namePlayer: optionSelectedText)
//            })
//        }
//        .padding(.leading, 10)
//    }
//    
//    private var selectConsoleType: some View {
//        VStack (spacing: 28){
//            HStack {
//                TextWithUnderlineComponent(title: "Selecciona Consola", underlineColor: Color.cyan)
//                Spacer()
//            }
//            CustomSelectorButtons(items: viewModel.consoleReservation,
//                                  selectedItems: Binding(
//                                    get: { [viewModel.consoleSelected].compactMap { $0 } },
//                                    set: { viewModel.consoleSelected = $0.first ?? "" }
//                                  ), pressEnabled: true) { console in
//                                      viewModel.consoleSelected = console
//                                  }
//        }
//    }
//    
//    private var selectHours: some View {
//        VStack (spacing: 10){
//            HStack {
//                TextWithUnderlineComponent(title: "Selecciona Hora/s", underlineColor: Color.cyan)
//                Spacer()
//            }
//            Text(viewModel.dateSelected)
//                .font(.headline)
//                .foregroundStyle(Color.white)
//                .padding()
//            
//            CustomSelectorButtons(items: viewModel.hoursReservation,
//                                  selectedItems: $viewModel.hoursSelected, pressEnabled: true) { hour in
//                viewModel.addRemoveHours(hour: hour)
//            }
//            
//            Text("Máximo 2 spots consecutivos")
//                .font(.body)
//                .foregroundStyle(Color.white)
//                .padding()
//        }
//    }
//    
//    private var reservationButton: some View {
//        CustomButton(text: "Reservar",
//                     needsBackground: true,
//                     backgroundColor: Color.cyan,
//                     pressEnabled: true,
//                     widthButton: 280, heightButton: 50) {
//            //viewModel.isCreateReservationButtonPressed()
//        }
//                     .disabled(!viewModel.playersSelected.isEmpty && viewModel.consoleSelected != "")
//    }
//}
