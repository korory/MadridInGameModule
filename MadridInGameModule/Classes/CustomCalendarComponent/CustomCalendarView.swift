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
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    // Verifica si la fecha está marcada
                                    if let markedDate = markedDates.first(where: { viewModel.calendar.isDate($0.date, inSameDayAs: date) }) {
                                        Circle()
                                            .stroke(markedDate.blockedDays ?  Color(red: 1, green: 0.0, blue: 0.0) : markedDate.individualReservation ? Color(red: 0.0, green: 0.0, blue: 1) : Color.cyan, lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    // Cambia el fondo y el color del texto según si el día está habilitado
                                    if viewModel.isDayEnabled(date) {
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
                                        Text(viewModel.dateText(for: date))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(.gray)
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

