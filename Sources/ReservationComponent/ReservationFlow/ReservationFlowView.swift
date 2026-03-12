//
//  ReservationFlowView.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import SwiftUI

// MARK: - Componente del resumen dinámico
// Colócalo justo antes de ReservationFlowView o en su propio archivo

// MARK: - Componente del resumen dinámico

struct ReservationSummaryView: View {
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        VStack {
            Text("Reservar espacio".localized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            if !viewModel.summaryTokens.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(viewModel.summaryTokens, id: \.self) { token in
                        Text(token)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(100)
                    }
                }
                .padding(.horizontal, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.summaryTokens)
    }
}


// MARK: - ReservationFlowView modificado
// Sustituye los dos Text("Reservar espacio") duplicados por ReservationSummaryView

struct ReservationFlowView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [.black, .black, .black, Color.white.opacity(0.15)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            VStack {
                // — Cabecera (back / dots / close) —
                HStack {
                    Button(action: {
                        if viewModel.currentStep > 0 {
                            viewModel.currentStep -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(viewModel.currentStep == 0 ? .black : .white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack {
                        let stepCount = viewModel.personalReservations ? 3 : 5
                        ForEach(0..<stepCount, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentStep ? Color.white : Color.clear)
                                .frame(width: 10, height: 10)
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                // — Título dinámico con tokens —
                ReservationSummaryView(viewModel: viewModel)
                
                // En ReservationFlowView, sustituye el TabView completo por esto:
                TabView(selection: $viewModel.currentStep) {
                    if !viewModel.personalReservations {
                        SelectPlaceAndNotesView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(0)
                            .contentShape(Rectangle())                          // 👈 área de hit-test definida
                            .simultaneousGesture(DragGesture())                 // 👈 bloquea swipe en esta página
                        
                        SelectPlayerView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(1)
                            .contentShape(Rectangle())
                            .simultaneousGesture(DragGesture())
                    }
                    
                    SelectDateView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                        .tag(viewModel.personalReservations ? 0 : 2)
                        .contentShape(Rectangle())
                        .simultaneousGesture(DragGesture())
                    
                    if viewModel.selectedSpaceType == "" || viewModel.selectedSpaceType?.lowercased() != "virtual" {
                        SelectSpaceView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(viewModel.personalReservations ? 1 : 3)
                            .contentShape(Rectangle())
                            .simultaneousGesture(DragGesture())
                        
                        SelectSlotView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(viewModel.personalReservations ? 2 : 4)
                            .contentShape(Rectangle())
                            .simultaneousGesture(DragGesture())
                    } else {
                        SelectTimeView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(viewModel.personalReservations ? 1 : 3)
                            .contentShape(Rectangle())
                            .simultaneousGesture(DragGesture())
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                // 👇 Elimina el highPriorityGesture del TabView — ya no hace falta
                Spacer()
            }
        }
    }
}

struct SelectPlaceAndNotesView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    @FocusState private var notesIsFocused: Bool   // 👈
    
    let spaceTypes = ["Virtual", "E-Sports Center"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Seleccionar Espacio".localized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Menu {
                ForEach(spaceTypes, id: \.self) { type in
                    Button(action: {
                        viewModel.selectedSpaceType = type
                    }) {
                        HStack {
                            Text(type)
                            if viewModel.selectedSpaceType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedSpaceType ?? "")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.07))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan, lineWidth: 1.5)
                )
            }
            // 👇 Al abrir el Menu también descartamos el teclado
            .simultaneousGesture(TapGesture().onEnded { notesIsFocused = false })
            
            ZStack(alignment: .topLeading) {
                if viewModel.reservationNotes.isEmpty {
                    Text("Notas (Opcional)".localized)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                }
                TextEditor(text: $viewModel.reservationNotes)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(minHeight: 120)
                    .focused($notesIsFocused)   // 👈
            }
            .background(Color.white.opacity(0.07))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan, lineWidth: 1.5)
            )
            
            Spacer()
            
            Button(action: {
                notesIsFocused = false          // 👈 quita el foco antes de avanzar
                currentStep += 1
            }) {
                Text("Siguiente".localized)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedSpaceType == nil ? Color.gray.opacity(0.4) : Color.cyan)
                    .foregroundColor(viewModel.selectedSpaceType == nil ? Color.white.opacity(0.4) : .white)
                    .cornerRadius(14)
            }
            .disabled(viewModel.selectedSpaceType == nil)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// Pantalla 1: Selección de Jugador
struct SelectPlayerView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Seleccionar Jugador".localized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            // Dropdown
            Menu {
                ForEach(viewModel.teamPlayers) { player in
                    Button(action: {
                        if !viewModel.selectedPlayers.contains(player.usersId?.username ?? "") {
                            viewModel.selectedPlayers.append(player.usersId?.username ?? "")
                        }
                    }) {
                        HStack {
                            Text(player.usersId?.username ?? "")
                            if viewModel.selectedPlayers.contains(player.usersId?.username ?? "") {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Selecciona un jugador".localized)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.07))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan, lineWidth: 1.5)
                )
            }
            //.padding(.horizontal, 16)
            
            // Chips de jugadores seleccionados
            if !viewModel.selectedPlayers.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(viewModel.selectedPlayers, id: \.self) { player in
                        HStack(spacing: 6) {
                            Text(player)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                viewModel.selectedPlayers.removeAll { $0 == player }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(100)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }
                .padding(.horizontal, 16)
                .animation(.easeInOut, value: viewModel.selectedPlayers)
            }
            
            Spacer()
            
            Button(action: {
                currentStep += 1 // Avanzar al siguiente paso
            }) {
                Text("Siguiente".localized)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedPlayers.isEmpty ? Color.gray : Color.cyan)
                    .foregroundColor(viewModel.selectedPlayers.isEmpty ? Color.white.opacity(0.5) : .white)
                    .cornerRadius(14)
            }
            //.padding(.horizontal)
            .disabled(viewModel.selectedPlayers.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .animation(.easeInOut, value: viewModel.selectedPlayers)
    }
}

struct SelectDateView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    var body: some View {
        ZStack {
            if viewModel.showLegendPopup {
                CustomPopup(isPresented: $viewModel.showLegendPopup) {
                    ColorLegendView()
                }
                .transition(.scale)
                .zIndex(1)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Selecciona una fecha".localized)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    Spacer()
                    
                    Button {
                        self.viewModel.showLegendPopup.toggle()
                    } label: {
                        Text("legend".localized)
                    }
                }
                
                if viewModel.isLoading {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Cargando fechas disponibles...".localized)
                            .font(.madridInGameiOSFont(size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        viewModel.getBlockedDays()
                    }
                } else {
                    CustomCalendarView(canUserInteract: true, markedDates: viewModel.markedDates,     initialSelectedDate: viewModel.selectedDate   // 👈
                    ) { stringDate in
                        viewModel.checkSelectedDate(stringDate)
                    }
                    .frame(height: 350)
                }
                
                Spacer()
                
                Button(action: {
                    currentStep += 1
                }) {
                    Text("Siguiente".localized)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedDate == nil ? Color.gray.opacity(0.4) : Color.cyan)
                        .foregroundColor(viewModel.selectedDate == nil ? Color.white.opacity(0.4) : .white)
                        .cornerRadius(14)
                }
                .disabled(viewModel.selectedDate == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}
struct SelectTimeView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    
    @State private var pickerTime: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Título
            Text("Seleccionar Hora".localized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            // Fecha seleccionada anteriormente (grande, prominente)
            VStack(alignment: .leading, spacing: 4) {
                Text("Fecha seleccionada".localized)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.cyan.opacity(0.8))
                
                Text(viewModel.selectedDate?.toUIDateString() ?? "")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(Color.white.opacity(0.07))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan, lineWidth: 1.5)
            )
            
            // Selector de hora estilo rueda iOS
            DatePicker(
                "",
                selection: $pickerTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .colorScheme(.dark)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.07))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan, lineWidth: 1.5)
            )
            .environment(\.locale, Locale(identifier: "es"))
            .onChange(of: pickerTime) { newValue in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                viewModel.selectedTime = formatter.string(from: newValue)
            }
            .onAppear {
                if let parsed = DateFormatter.hhMM.date(from: viewModel.selectedTime) {
                    // Venimos con hora pre-rellenada (edición) — sincronizamos el picker
                    pickerTime = parsed
                } else {
                    // Flujo nuevo — inicializamos selectedTime con la hora actual del picker
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    viewModel.selectedTime = formatter.string(from: pickerTime)
                }
            }
            
            Spacer()
            
            // Botón Siguiente
            Button(action: {
                if viewModel.teamSelectedInformation != nil {
                    viewModel.updateVirtualTeamReservation()   // editar training existente
                } else {
                    viewModel.createVirtualTeamReservation()
                }
                }) {
                    Text("Reservar".localized)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(Color.white)
                        .cornerRadius(14)
                }
            }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
    }
    
    // Pantalla 3: Selección de Horario
    struct SelectSlotView: View {
        @Binding var currentStep: Int
        @ObservedObject var viewModel: ReservationFlowViewModel
        
        var body: some View {
            VStack (alignment: .leading){
                if (viewModel.isCreatingReservation){
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Creando la reserva...".localized)
                            .font(.madridInGameiOSFont(size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Selecciona franja horaria".localized)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    if viewModel.availableSlots.isEmpty {
                        VStack {
                            Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 50)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                                .scaleEffect(1.5)
                                .padding()
                            
                            Text("Cargando horarios disponibles...".localized)
                                .font(.madridInGameiOSFont(size: 15))
                                .foregroundColor(.white)
                                .opacity(0.7)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            viewModel.fetchAvailableSlots(for: viewModel.calculateDayValue(for: viewModel.selectedDate))
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 20
                            ) {
                                ForEach(viewModel.availableSlots) { slot in
                                    slotButton(for: slot, selectedDate: viewModel.selectedDate)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    VStack (alignment: .center) {
                        let isSimulador = self.viewModel.selectedSpace?.device.lowercased().contains("simulador") ?? false
                        Text(isSimulador ? "Máximo 1 spots consecutivos".localized : (self.viewModel.personalReservations ? "Máximo 3 spots consecutivos".localized : "Máximo 2 spots consecutivos".localized))
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                    
                    Spacer()
                    
                    // Botón "Reservar"
                    Button(action: {
                        if viewModel.personalReservations {
                            viewModel.createReservation()
                        } else if viewModel.teamSelectedInformation != nil {
                            viewModel.updateCenterTeamReservation()   // editar training existente
                        } else {
                            viewModel.createTeamReservation()   // crear training nuevo
                        }
                    }) {
                        Text("Reservar".localized)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil ? Color.gray : Color.cyan)
                            .foregroundColor(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil ? Color.white.opacity(0.5) : .white)
                            .cornerRadius(14)
                    }
                    .disabled(viewModel.selectedSpace == nil || viewModel.selectedSlots.isEmpty || viewModel.selectedDate == nil || viewModel.isLoading)
                    
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
        }
        
        private func slotButton(for slot: GamingSpaceTime, selectedDate: Date?) -> some View {
            let isEnabled = viewModel.enabledSlots.contains(where: { $0.id == slot.id })
            let isSelected = viewModel.selectedSlots.contains(where: { $0.id == slot.id })
            
            let calendar = Calendar.current
            let currentHourPlus2 = calendar.component(.hour, from: Date()) + 1
            let isSlotDateToday = if let selectedDate { Calendar.current.isDateInToday(selectedDate)
            } else {
                false
            }
            let isSlotTimeValid = slot.value > currentHourPlus2
            
            let computedEnabled = isSlotDateToday ? (isSlotTimeValid && isEnabled) : isEnabled
            
            
            return Button(action: {
                if computedEnabled {
                    viewModel.toggleSlotSelection(slot)
                }
            }) {
                Text(slot.time)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 95, height: 50) // Tamaño de las píldoras
                    .background(isSelected ? Color.white : Color.clear) // Fondo según selección
                    .foregroundColor(isSelected ? Color.black : computedEnabled ? Color.white : Color.gray) // Color del texto
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(isSelected ? Color.clear : computedEnabled ? Color.white : Color.gray, lineWidth: 1) // Borde según estado
                    )
                    .cornerRadius(100) // Bordes redondeados
            }
            .disabled(!computedEnabled) // Deshabilita el botón si no está habilitado
        }
    }
    
    struct SelectSpaceView: View {
        @Binding var currentStep: Int
        @ObservedObject var viewModel: ReservationFlowViewModel
        
        var body: some View {
            
            VStack (alignment: .leading){
                Text("Selecciona un espacio".localized)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                if viewModel.availableSpaces.isEmpty {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Cargando espacios disponibles...".localized)
                            .font(.madridInGameiOSFont(size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                
                // Botón "Siguiente"
                Button(action: {
                    currentStep += 1 // Avanzar al siguiente paso
                }) {
                    Text("Siguiente".localized)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedSpace == nil ? Color.gray : Color.cyan)
                        .foregroundColor(viewModel.selectedSpace == nil ? Color.white.opacity(0.5) : .white)
                    
                        .cornerRadius(14)
                }
                .disabled(viewModel.selectedSpace == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
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
    
    // Layout que envuelve chips en múltiples líneas si no caben
    struct FlowLayout: Layout {
        var spacing: CGFloat = 8
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
            let rows = computeRows(proposal: proposal, subviews: subviews)
            let height = rows.map { $0.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }
                .reduce(0) { $0 + $1 + spacing } - spacing
            return CGSize(width: proposal.width ?? 0, height: max(height, 0))
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            let rows = computeRows(proposal: proposal, subviews: subviews)
            var y = bounds.minY
            for row in rows {
                var x = bounds.minX
                let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
                for subview in row {
                    let size = subview.sizeThatFits(.unspecified)
                    subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                    x += size.width + spacing
                }
                y += rowHeight + spacing
            }
        }
        
        private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
            var rows: [[LayoutSubview]] = [[]]
            var x: CGFloat = 0
            let maxWidth = proposal.width ?? 0
            
            for subview in subviews {
                let width = subview.sizeThatFits(.unspecified).width
                if x + width > maxWidth, !rows[rows.count - 1].isEmpty {
                    rows.append([])
                    x = 0
                }
                rows[rows.count - 1].append(subview)
                x += width + spacing
            }
            return rows
        }
    }
    
    extension DateFormatter {
        static let hhMM: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            return f
        }()
    }
    
