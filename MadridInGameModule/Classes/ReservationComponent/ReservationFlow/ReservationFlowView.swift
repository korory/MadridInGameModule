//
//  ReservationFlowView.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import SwiftUI

struct ReservationFlowView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            // Fondo negro
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        if viewModel.currentStep > 0 {
                            viewModel.currentStep -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(index == viewModel.currentStep ? Color.white : Color.clear)
                                .frame(width: 10, height: 10)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Text("Reservar espacio")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                TabView(selection: $viewModel.currentStep) {
                    SelectDateView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                        .tag(0)
                    SelectSlotView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                        .tag(1)
                    SelectSpaceView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
            }
        }
    }
}

// Pantalla 1: Selección de Jugador
//struct SelectPlayerView: View {
//    @Binding var currentStep: Int
//    @State private var selectedPlayer: String = "Jugador1"
//    @State private var players: [String] = ["Jugador1", "Jugador2", "Jugador3"]
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            Text("Seleccionar Jugador")
//                .font(.system(size: 24, weight: .bold))
//                .foregroundColor(.white)
//            
//            Picker("Selecciona un jugador", selection: $selectedPlayer) {
//                ForEach(players, id: \.self) { player in
//                    Text(player).tag(player)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
//            .padding(.horizontal, 16)
//            
//            Spacer()
//            
//            // Botón "Siguiente"
//            Button(action: {
//                currentStep += 1
//            }) {
//                Text("Siguiente")
//                    .font(.system(size: 18, weight: .bold))
//                    .frame(maxWidth: .infinity, maxHeight: 44)
//                    .background(Color.gray.opacity(0.8))
//                    .foregroundColor(.black)
//                    .cornerRadius(100)
//                    .padding(.horizontal, 48)
//            }
//        }
//        .padding()
//    }
//}

// Pantalla 2: Selección de Fecha
struct SelectDateView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        VStack {
            Text("Selecciona una fecha")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            if viewModel.markedDates.isEmpty { //&& viewModel.blockedDates.isEmpty {
                LoadingView(message: "Cargando fechas disponibles...")
                    .onAppear {
                        viewModel.getBlockedDays()
                    }
            } else {
                CustomCalendarView(canUserInteract: true, markedDates: viewModel.markedDates) { stringDate in
                    viewModel.checkSelectedDate(stringDate)
                }
                .frame(height: 350)
            }
            
            Spacer()
        }
        .padding()
    }
}


// Pantalla 3: Selección de Horario
struct SelectSlotView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        VStack {
            Text("Selecciona franja horaria")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Text(viewModel.selectedDate?.formatted() ?? "")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            if viewModel.availableSlots.isEmpty {
                LoadingView(message: "Cargando horarios disponibles...")
                    .onAppear {
                        viewModel.fetchAvailableSlots(for: viewModel.calculateDayValue(for: viewModel.selectedDate?.formatted() ?? "01/01/2029"))
                    }
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 20
                    ) {
                        ForEach(viewModel.availableSlots) { slot in
                            slotButton(for: slot)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Text("Máximo 3 spots consecutivos")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            Spacer()
            
            // Botón "Siguiente"
            Button(action: {
                currentStep += 1 // Avanzar al siguiente paso
            }) {
                Text("Siguiente")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedSlots.isEmpty ? Color.gray : Color.cyan)
                    .foregroundColor(viewModel.selectedSlots.isEmpty ? Color.white.opacity(0.5) : .white)
                    .cornerRadius(18)
            }
            .disabled(viewModel.selectedSlots.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func slotButton(for slot: GamingSpaceTime) -> some View {
        let isEnabled = viewModel.enabledSlots.contains(where: { $0.id == slot.id })
        let isSelected = viewModel.selectedSlots.contains(where: { $0.id == slot.id })
        
        return Button(action: {
            if isEnabled {
                viewModel.toggleSlotSelection(slot)
            }
        }) {
            Text(slot.time)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 95, height: 50) // Tamaño de las píldoras
                .background(isSelected ? Color.white : Color.clear) // Fondo según selección
                .foregroundColor(isSelected ? Color.black : isEnabled ? Color.white : Color.gray) // Color del texto
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(isSelected ? Color.clear : isEnabled ? Color.white : Color.gray, lineWidth: 1) // Borde según estado
                )
                .cornerRadius(100) // Bordes redondeados
        }
        .disabled(!isEnabled) // Deshabilita el botón si no está habilitado
    }
}

struct SelectSpaceView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        VStack {
            Text("Selecciona un espacio")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            if viewModel.availableSpaces.isEmpty {
                LoadingView(message: "Cargando espacios disponibles...")
                    .onAppear {
                        viewModel.fetchAvailableSpaces()
                    }
                    
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 20
                    ) {
                        ForEach(viewModel.availableSpaces) { space in
                            spaceButton(for: space)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Botón "Reservar"
            Button(action: {
                viewModel.createReservation()
            }) {
                Text("Reservar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil ? Color.gray : Color.cyan)
                    .foregroundColor(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil ? Color.white.opacity(0.5) : .white)
                    .cornerRadius(18)
            }
            .disabled(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil || viewModel.isLoading)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func spaceButton(for space: Space) -> some View {
        let isSelected = viewModel.selectedSpace?.id == space.id
        
        return Button(action: {
            viewModel.selectSpace(space)
        }) {
            Text(space.device) // Solo muestra el nombre del espacio
                .font(.system(size: 16, weight: .medium))
                .frame(width: 95, height: 50) // Tamaño de las píldoras
                .background(isSelected ? Color.white : Color.clear) // Fondo según selección
                .foregroundColor(isSelected ? Color.black : Color.white) // Texto según selección
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(isSelected ? Color.clear : Color.white, lineWidth: 1) // Borde blanco o transparente según selección
                )
                .cornerRadius(100) // Bordes redondeados
        }
    }
}
