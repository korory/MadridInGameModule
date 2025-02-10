import SwiftUI

struct TeamReservationCellComponentView: View {
    @ObservedObject var viewModel: TeamReservationCellComponentViewModel
    let action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Cabecera con icono y fecha
            HStack {
                iconAndDateComponent
                Spacer()
                removeReservationButton
            }
            VStack(alignment: .leading, spacing: 8) {
                slotInfoComponent
                hoursComponent
            }
            buttonsComponent
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

extension TeamReservationCellComponentView {
    // Icono y fecha de la reserva
    private var iconAndDateComponent: some View {
        HStack {
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.yellow)
                .padding(.trailing, 2)
            
            Text(viewModel.reservation.date.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
        }
    }

    // Botón para eliminar la reserva
    private var removeReservationButton: some View {
        Button {
            action(.removeCell)
        } label: {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.red)
        }
    }

    // Información del slot asociado a la reserva
    private var slotInfoComponent: some View {
        Text("Slot: \(viewModel.reservation.slot.position)")
            .font(.subheadline)
            .foregroundColor(Color.cyan.opacity(0.8))
            .fontWeight(.semibold)
    }

    // Horas de la reserva
    private var hoursComponent: some View {
        Text(viewModel.reservation.times.count > 1
             ? "Horas: \(viewModel.reservation.times.map { $0.time }.joined(separator: ", "))"
             : "Hora: \(viewModel.reservation.times.map { $0.time }.joined(separator: ", "))")
            .font(.body)
            .foregroundColor(.white)
    }

    // Botones de acciones (ver detalles y editar)
    private var buttonsComponent: some View {
        HStack {
            Spacer()
            Button {
                action(.seeDetails)
            } label: {
                HStack {
                    Image(systemName: "eye")
                        .foregroundColor(.cyan)
                    Text("Ver detalles")
                        .foregroundColor(.cyan)
                        .fontWeight(.semibold)
                }
            }
            Spacer()
            Button {
                action(.editTraining)
            } label: {
                Text("Editar")
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .padding(.top, 10)
    }
}
