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
    //    @Published var selectedPlayer: String? = nil
    @Published var selectedDate: Date?
    
    // Datos cargados desde el backend
    //@Published var blockedDates: [String] = []
    //@Published var availableDates: [String] = []
    @Published var availableSlots: [GamingSpaceTime] = []
    @Published var selectedSlots: [GamingSpaceTime] = []
    @Published var enabledSlots: [GamingSpaceTime] = []
    
    @Published var markedDates: [MarkTrainnigDatesAndReservetions] = []
    
    @Published var availableSpaces: [Space] = []
    @Published var selectedSpace: Space?
    @Published var isLoading: Bool = false
    @Published var isCreatingReservation: Bool = false
    @Published var reservationSuccess: Bool = false
    
    @Published var userManager = UserManager.shared
    
    var onReservationSuccess: () -> Void
    var onReservationFail: () -> Void
    
    //private let blockedDaysService = BlockedDaysService()
    private let reservationService = ReservationService()
    
    let dateFormatter = DateFormatter()
    
    init(onReservationSuccess: @escaping () -> Void, onReservationFail: @escaping () -> Void) {
        
        self.onReservationSuccess = onReservationSuccess
        self.onReservationFail = onReservationFail
        
        self.getBlockedDays()
        
        self.fetchTeamReservationsByUser {
            self.isLoading = false
        }
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
    
    func fetchTeamReservationsByUser(completion: @escaping () -> Void) {
        guard let user = userManager.getUser() else { return }
        
        self.isLoading = true
        
        let userId = user.id
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        reservationService.getReservesByUser(userId: userId ?? "") { [weak self] result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() } // Se asegura de salir del grupo al finalizar
                
                switch result {
                case .success(let reservations):
                    let innerDispatchGroup = DispatchGroup()
                    
                    for reservation in reservations {
                        innerDispatchGroup.enter()
                        
                        if let createDate = Utils.createDate(from: reservation.date) {
                            DispatchQueue.main.async {
                                self?.markedDates.append(MarkTrainnigDatesAndReservetions(date: createDate, individualReservation: true))
                            }
                        }
                    }
                    
                    // Esperamos que todas las llamadas internas terminen
                    innerDispatchGroup.notify(queue: .main) {
                        print("Reservas obtenidas: \(reservations)")
                    }
                    
                case .failure(let error):
                    print("Error al obtener reservas: \(error)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getBlockedDays() {
        self.isLoading = true
        
        reservationService.getAllBlockedDays { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let blockedDays):
                    for blockDay in blockedDays {
                        guard let blockDate = blockDay.date else { continue }
                        if let createDate = Utils.createDate(from: blockDate) {
                            DispatchQueue.main.async {
                                self?.markedDates.append(MarkTrainnigDatesAndReservetions(date: createDate, blockedDays: true))
                            }
                        }
                    }
                case .failure(let error):
                    print("Error al obtener los dias bloqueados: \(error)")
                }
            }
        }
    }
    
    func checkSelectedDate(_ stringDate: String) {
        self.selectedDate = convertToDate(from: stringDate)
        
        if let matchingDate = self.markedDates.first(where: { $0.date == selectedDate }) {
            if matchingDate.blockedDays { return }
        }
        
        self.currentStep += 1
    }
    
    func convertToDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Formato de la fecha seleccionada
        return formatter.date(from: dateString)
    }
    
    func fetchAvailableSlots(for dayValue: Int) {
        WeekTimeService.shared.fetchWeekTimeByDay(dayValue: dayValue) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let slots):
                    var newSlots: [GamingSpaceTime] = []
                    
                    for slot in slots {
                        
                        for time in slot.times {
                            newSlots.append(time.gamingSpaceTime)
                        }
                    }
                    
                    // Ordenar por fecha/hora usando el campo `time`
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm" // Ajustar según el formato real de `time`
                    dateFormatter.locale = Locale(identifier: "es_ES") // Ajusta según el idioma
                    
                    self?.availableSlots = newSlots.sorted {
                        guard let date1 = dateFormatter.date(from: $0.time),
                              let date2 = dateFormatter.date(from: $1.time) else {
                            return false
                        }
                        return date1 < date2
                    }
                    
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
                    
                    for space in spaces {
                        
                        guard let translation = space.translations.first(where: { $0.languagesCode == "es" }) else { continue }
                        
                        let space = Space(
                            id: UUID().hashValue,
                            device: translation.device,
                            description: translation.description,
                            slots: space.slots)
                        
                        self?.availableSpaces.append(space)
                        
                    }
                    
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
    
    func calculateDayValue(for date: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let date = formatter.date(from: date) else { return 0 }
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) // Domingo es 1
        return weekday - 1 // Convertir al formato requerido (Lunes = 1, Domingo = 7)
    }
    
    func createReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              let userId = userManager.getUser()?.id,
              !selectedSlots.isEmpty else {
            print("Datos incompletos para crear la reserva")
            return
        }
        
        let times = selectedSlots
        
        let reservation = Reservation(
            id: 0,
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

        self.isCreatingReservation = true
        reservationService.createReservation(reservation: reservation) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success (let reservation):
                    self?.updateReservationWithQR(reservationInfo: reservation)
                    print("Reserva creada exitosamente")
                case .failure(let error):
                    self?.isCreatingReservation = false
                    self?.reservationSuccess = false
                    self?.onReservationFail()
                    print("Error al crear la reserva: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateReservationWithQR(reservationInfo: ReserveResponse) {
        
        guard let reservationId = reservationInfo.id,
              let qrValue = reservationInfo.qrValue else { return }
        
        guard let date = selectedDate,
              let space = selectedSpace,
              let userId = userManager.getUser()?.id,
              !selectedSlots.isEmpty else {
            print("Datos incompletos para crear la reserva")
            return
        }
        
        let times = selectedSlots
        
        if let qrImage = QRCodeGenerator.generateQRCode(with: qrValue) {
            UploadImageService().uploadImage(image: qrImage, fileName: "\(qrValue).jpg" ,completion: { result in
                switch result {
                case .success(let response):
                    print("Imagen subida con éxito: \(response)")
                    
                    if let data = response.data(using: .utf8) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(SendImageResponse.self, from: data)
                            let fileId = decodedResponse.data.id
                            print("Imagen subida con éxito. ID: \(fileId)")
                            
                            
                            let reservation = Reservation(
                                id: 0, // El backend genera el ID
                                status: "active",
                                slot: space.slots.first ?? Slot(id: 0, position: "", space: 0),
                                date: date,
                                user: userId,
                                team: nil,
                                training: nil,
                                qrImage: fileId,
                                qrValue: qrValue,
                                times: times,
                                peripheralLoans: []
                            )
                            
                            self.reservationService.updateExistingReservation(reservationId: reservationId, qrImage: fileId, reservation: reservation) { [weak self] result in
                                DispatchQueue.main.async {
                                    self?.isLoading = false
                                    switch result {
                                    case .success:
                                        self?.isCreatingReservation = true
                                        print("Reserva creada exitosamente")
                                        self?.reservationSuccess = true
                                        self?.onReservationSuccess()

                                    case .failure(let error):
                                        self?.isCreatingReservation = true
                                        print("Error al crear la reserva: \(error.localizedDescription)")
                                        self?.reservationSuccess = false
                                        self?.onReservationFail()
                                    }
                                }
                            }
                            
                        } catch {
                            print("Error al decodificar JSON: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Error al subir la imagen: \(error.localizedDescription)")
                    self.isCreatingReservation = true
                    self.reservationSuccess = false
                    self.onReservationFail()
                }
            })
        }
    }
}
