//
//  CustomCalendarViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

class CustomCalendarViewModel: ObservableObject {
    @Published var currentDate = Date()
    @Published var selectedDate: Date?
    let calendar = Calendar.current
    
    let daysOfWeek = ["L", "M", "M", "J", "V", "S", "D"]
    
    // Función para cambiar el mes
    func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }
    
    // Generar los días del mes actual, incluyendo los del mes anterior y siguiente para completar las semanas
    func generateDaysInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        
        var days = range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
        
        // Días de padding al principio del mes
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let paddingDaysBefore = (firstWeekday + 5) % 7
        let previousMonthDays = (1...paddingDaysBefore).compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: -day, to: firstDayOfMonth)
        }.reversed()
        
        days.insert(contentsOf: previousMonthDays, at: 0)
        
        // Días de padding al final del mes
        let remainingDays = (7 - (days.count % 7)) % 7
        let nextMonthDays = (1...remainingDays).compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day, to: days.last!)
        }
        
        days.append(contentsOf: nextMonthDays)
        
        return days
    }
    
    func dateText(for date: Date) -> String {
        return "\(calendar.component(.day, from: date))"
    }
    
    func isInCurrentMonth(date: Date) -> Bool {
        return calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    func monthAndYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date).capitalized
    }
    
    func onDateSelected(_ date: Date) {
        let localDate = calendar.startOfDay(for: date)
        self.selectedDate = localDate // Actualiza la fecha seleccionada
    }
    
    func isDateSelectedValid(_ date: Date) -> Bool {
        let currentDate = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: date)
        return selectedDate >= currentDate
    }
    
    func isDayEnabled(_ date: Date) -> Bool {
        return date >= calendar.startOfDay(for: Date())
    }
    
    func selectDate(_ date: Date, onDateSelected: (String) -> Void) {
        if isDayEnabled(date), isDateSelectedValid(date) {
            let selectedDate = calendar.date(byAdding: .hour, value: 0, to: calendar.startOfDay(for: date))!
            self.selectedDate = selectedDate // Actualiza la fecha seleccionada
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            print("Selected date: \(formatter.string(from: selectedDate))")
            onDateSelected(formatter.string(from: selectedDate)) // Llama al closure
        }
    }
}

extension Array {
    // Función auxiliar para dividir en chunks
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
