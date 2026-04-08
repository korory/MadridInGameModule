import SwiftUI

// MARK: - Resumen dinámico

struct ReservationSummaryView: View {
    @ObservedObject var viewModel: ReservationFlowViewModel
    var body: some View {
        VStack(spacing: 4) {
            Text(viewModel.teamSelectedInformation != nil && !viewModel.personalReservations
                 ? "Editar jugadores".localized : "Reservar espacio".localized)
                .font(.madridInGameiOSFont(size: 22))
                .foregroundColor(.white)
            if !viewModel.summaryTokens.isEmpty {
                Text(viewModel.summaryTokens.joined(separator: " · "))
                    .font(.madridInGameiOSFont(size: 13)).foregroundColor(.white.opacity(0.6))
                    .lineLimit(2).multilineTextAlignment(.center).transition(.opacity)
            }
        }
        .padding(.bottom, 8)
        .animation(.easeInOut(duration: 0.25), value: viewModel.summaryTokens)
    }
}

// MARK: - ReservationFlowView

struct ReservationFlowView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ReservationFlowViewModel

    private var isEditingTeamTraining: Bool {
        viewModel.teamSelectedInformation != nil && !viewModel.personalReservations
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea(.all)
            VStack(spacing: 0) {
                // Cabecera
                HStack {
                    Image(systemName: "xmark").foregroundColor(.clear).padding()
                    Spacer()

                    HStack(spacing: 6) {
                        let stepCount: Int = {
                            if isEditingTeamTraining { return 1 }
                            if viewModel.personalReservations { return viewModel.personalStepCount }
                            return 5
                        }()
                        ForEach(0..<stepCount, id: \.self) { index in
                            Circle()
                                .fill(index <= viewModel.currentStep ? Color.white : Color.white.opacity(0.25))
                                .frame(width: 8, height: 8)
                        }
                    }

                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark").font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7)).padding()
                    }
                }
                .padding(.horizontal, 4).padding(.top, 8)

                ReservationSummaryView(viewModel: viewModel)

                // MARK: TabView
                TabView(selection: $viewModel.currentStep) {
                    if isEditingTeamTraining {
                        SelectPlayerView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(0).contentShape(Rectangle()).simultaneousGesture(DragGesture())
                    } else {
                        if !viewModel.personalReservations {
                            SelectPlaceAndNotesView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                .tag(0).contentShape(Rectangle()).simultaneousGesture(DragGesture())
                            SelectPlayerView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                .tag(1).contentShape(Rectangle()).simultaneousGesture(DragGesture())
                        }

                        SelectDateView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                            .tag(viewModel.personalReservations ? 0 : 2)
                            .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                        if viewModel.selectedSpaceType == "" || viewModel.selectedSpaceType?.lowercased() != "virtual" {
                            SelectSpaceView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                .tag(viewModel.personalReservations ? 1 : 3)
                                .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                            SelectSlotView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                .tag(viewModel.personalReservations ? 2 : 4)
                                .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                            // Solo individual + espacio NO es simulador → preguntar simulador
                            if viewModel.personalReservations && !viewModel.isSelectedSpaceSimulator {
                                AskSimulatorView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                    .tag(3)
                                    .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                                if viewModel.wantsSimulator {
                                    SelectSimulatorSlotView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                        .tag(4)
                                        .contentShape(Rectangle()).simultaneousGesture(DragGesture())
                                }
                            }

                            // Solo individual + espacio ES simulador → preguntar espacio extra
                            if viewModel.personalReservations && viewModel.isSelectedSpaceSimulator {
                                AskExtraSpaceView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                    .tag(3)
                                    .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                                if viewModel.wantsExtraSpace {
                                    SelectExtraSpaceView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                        .tag(4)
                                        .contentShape(Rectangle()).simultaneousGesture(DragGesture())

                                    SelectExtraSlotView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                        .tag(5)
                                        .contentShape(Rectangle()).simultaneousGesture(DragGesture())
                                }
                            }
                        } else {
                            SelectTimeView(currentStep: $viewModel.currentStep, viewModel: viewModel)
                                .tag(viewModel.personalReservations ? 1 : 3)
                                .contentShape(Rectangle()).simultaneousGesture(DragGesture())
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

// MARK: - Botones reutilizables

private struct PrimaryButton: View {
    let title: String; let enabled: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.madridInGameiOSFont(size: 15)).frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(enabled ? Color.cyan : Color.clear)
                .foregroundColor(enabled ? .black : .white.opacity(0.4))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(enabled ? Color.clear : Color.white.opacity(0.2), lineWidth: 1))
                .cornerRadius(12)
        }.disabled(!enabled)
    }
}

private struct SecondaryButton: View {
    let title: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.madridInGameiOSFont(size: 15)).frame(maxWidth: .infinity)
                .padding(.vertical, 14).background(Color.clear).foregroundColor(.white.opacity(0.7))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
                .cornerRadius(12)
        }
    }
}

private struct PillButton: View {
    let title: String; let isSelected: Bool; let isEnabled: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.madridInGameiOSFont(size: 14)).frame(width: 100, height: 44)
                .background(isSelected ? Color.cyan : Color.clear)
                .foregroundColor(isSelected ? .black : isEnabled ? .white : .white.opacity(0.25))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(isSelected ? Color.clear : isEnabled ? Color.white.opacity(0.4) : Color.white.opacity(0.12), lineWidth: 1))
                .cornerRadius(22)
        }.disabled(!isEnabled)
    }
}

// MARK: - SelectPlaceAndNotesView

struct SelectPlaceAndNotesView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    @FocusState private var notesIsFocused: Bool
    let spaceTypes = ["Virtual", "E-Sports Center"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Seleccionar Espacio".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)
            Menu {
                ForEach(spaceTypes, id: \.self) { type in
                    Button(action: { viewModel.selectedSpaceType = type }) {
                        HStack { Text(type); if viewModel.selectedSpaceType == type { Image(systemName: "checkmark") } }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedSpaceType ?? "Selecciona tipo".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .foregroundColor(viewModel.selectedSpaceType == nil ? .white.opacity(0.4) : .white)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.white.opacity(0.4)).font(.system(size: 14))
                }
                .padding(.horizontal, 16).padding(.vertical, 16)
                .background(Color.white.opacity(0.06)).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))
            }
            .simultaneousGesture(TapGesture().onEnded { notesIsFocused = false })

            ZStack(alignment: .topLeading) {
                if viewModel.reservationNotes.isEmpty {
                    Text("Notas (Opcional)".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.3)).padding(.horizontal, 16).padding(.vertical, 16)
                }
                TextEditor(text: $viewModel.reservationNotes).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white).scrollContentBackground(.hidden)
                    .padding(.horizontal, 12).padding(.vertical, 12).frame(minHeight: 100).focused($notesIsFocused)
            }
            .background(Color.white.opacity(0.06)).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))

            Spacer()
            PrimaryButton(title: "Siguiente".localized, enabled: viewModel.selectedSpaceType != nil) {
                notesIsFocused = false; currentStep += 1
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 16)
    }
}

// MARK: - SelectPlayerView

struct SelectPlayerView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    private var isEditingTeamTraining: Bool {
        viewModel.teamSelectedInformation != nil && !viewModel.personalReservations
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Seleccionar Jugador".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)

            Menu {
                ForEach(viewModel.teamPlayers) { player in
                    Button(action: {
                        if !viewModel.selectedPlayers.contains(player.usersId?.username ?? "") {
                            viewModel.selectedPlayers.append(player.usersId?.username ?? "")
                        }
                    }) {
                        HStack {
                            Text(player.usersId?.username ?? "")
                            if viewModel.selectedPlayers.contains(player.usersId?.username ?? "") { Image(systemName: "checkmark") }
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Selecciona un jugador".localized).font(.madridInGameiOSFont(size: 15)).foregroundColor(.white.opacity(0.4))
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.white.opacity(0.4)).font(.system(size: 14))
                }
                .padding(.horizontal, 16).padding(.vertical, 16)
                .background(Color.white.opacity(0.06)).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))
            }

            if !viewModel.selectedPlayers.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(viewModel.selectedPlayers, id: \.self) { player in
                        HStack(spacing: 6) {
                            Text(player).font(.madridInGameiOSFont(size: 13)).foregroundColor(.white)
                            Button(action: { viewModel.selectedPlayers.removeAll { $0 == player } }) {
                                Image(systemName: "xmark").font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.white.opacity(0.1)).cornerRadius(20)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }.animation(.easeInOut, value: viewModel.selectedPlayers)
            }

            Spacer()

            if isEditingTeamTraining {
                PrimaryButton(title: "Guardar".localized, enabled: !viewModel.selectedPlayers.isEmpty) {
                    if viewModel.selectedSpaceType?.lowercased() == "virtual" || viewModel.teamSelectedInformation?.type.lowercased() == "virtual" {
                        viewModel.updateVirtualTeamReservation()
                    } else {
                        viewModel.updateCenterTeamReservation()
                    }
                }
            } else {
                SecondaryButton(title: "Atrás".localized) { currentStep -= 1 }
                PrimaryButton(title: "Siguiente".localized, enabled: !viewModel.selectedPlayers.isEmpty) { currentStep += 1 }
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 16)
        .animation(.easeInOut, value: viewModel.selectedPlayers)
    }
}

// MARK: - SelectDateView

struct SelectDateView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    var body: some View {
        ZStack {
            if viewModel.showLegendPopup {
                CustomPopup(isPresented: $viewModel.showLegendPopup) { ColorLegendView() }
                    .transition(.scale).zIndex(1)
            }
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Selecciona una fecha".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)
                    Spacer()
                    Button { viewModel.showLegendPopup.toggle() } label: {
                        Text("legend".localized).font(.madridInGameiOSFont(size: 13)).foregroundColor(.cyan)
                    }
                }
                if viewModel.isLoading {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                        Text("Cargando fechas disponibles...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).onAppear { viewModel.getBlockedDays() }
                } else {
                    CustomCalendarView(canUserInteract: true, markedDates: viewModel.markedDates, initialSelectedDate: viewModel.selectedDate) { viewModel.checkSelectedDate($0) }
                        .frame(height: 350)
                }
                Spacer()
                if viewModel.currentStep > 0 { SecondaryButton(title: "Atrás".localized) { viewModel.currentStep -= 1 } }
                PrimaryButton(title: "Siguiente".localized, enabled: viewModel.selectedDate != nil) { viewModel.currentStep += 1 }
            }.padding(.horizontal, 20).padding(.vertical, 16)
        }
    }
}

// MARK: - SelectTimeView

struct SelectTimeView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel
    @State private var pickerTime: Date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Seleccionar Hora".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)
            VStack(alignment: .leading, spacing: 4) {
                Text("Fecha seleccionada".localized).font(.madridInGameiOSFont(size: 12)).foregroundColor(.white.opacity(0.4))
                Text(viewModel.selectedDate?.toUIDateString() ?? "").font(.madridInGameiOSFont(size: 24)).foregroundColor(.white).lineLimit(1).minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 16).padding(.vertical, 16)
            .background(Color.white.opacity(0.06)).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))

            DatePicker("", selection: $pickerTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel).labelsHidden().colorScheme(.dark).frame(maxWidth: .infinity)
                .padding(.vertical, 8).background(Color.white.opacity(0.06)).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))
                .environment(\.locale, Locale(identifier: "es"))
                .onChange(of: pickerTime) { let f = DateFormatter(); f.dateFormat = "HH:mm"; viewModel.selectedTime = f.string(from: $0) }
                .onAppear {
                    if let p = DateFormatter.hhMM.date(from: viewModel.selectedTime) { pickerTime = p }
                    else { let f = DateFormatter(); f.dateFormat = "HH:mm"; viewModel.selectedTime = f.string(from: pickerTime) }
                }
            Spacer()
            SecondaryButton(title: "Atrás".localized) { viewModel.currentStep -= 1 }
            PrimaryButton(title: "Reservar".localized, enabled: true) {
                if viewModel.teamSelectedInformation != nil { viewModel.updateVirtualTeamReservation() }
                else { viewModel.createVirtualTeamReservation() }
            }
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }
}

// MARK: - SelectSlotView

struct SelectSlotView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    private var isEditing: Bool { viewModel.individualSelectedInformation != nil || viewModel.teamSelectedInformation != nil }
    private var canReserve: Bool { viewModel.selectedSpace != nil && !viewModel.selectedSlots.isEmpty && viewModel.selectedDate != nil }

    private var shouldGoToAskAddon: Bool {
        viewModel.personalReservations && !isEditing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isCreatingReservation {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Creando la reserva...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Selecciona franja horaria".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)

                if viewModel.availableSlots.isEmpty || viewModel.isLoadingOccupancy {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                        Text("Cargando horarios disponibles...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        if viewModel.availableSlots.isEmpty {
                            viewModel.fetchAvailableSlots(for: viewModel.calculateDayValue(for: viewModel.selectedDate))
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(viewModel.availableSlots) { slot in slotButton(for: slot, selectedDate: viewModel.selectedDate) }
                        }.padding(.horizontal, 4)
                    }
                }

                let isSim = viewModel.selectedSpace?.device.lowercased().contains("simulador") ?? false
                Text(isSim ? "Máximo 1 spots consecutivos".localized : (viewModel.personalReservations ? "Máximo 3 spots consecutivos".localized : "Máximo 2 spots consecutivos".localized))
                    .font(.madridInGameiOSFont(size: 12)).foregroundColor(.white.opacity(0.35)).frame(maxWidth: .infinity)

                Spacer()
                SecondaryButton(title: "Atrás".localized) { viewModel.currentStep -= 1 }

                if shouldGoToAskAddon {
                    PrimaryButton(title: "Siguiente".localized, enabled: canReserve) { currentStep += 1 }
                } else {
                    PrimaryButton(title: isEditing ? "Guardar".localized : "Reservar".localized, enabled: canReserve) {
                        if viewModel.personalReservations {
                            if viewModel.individualSelectedInformation != nil { viewModel.updateIndividualReservation() }
                            else { viewModel.createReservation() }
                        } else if viewModel.teamSelectedInformation != nil { viewModel.updateCenterTeamReservation() }
                        else { viewModel.createTeamReservation() }
                    }
                }
            }
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }

    private func slotButton(for slot: GamingSpaceTime, selectedDate: Date?) -> some View {
        let isEnabled = viewModel.enabledSlots.contains(where: { $0.id == slot.id })
        let isSelected = viewModel.selectedSlots.contains(where: { $0.id == slot.id })
        let currentHourPlus2 = Calendar.current.component(.hour, from: Date()) + 1
        let isToday = if let selectedDate { Calendar.current.isDateInToday(selectedDate) } else { false }
        let isTimeValid = slot.value > currentHourPlus2
        let computedEnabled = isToday ? (isTimeValid && isEnabled) : isEnabled

        return PillButton(title: slot.time, isSelected: isSelected, isEnabled: computedEnabled) {
            if computedEnabled { viewModel.toggleSlotSelection(slot) }
        }
    }
}

// MARK: - AskSimulatorView (solo individual, espacio NO simulador)

struct AskSimulatorView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    var body: some View {
        VStack(spacing: 24) {
            if viewModel.isCreatingReservation {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Creando la reserva...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Spacer()

                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(colors: [.cyan.opacity(0.7), .purple.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                    )

                Text("¿Quieres añadir tiempo de simulador?".localized)
                    .font(.madridInGameiOSFont(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text("Puedes reservar un slot de simulador adicional junto a tu reserva actual.".localized)
                    .font(.madridInGameiOSFont(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                SecondaryButton(title: "Atrás".localized) {
                    currentStep -= 1
                }

                PrimaryButton(title: "No, reservar sin simulador".localized, enabled: true) {
                    viewModel.resetSimulatorSelection()
                    if viewModel.individualSelectedInformation != nil {
                        viewModel.updateIndividualReservation()
                    } else {
                        viewModel.createReservation()
                    }
                }

                Button(action: {
                    viewModel.wantsSimulator = true
                    viewModel.findSimulatorSpace()
                    viewModel.fetchSimulatorSlots()
                    currentStep += 1
                }) {
                    Text("Sí, añadir simulador".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [.cyan, .purple.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// MARK: - SelectSimulatorSlotView (slots con medias horas, max 1)

struct SelectSimulatorSlotView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    private var canReserve: Bool { !viewModel.simulatorSelectedSlots.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isCreatingReservation {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Creando la reserva...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Selecciona hora de simulador".localized)
                    .font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)

                if viewModel.availableSimulatorSlots.isEmpty || viewModel.isLoadingSimulatorOccupancy {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                        Text("Cargando horarios de simulador...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(viewModel.availableSimulatorSlots) { slot in
                                simulatorSlotButton(for: slot)
                            }
                        }.padding(.horizontal, 4)
                    }
                }

                Text("Máximo 1 spot de simulador".localized)
                    .font(.madridInGameiOSFont(size: 12)).foregroundColor(.white.opacity(0.35)).frame(maxWidth: .infinity)

                Spacer()

                SecondaryButton(title: "Atrás".localized) {
                    currentStep -= 1
                }

                PrimaryButton(title: "Reservar".localized, enabled: canReserve) {
                    viewModel.createReservation()
                }
            }
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }

    private func simulatorSlotButton(for slot: GamingSpaceTime) -> some View {
        let isSelected = viewModel.simulatorSelectedSlots.contains(where: { $0.id == slot.id })
        let currentHourPlus2 = Calendar.current.component(.hour, from: Date()) + 1
        let isToday = if let date = viewModel.selectedDate { Calendar.current.isDateInToday(date) } else { false }
        let isTimeValid = slot.value > currentHourPlus2
        let isBlockedByMain = viewModel.isSimulatorSlotBlockedByMain(slot)
        let isOccupied = viewModel.occupiedSimulatorTimeIds.contains(slot.id)
        let computedEnabled = isToday ? (isTimeValid && !isBlockedByMain && !isOccupied) : (!isBlockedByMain && !isOccupied)

        return PillButton(title: slot.time, isSelected: isSelected, isEnabled: computedEnabled) {
            if computedEnabled { viewModel.toggleSimulatorSlotSelection(slot) }
        }
    }
}

// MARK: - AskExtraSpaceView (solo individual, espacio ES simulador)

struct AskExtraSpaceView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    var body: some View {
        VStack(spacing: 24) {
            if viewModel.isCreatingReservation {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Creando la reserva...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Spacer()

                Image(systemName: "desktopcomputer")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(colors: [.cyan.opacity(0.7), .purple.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                    )

                Text("¿Quieres añadir otro espacio?".localized)
                    .font(.madridInGameiOSFont(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text("Puedes reservar un espacio de gaming adicional junto a tu reserva de simulador.".localized)
                    .font(.madridInGameiOSFont(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                SecondaryButton(title: "Atrás".localized) {
                    currentStep -= 1
                }

                PrimaryButton(title: "No, reservar solo simulador".localized, enabled: true) {
                    viewModel.resetExtraSpaceSelection()
                    if viewModel.individualSelectedInformation != nil {
                        viewModel.updateIndividualReservation()
                    } else {
                        viewModel.createReservation()
                    }
                }

                Button(action: {
                    viewModel.wantsExtraSpace = true
                    currentStep += 1
                }) {
                    Text("Sí, añadir espacio".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [.cyan, .purple.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// MARK: - SelectExtraSpaceView (seleccionar espacio extra, sin simulador)

struct SelectExtraSpaceView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selecciona un espacio extra".localized)
                .font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)

            if viewModel.nonSimulatorSpaces.isEmpty {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Cargando espacios disponibles...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(viewModel.nonSimulatorSpaces) { space in
                            extraSpaceButton(for: space)
                        }
                    }.padding(.horizontal, 4)
                }
            }

            Spacer()

            SecondaryButton(title: "Atrás".localized) { currentStep -= 1 }
            PrimaryButton(title: "Siguiente".localized, enabled: viewModel.extraSpace != nil) {
                viewModel.fetchExtraSpaceSlots()
                currentStep += 1
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 16)
    }

    private func extraSpaceButton(for space: Space) -> some View {
        let isSelected = viewModel.extraSpace?.id == space.id
        return PillButton(title: space.device, isSelected: isSelected, isEnabled: true) {
            viewModel.selectExtraSpace(space)
        }
    }
}

// MARK: - SelectExtraSlotView (slots del espacio extra, sin medias horas, max 3)

struct SelectExtraSlotView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    private var canReserve: Bool { !viewModel.extraSpaceSelectedSlots.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isCreatingReservation {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Creando la reserva...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Selecciona franja horaria".localized)
                    .font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)

                if let device = viewModel.extraSpace?.device {
                    Text(device)
                        .font(.madridInGameiOSFont(size: 14)).foregroundColor(.cyan)
                }

                if viewModel.availableExtraSpaceSlots.isEmpty || viewModel.isLoadingExtraSpaceOccupancy {
                    VStack {
                        Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                        Text("Cargando horarios disponibles...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(viewModel.availableExtraSpaceSlots) { slot in
                                extraSlotButton(for: slot)
                            }
                        }.padding(.horizontal, 4)
                    }
                }

                Text("Máximo 3 spots consecutivos".localized)
                    .font(.madridInGameiOSFont(size: 12)).foregroundColor(.white.opacity(0.35)).frame(maxWidth: .infinity)

                Spacer()

                SecondaryButton(title: "Atrás".localized) { currentStep -= 1 }
                PrimaryButton(title: "Reservar".localized, enabled: canReserve) {
                    viewModel.createReservation()
                }
            }
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }

    private func extraSlotButton(for slot: GamingSpaceTime) -> some View {
        let isEnabled = viewModel.enabledExtraSpaceSlots.contains(where: { $0.id == slot.id })
        let isSelected = viewModel.extraSpaceSelectedSlots.contains(where: { $0.id == slot.id })
        let currentHourPlus2 = Calendar.current.component(.hour, from: Date()) + 1
        let isToday = if let date = viewModel.selectedDate { Calendar.current.isDateInToday(date) } else { false }
        let isTimeValid = slot.value > currentHourPlus2
        let isBlockedBySim = viewModel.isExtraSpaceSlotBlockedBySimulator(slot)
        let computedEnabled = isToday ? (isTimeValid && isEnabled && !isBlockedBySim) : (isEnabled && !isBlockedBySim)

        return PillButton(title: slot.time, isSelected: isSelected, isEnabled: computedEnabled) {
            if computedEnabled { viewModel.toggleExtraSpaceSlotSelection(slot) }
        }
    }
}

// MARK: - SelectSpaceView

struct SelectSpaceView: View {
    @Binding var currentStep: Int
    @ObservedObject var viewModel: ReservationFlowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selecciona un espacio".localized).font(.madridInGameiOSFont(size: 20)).foregroundColor(.white)
            if viewModel.availableSpaces.isEmpty {
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!).resizable().scaledToFit().frame(width: 100, height: 50)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .purple)).scaleEffect(1.5).padding()
                    Text("Cargando espacios disponibles...".localized).font(.madridInGameiOSFont(size: 14)).foregroundColor(.white.opacity(0.5))
                }.frame(maxWidth: .infinity, maxHeight: .infinity).onAppear { viewModel.fetchAvailableSpaces() }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(viewModel.availableSpaces) { space in spaceButton(for: space) }
                    }.padding(.horizontal, 4)
                }
            }
            Spacer()
            SecondaryButton(title: "Atrás".localized) { currentStep -= 1 }
            PrimaryButton(title: "Siguiente".localized, enabled: viewModel.selectedSpace != nil) { currentStep += 1 }
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }

    private func spaceButton(for space: Space) -> some View {
        let isSelected = viewModel.selectedSpace?.id == space.id
        return PillButton(title: space.device, isSelected: isSelected, isEnabled: true) { viewModel.selectSpace(space) }
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }.reduce(0) { $0 + $1 + spacing } - spacing
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
        var rows: [[LayoutSubview]] = [[]]; var x: CGFloat = 0; let maxWidth = proposal.width ?? 0
        for subview in subviews {
            let width = subview.sizeThatFits(.unspecified).width
            if x + width > maxWidth, !rows[rows.count - 1].isEmpty { rows.append([]); x = 0 }
            rows[rows.count - 1].append(subview); x += width + spacing
        }
        return rows
    }
}

extension DateFormatter {
    static let hhMM: DateFormatter = { let f = DateFormatter(); f.dateFormat = "HH:mm"; return f }()
}
