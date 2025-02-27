//
//  CustomCalendarView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

struct CustomCalendarView: View {
    @StateObject private var viewModel = CustomCalendarViewModel()
    var canUserInteract: Bool
    var markedDates: [MarkTrainnigDatesAndReservetions] = []
    var onDateSelected: (String) -> Void
    
    var body: some View {
        VStack {
            bannerSelectMonth
            calendarTitleDays
            calendarNumberDays
        }
        .padding(.top, 20)
    }
    
    private var bannerSelectMonth: some View {
        HStack {
            Button(action: {
                viewModel.changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
            }
            Spacer()
            Text(viewModel.monthAndYearString(viewModel.currentDate).uppercased())
                .font(.custom("Madridingamefont-Regular", size: 20))
                .foregroundStyle(Color.white)
            Spacer()
            Button(action: {
                viewModel.changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 35)
        .padding(.bottom, 10)
    }
    
    private var calendarTitleDays: some View {
        HStack {
            ForEach(viewModel.daysOfWeek, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal)
    }
    
    private var calendarNumberDays: some View {
        VStack {
            // Genera los días del mes y los divide en filas de 7 (una semana).
            let days = viewModel.generateDaysInMonth(for: viewModel.currentDate)
            let rows = days.chunked(into: 7)
            
            // Crea una vista de semanas (filas) en el calendario.
            VStack {
                ForEach(rows, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { date in
                            VStack {
                                ZStack {
                                    // Estilo para el día actual
                                    self.createTodayCircle(for: date)
                                    
                                    // Buscar las fechas marcadas para el día actual
                                    self.createMarkedDates(for: date)
                                    
                                    // Estilo para el día habilitado
                                    self.createEnabledDayCircle(for: date)
                                    
                                    // Estilo para el día deshabilitado
                                    self.createDisabledDayText(for: date)
                                }
                                .onTapGesture {
                                    self.handleDaySelection(date)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func createTodayCircle(for date: Date) -> some View {
        let isToday = viewModel.calendar.isDateInToday(date)
        if isToday {
            return AnyView(Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 47, height: 47))
        }
        return AnyView(EmptyView())
    }
    
    private func createMarkedDates(for date: Date) -> some View {
        let markedDatesForDay = markedDates.filter {
            viewModel.calendar.isDate($0.date, inSameDayAs: date)
        }

        var circles: [AnyView] = []
        var usedTypes: Set<String> = [] // Para evitar duplicados
        var size: CGFloat = 42

        // Primero, si hay un bloqueado, lo agregamos
        if (markedDatesForDay.first(where: { $0.blockedDays }) != nil) {
            circles.append(AnyView(
                Circle()
                    .stroke(Color.red, lineWidth: 3)
                    .frame(width: size, height: size)
            ))
            usedTypes.insert("blocked")
            size -= 6
        }

        // Luego agregamos los demás (reservas individuales y estándar)
        for markedDate in markedDatesForDay {
            let type: String
            let color: Color

            if markedDate.individualReservation {
                type = "reservation"
                color = .blue
            } else {
                type = "default"
                color = .cyan
            }

            if !usedTypes.contains(type) { // Evita dibujar duplicados
                circles.append(AnyView(
                    Circle()
                        .stroke(color, lineWidth: 3)
                        .frame(width: size, height: size)
                ))
                usedTypes.insert(type)
                size -= 6
            }
        }

        return AnyView(ZStack {
            ForEach(circles.indices, id: \.self) { index in
                circles[index]
            }
        })
    }

    
    private func createEnabledDayCircle(for date: Date) -> some View {
        return AnyView(ZStack {
            Circle()
                .stroke(Color.clear, lineWidth: 2)
                .frame(width: 32, height: 32)
            
            Text(viewModel.dateText(for: date))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
    }
    
    private func createDisabledDayText(for date: Date) -> some View {
        if !viewModel.isDayEnabled(date) {
            return AnyView(Text(viewModel.dateText(for: date))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.gray))
        }
        return AnyView(EmptyView())
    }
    
    private func handleDaySelection(_ date: Date) {
        if canUserInteract, viewModel.isDayEnabled(date), viewModel.isDateSelectedValid(date) {
            // Selección del día, asegurando que se realiza correctamente.
            let selectedDate = viewModel.calendar.date(byAdding: .hour, value: 0, to: viewModel.calendar.startOfDay(for: date))!
            viewModel.onDateSelected(selectedDate)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            print("Selected date: \(formatter.string(from: date))")
            onDateSelected(formatter.string(from: date))
        }
    }
}

//struct CustomCalendarView: View {
//    @StateObject private var viewModel = CustomCalendarViewModel()
//    var canUserInteract: Bool
//    var markedDates: [MarkTrainnigDatesAndReservetions] = []
//    var onDateSelected: (String) -> Void
//
//    var body: some View {
//        VStack {
//            bannerSelectMonth
//            calendarTitleDays
//            calendarNumberDays
//        }
//        .padding()
//    }
//
//    private var bannerSelectMonth: some View {
//        HStack {
//            Button(action: {
//                viewModel.changeMonth(by: -1)
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundStyle(.white)
//            }
//            Spacer()
//            Text(viewModel.monthAndYearString(viewModel.currentDate).uppercased())
//                .font(.custom("Madridingamefont-Regular", size: 20))
//                .foregroundStyle(Color.white)
//            Spacer()
//            Button(action: {
//                viewModel.changeMonth(by: 1)
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundStyle(.white)
//            }
//        }
//        .padding(.leading, 35)
//        .padding(.trailing, 35)
//        .padding(.bottom, 10)
//    }
//
//    private var calendarTitleDays: some View {
//        // Días de la semana
//        HStack {
//            ForEach(viewModel.daysOfWeek, id: \.self) { day in
//                if #available(iOS 16.0, *) {
//                    Text(day)
//                        .frame(maxWidth: .infinity)
//                        .foregroundStyle(Color.white)
//                        .fontWeight(.bold)
//                } else {
//                    Text(day)
//                        .frame(maxWidth: .infinity)
//                        .foregroundStyle(Color.white)
//                        .font(.footnote.weight(.bold))
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    private var calendarNumberDays: some View {
//        VStack {
//            let days = viewModel.generateDaysInMonth(for: viewModel.currentDate)
//            let rows = days.chunked(into: 7)
//            VStack {
//                ForEach(rows, id: \.self) { row in
//                    HStack {
//                        ForEach(row, id: \.self) { date in
//                            VStack {
//                                ZStack {
//                                    // Dibuja un círculo solo si es el día actual
//                                    if viewModel.calendar.isDateInToday(date) {
//                                        Circle()
//                                            .stroke(Color.white, lineWidth: 2)
//                                            .frame(width: 40, height: 40)
//                                    }
//
//                                    // Verifica si la fecha está marcada
//                                    if let markedDate = markedDates.first(where: { viewModel.calendar.isDate($0.date, inSameDayAs: date) }) {
//                                        Circle()
//                                            .stroke(markedDate.blockedDays ?  Color(red: 1, green: 0.0, blue: 0.0) : markedDate.individualReservation ? Color(red: 0.0, green: 0.0, blue: 1) : Color.cyan, lineWidth: 2)
//                                            .frame(width: 40, height: 40)
//                                    }
//
//                                    // Cambia el fondo y el color del texto según si el día está habilitado
//                                    if viewModel.isDayEnabled(date) {
//                                        ZStack {
//                                            Circle()
//                                                .fill(viewModel.selectedDate == date ? Color.cyan : Color.clear)
//                                                .frame(width: 32, height: 32)
//
//                                            Circle()
//                                                .stroke(viewModel.selectedDate == date ? Color.cyan : Color.clear, lineWidth: 2)
//                                                .frame(width: 32, height: 32)
//
//                                            Text(viewModel.dateText(for: date))
//                                                .foregroundColor(.white)
//                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                        }
//                                    } else {
//                                        Text(viewModel.dateText(for: date))
//                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                                .onTapGesture {
//                                    if canUserInteract {
//                                        if viewModel.isDayEnabled(date), viewModel.isDateSelectedValid(date) {
//                                            let selectedDate = viewModel.calendar.date(byAdding: .hour, value: 0, to: viewModel.calendar.startOfDay(for: date))!
//                                            viewModel.onDateSelected(selectedDate)
//                                            let formatter = DateFormatter()
//                                            formatter.dateFormat = "dd/MM/yyyy"
//                                            print("Selected date: \(formatter.string(from: date))")
//                                            onDateSelected(formatter.string(from: date))
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
