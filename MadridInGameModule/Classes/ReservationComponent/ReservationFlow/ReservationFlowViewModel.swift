//
//  ReservationFlowViewModel.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import SwiftUI

class ReservationFlowViewModel: ObservableObject {
    // Variables para gestionar el flujo
    @Published var currentStep: Int = 0
    
    // Datos seleccionados en el flujo
    @Published var selectedPlayer: String? = nil
    @Published var selectedDate: Date?
    
    // Datos cargados desde el backend
    @Published var blockedDates: [String] = []
    @Published var availableDates: [String] = []
    @Published var availableSlots: [GamingSpaceTime] = []
    @Published var selectedSlots: [GamingSpaceTime] = []
    @Published var enabledSlots: [GamingSpaceTime] = []
    
    @Published var availableSpaces: [Space] = []
    @Published var selectedSpace: Space?
    @Published var userId: String = "f7a09e83-281e-4bb4-952a-e5ae40c99105"
    @Published var isLoading: Bool = false
    @Published var reservationSuccess: Bool = false
    var onReservationSuccess: () -> Void
    var onReservationFail: () -> Void
    
    private let blockedDaysService = BlockedDaysService()
    private let reservationService = ReservationService()
    let dateFormatter = DateFormatter()
    
    init(onReservationSuccess: @escaping () -> Void, onReservationFail: @escaping () -> Void) {
        self.onReservationSuccess = onReservationSuccess
        self.onReservationFail = onReservationFail
        fetchBlockedDates()
    }
    
    // Función para avanzar al siguiente paso
    func goToNextStep() {
        if currentStep < 2 {
            currentStep += 1
        }
    }
    
    // Función para retroceder al paso anterior
    func goToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func fetchBlockedDates() {
        blockedDaysService.fetchBlockedDates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dates):
                    self?.blockedDates = dates
                    self?.calculateAvailableDates()
                case .failure(let error):
                    print("Error fetching blocked dates: \(error)")
                }
            }
        }
    }
    
    private func calculateAvailableDates() {
        let today = Date()
        let calendar = Calendar.current
        
        var dates: [String] = []
        for offset in 0..<30 { // Calculamos los próximos 30 días
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                let formattedDate = DateFormatter.apiDateFormatter.string(from: date)
                if !blockedDates.contains(formattedDate) {
                    dates.append(formattedDate)
                }
            }
        }
        availableDates = dates
    }
    
    func fetchAvailableSlots(for dayValue: Int) {
        WeekTimeService.shared.fetchWeekTimeByDay(dayValue: dayValue) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let slots):
                    self?.availableSlots = slots
                    self?.updateEnabledSlots()
                case .failure(let error):
                    print("Error fetching slots: \(error)")
                }
            }
        }
    }
    
    func updateEnabledSlots() {
        guard !selectedSlots.isEmpty else {
            // Si no hay nada seleccionado, todos los slots están habilitados
            enabledSlots = availableSlots
            return
        }
        
        // Ordena los horarios seleccionados por valor
        let sortedSelected = selectedSlots.sorted(by: { $0.value < $1.value })
        
        // Determina los límites (mínimo y máximo) de las horas seleccionadas
        let minValue = sortedSelected.first?.value ?? 0
        let maxValue = sortedSelected.last?.value ?? 0
        
        // Calcula los horarios contiguos habilitados (máximo 3 consecutivos)
        enabledSlots = availableSlots.filter { slot in
            (slot.value >= minValue && slot.value <= maxValue + 1 && slot.value <= minValue + 2)
            || selectedSlots.contains(where: { $0.id == slot.id })
        }
    }
    
    // Maneja la selección y deselección de un slot
    func toggleSlotSelection(_ slot: GamingSpaceTime) {
        if selectedSlots.contains(where: { $0.id == slot.id }) {
            // Si ya está seleccionado, deselecciónalo
            selectedSlots.removeAll { $0.id == slot.id }
        } else {
            // Si no está seleccionado, añádelo
            selectedSlots.append(slot)
        }
        
        // Actualiza los horarios habilitados
        updateEnabledSlots()
    }
    
    func fetchAvailableSpaces() {
        SpaceService.shared.fetchSpaces { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let spaces):
                    self?.availableSpaces = spaces
                case .failure(let error):
                    print("Error fetching spaces: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Método para seleccionar un espacio
    func selectSpace(_ space: Space) {
        if selectedSpace?.id == space.id {
            selectedSpace = nil // Deselecciona si ya estaba seleccionado
        } else {
            selectedSpace = space // Selecciona el nuevo espacio
        }
    }
    
    func createReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              !selectedSlots.isEmpty else {
            print("Datos incompletos para crear la reserva")
            return
        }
        
        // Crear el objeto de reserva
        //let times = selectedSlots.map { $0.id }
        let times = selectedSlots
        
        let reservation = Reservation(
            id: 0, // El backend genera el ID
            status: "active",
            slot: space.slots.first ?? Slot(id: 0, position: "", space: 0),
            date: date,
            user: userId,
            team: nil,
            training: nil,
            qrImage: nil,
            qrValue: nil,
            times: times,
            peripheralLoans: []
        )
        
        // Enviar la reserva al backend
        isLoading = true
        reservationService.createReservation(reservation: reservation) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.reservationSuccess = true
                    self?.onReservationSuccess()
                    print("Reserva creada exitosamente")
                case .failure(let error):
                    self?.reservationSuccess = false
                    self?.onReservationFail()
                    print("Error al crear la reserva: \(error.localizedDescription)")
                }
            }
        }
    }
}
