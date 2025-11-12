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

    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar
    }()
    
    var daysOfWeek: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let firstIndex = calendar.firstWeekday - 1
        return Array(symbols[firstIndex...] + symbols[..<firstIndex])
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = calendar.locale
        return formatter
    }
    
    // Función para cambiar el mes
    func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }
    
//    // Generar los días del mes actual, incluyendo los del mes anterior y siguiente para completar las semanas
//    func generateDaysInMonth(for date: Date) -> [Date] {
//        guard let range = calendar.range(of: .day, in: .month, for: date),
//              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
//        else { return [] }
//        
//        var days = range.compactMap { day -> Date? in
//            return calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
//        }
//        
//        // Días de padding al principio del mes
//        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
//        let paddingDaysBefore = (firstWeekday + 5) % 7
//        let previousMonthDays = (1...paddingDaysBefore).compactMap { day -> Date? in
//            return calendar.date(byAdding: .day, value: -day, to: firstDayOfMonth)
//        }.reversed()
//        
//        days.insert(contentsOf: previousMonthDays, at: 0)
//        
//        // Días de padding al final del mes
//        let remainingDays = (7 - (days.count % 7)) % 7
//        let nextMonthDays = (1...remainingDays).compactMap { day -> Date? in
//            return calendar.date(byAdding: .day, value: day, to: days.last!)
//        }
//        
//        days.append(contentsOf: nextMonthDays)
//        
//        return days
//    }
    
    func generateDaysInMonth(for date: Date) -> [Date] {
        guard
            let range = calendar.range(of: .day, in: .month, for: date),
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }

        // Generate days in the current month
        var days: [Date] = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }

        // Determine the first weekday according to the locale
        let firstWeekdayIndex = (calendar.firstWeekday - 1 + 7) % 7
        let firstDayWeekday = (calendar.component(.weekday, from: firstDayOfMonth) - 1 + 7) % 7

        // Calculate padding before
        let paddingDaysBefore = (firstDayWeekday - firstWeekdayIndex + 7) % 7

        if paddingDaysBefore > 0 {
            let prev = (1...paddingDaysBefore).compactMap { day in
                calendar.date(byAdding: .day, value: -day, to: firstDayOfMonth)
            }.reversed()
            days.insert(contentsOf: prev, at: 0)
        }

        // Padding at the end to complete full weeks
        let remainder = days.count % 7
        let remainingDays = (7 - remainder) % 7

        if remainingDays > 0, let last = days.last {
            let next = (1...remainingDays).compactMap { day in
                calendar.date(byAdding: .day, value: day, to: last)
            }
            days.append(contentsOf: next)
        }

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
        if date.isInCurrentYear {
            formatter.dateFormat = "MMMM"
        } else {
            formatter.dateFormat = "MMMM yyyy"
        }
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
            Logger.shared.log("Selected date: \(formatter.string(from: selectedDate))")
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
