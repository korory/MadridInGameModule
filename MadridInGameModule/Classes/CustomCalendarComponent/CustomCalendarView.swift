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
    var markedDates: [Date]
    var onDateSelected: (String) -> Void
    
    var body: some View {
        VStack {
            bannerSelectMonth
            calendarTitleDays
            calendarNumberDays
        }
        .padding()
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
        .padding(.leading, 35)
        .padding(.trailing, 35)
        .padding(.bottom, 10)
    }
    
    private var calendarTitleDays: some View {
        // Días de la semana
        HStack {
            ForEach(viewModel.daysOfWeek, id: \.self) { day in
                if #available(iOS 16.0, *) {
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                } else {
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .font(.footnote.weight(.bold))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var calendarNumberDays: some View {
        VStack {
            let days = viewModel.generateDaysInMonth(for: viewModel.currentDate)
            let rows = days.chunked(into: 7)
            VStack {
                ForEach(rows, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { date in
                            VStack {
                                ZStack {
                                    // Dibuja un círculo solo si es el día actual
                                    if viewModel.calendar.isDateInToday(date) {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2) // Borde del círculo
                                            .frame(width: 40, height: 40) // Tamaño del círculo
                                    }
                                    
                                    // Dibuja un círculo si la fecha está marcada
                                    if markedDates.contains(where: { viewModel.calendar.isDate($0, inSameDayAs: date) }) {
                                        Circle()
                                            .stroke(Color.cyan, lineWidth: 2) // Circunferencia roja para las fechas marcadas
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    // Cambia el fondo y el color del texto según si el día está habilitado
                                    if viewModel.isDayEnabled(date) {
                                        ZStack {
                                            // Fondo redondo
                                            Circle()
                                                .fill(viewModel.selectedDate == date ? Color.cyan : Color.clear) // Color del fondo según la selección
                                                .frame(width: 32, height: 32) // Tamaño del fondo
                                            
                                            // Borde del círculo
                                            Circle()
                                                .stroke(viewModel.selectedDate == date ? Color.cyan : Color.clear, lineWidth: 2) // Borde del círculo solo si es la fecha seleccionada
                                                .frame(width: 32, height: 32) // Tamaño del borde
                                            
                                            // Texto
                                            Text(viewModel.dateText(for: date))
                                                .foregroundColor(.white) // Color del texto habilitado
                                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegúrate de que el texto ocupe el espacio disponible
                                        }
                                        
                                    } else {
                                        Text(viewModel.dateText(for: date))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(.gray) // Color del texto deshabilitado
                                    }
                                }
                                .onTapGesture {
                                    if canUserInteract {
                                        if viewModel.isDayEnabled(date), viewModel.isDateSelectedValid(date) {
                                            let selectedDate = viewModel.calendar.date(byAdding: .hour, value: 0, to: viewModel.calendar.startOfDay(for: date))!
                                            viewModel.onDateSelected(selectedDate)
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd/MM/yyyy"
                                            print("Selected date: \(formatter.string(from: date))")
                                            onDateSelected(formatter.string(from: date))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CustomCalendarView(canUserInteract: true, markedDates:[]) { date in
        print("Selected date: \(date)")
    }
}

struct CustomReservationCalendarView: View {
    @StateObject private var viewModel = CustomCalendarViewModel()
    var canUserInteract: Bool
    var markedDates: [Date]
    var blockedDates: [Date] // Fechas bloqueadas
    var onDateSelected: (String) -> Void
    
    var body: some View {
        VStack {
            bannerSelectMonth
            calendarTitleDays
            calendarNumberDays
        }
        .padding()
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
                .font(.system(size: 20).weight(.bold))
                .foregroundStyle(Color.white)
            Spacer()
            Button(action: {
                viewModel.changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
        }
        .padding(.leading, 35)
        .padding(.trailing, 35)
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
            let days = viewModel.generateDaysInMonth(for: viewModel.currentDate)
            let rows = days.chunked(into: 7)
            VStack {
                ForEach(rows, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { date in
                            VStack {
                                ZStack {
                                    // Dibuja un círculo solo si es el día actual
                                    if viewModel.calendar.isDateInToday(date) {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    // Dibuja un círculo si la fecha está marcada
                                    if markedDates.contains(where: { viewModel.calendar.isDate($0, inSameDayAs: date) }) {
                                        Circle()
                                            .stroke(Color.cyan, lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    // Cambia el fondo y el color del texto según si el día está bloqueado o habilitado
                                    if blockedDates.contains(where: { viewModel.calendar.isDate($0, inSameDayAs: date) }) {
                                        // Fechas bloqueadas
                                        Text(viewModel.dateText(for: date))
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    } else if viewModel.isDayEnabled(date) {
                                        // Fechas habilitadas
                                        ZStack {
                                            Circle()
                                                .fill(viewModel.selectedDate == date ? Color.cyan : Color.clear)
                                                .frame(width: 32, height: 32)
                                            
                                            Circle()
                                                .stroke(viewModel.selectedDate == date ? Color.cyan : Color.clear, lineWidth: 2)
                                                .frame(width: 32, height: 32)
                                            
                                            Text(viewModel.dateText(for: date))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                    } else {
                                        // Fechas deshabilitadas
                                        Text(viewModel.dateText(for: date))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .onTapGesture {
                                    if canUserInteract {
                                        if !blockedDates.contains(where: { viewModel.calendar.isDate($0, inSameDayAs: date) }) && viewModel.isDayEnabled(date) {
                                            let selectedDate = viewModel.calendar.date(byAdding: .hour, value: 0, to: viewModel.calendar.startOfDay(for: date))!
                                            viewModel.onDateSelected(selectedDate)
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd/MM/yyyy"
                                            print("Selected date: \(formatter.string(from: date))")
                                            onDateSelected(formatter.string(from: date))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

