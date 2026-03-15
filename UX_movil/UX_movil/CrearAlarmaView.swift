import SwiftUI

// MARK: - Crear Alarma View

struct CrearAlarmaView: View {
    @Binding var alarmas: [Alarma]
    @Environment(\.dismiss) private var dismiss

    @State private var hora: Int = 8
    @State private var minuto: Int = 30
    @State private var esPM: Bool = true
    @State private var diasSeleccionados: Set<Int> = [0, 1, 2]
    @State private var etiqueta: String = ""
    @State private var posponer: Bool = true
    @State private var vibracion: Bool = true
    @State private var colorSeleccionado: ColorOpcion = ColorOpcion.todos[0]
    @State private var mostrarSelectorColor: Bool = false

    private let dias        = ["L", "M", "X", "J", "V", "S", "D"]
    private let nombresCortos = ["Lun", "Mar", "Mier", "Jue", "Vie", "Sáb", "Dom"]

    private var repeticionTexto: String {
        if diasSeleccionados.isEmpty  { return "Nunca" }
        if diasSeleccionados.count == 7 { return "Todos los días" }
        return diasSeleccionados.sorted().map { nombresCortos[$0] }.joined(separator: ", ")
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Scrollable form ────────────────────────────────────────
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    timePickerSection
                    formSection
                    Spacer(minLength: 32)
                }
            }

            // ── Save button ────────────────────────────────────────────
            saveButton
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
        .sheet(isPresented: $mostrarSelectorColor) {
            SelectorColorView(colorSeleccionado: $colorSeleccionado)
        }
    }

    // MARK: Header

    private var headerSection: some View {
        HStack {
            Text("Crear Alarma")
                .font(.system(size: 30, weight: .bold))
            Spacer()
            // X → discard and go back to AlarmasView
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 40, height: 40)
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    // MARK: Time Picker

    private var timePickerSection: some View {
        TimePickerView(hora: $hora, minuto: $minuto, esPM: $esPM)
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
    }

    // MARK: Form

    private var formSection: some View {
        VStack(spacing: 0) {
            repetirRow
            Divider().padding(.leading, 20)
            etiquetaRow
            Divider().padding(.leading, 20)
            sonidoRow
            Divider().padding(.leading, 20)
            posponerRow
            Divider().padding(.leading, 20)
            vibracionRow
            Divider().padding(.leading, 20)
            colorRow
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: Form rows

    private var repetirRow: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Repetir")
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text(repeticionTexto)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            HStack(spacing: 10) {
                ForEach(0..<7) { i in
                    DiaCircleButton(letra: dias[i], seleccionado: diasSeleccionados.contains(i)) {
                        if diasSeleccionados.contains(i) {
                            diasSeleccionados.remove(i)
                        } else {
                            diasSeleccionados.insert(i)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }

    private var etiquetaRow: some View {
        HStack {
            Text("Etiqueta")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            TextField("Nombre de la alarma", text: $etiqueta)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .frame(maxWidth: 200)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
    }

    private var sonidoRow: some View {
        HStack {
            Text("Sonido")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            HStack(spacing: 4) {
                Text("Seleccionar sonido")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
    }

    private var posponerRow: some View {
        HStack {
            Text("Posponer")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Toggle("", isOn: $posponer)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.20, green: 0.80, blue: 0.40)))
                .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var vibracionRow: some View {
        HStack {
            Text("Vibración")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Toggle("", isOn: $vibracion)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.20, green: 0.80, blue: 0.40)))
                .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var colorRow: some View {
        HStack {
            Text("Color")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            HStack(spacing: 8) {
                Circle()
                    .fill(colorSeleccionado.color)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 1))
                Text(colorSeleccionado.nombre)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture { mostrarSelectorColor = true }
    }

    // MARK: Save button

    private var saveButton: some View {
        Button(action: guardarAlarma) {
            Text("Guardar")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(red: 0.15, green: 0.47, blue: 0.98))
                )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Save logic

    private func guardarAlarma() {
        let nueva = Alarma(
            hora:       String(format: "%02d:%02d", hora, minuto),
            periodo:    esPM ? "PM" : "AM",
            etiqueta:   etiqueta.isEmpty ? "Mi alarma" : etiqueta,
            repeticion: repeticionTexto,
            activa:     true,
            color:      colorSeleccionado.color
        )
        alarmas.append(nueva)
        dismiss()   // ← pop back to AlarmasView, new alarm already in list
    }
}

// MARK: - Time Picker

struct TimePickerView: View {
    @Binding var hora: Int
    @Binding var minuto: Int
    @Binding var esPM: Bool

    var body: some View {
        HStack(spacing: 12) {
            NumberPickerBox(value: $hora, rango: 1...12)

            Text(":")
                .font(.system(size: 36, weight: .bold))
                .padding(.bottom, 2)

            NumberPickerBox(value: $minuto, rango: 0...59)

            // AM / PM toggle
            VStack(spacing: 0) {
                amPmButton(label: "AM", active: !esPM) { esPM = false }
                amPmButton(label: "PM", active: esPM)  { esPM = true  }
            }
            .frame(width: 68)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .clipped()
        }
    }

    @ViewBuilder
    private func amPmButton(label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(active ? .white : .secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(active ? Color(red: 0.15, green: 0.47, blue: 0.98) : Color.clear)
        }
    }
}

struct NumberPickerBox: View {
    @Binding var value: Int
    let rango: ClosedRange<Int>

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 80)
            Picker("", selection: $value) {
                ForEach(rango, id: \.self) { n in
                    Text(String(format: "%02d", n))
                        .font(.system(size: 42, weight: .bold))
                        .tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 96, height: 76)
            .clipped()
        }
    }
}

// MARK: - Day Circle Button

struct DiaCircleButton: View {
    let letra: String
    let seleccionado: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            Text(letra)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(seleccionado ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(
                        seleccionado
                            ? Color(red: 0.15, green: 0.47, blue: 0.98)
                            : Color(.systemGray5)
                    )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Color Selector Sheet

struct SelectorColorView: View {
    @Binding var colorSeleccionado: ColorOpcion
    @Environment(\.dismiss) private var dismiss

    private let columnas = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // Title row
            HStack {
                Text("Elige un color")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button(action: { dismiss() }) {
                    ZStack {
                        Circle().fill(Color(.systemGray5)).frame(width: 34, height: 34)
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            // Selected color preview
            HStack(spacing: 16) {
                Circle()
                    .fill(colorSeleccionado.color)
                    .frame(width: 52, height: 52)
                    .shadow(color: colorSeleccionado.color.opacity(0.5), radius: 8, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 4) {
                    Text(colorSeleccionado.nombre)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Color seleccionado")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(colorSeleccionado.color)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(colorSeleccionado.color.opacity(0.12))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
            .animation(.easeInOut(duration: 0.2), value: colorSeleccionado)

            // Color grid
            LazyVGrid(columns: columnas, spacing: 20) {
                ForEach(ColorOpcion.todos) { opcion in
                    ColorCircleButton(opcion: opcion, seleccionado: colorSeleccionado == opcion) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                            colorSeleccionado = opcion
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // Confirm button (color matches selection)
            Button(action: { dismiss() }) {
                Text("Confirmar")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(colorSeleccionado.color)
                    )
                    .animation(.easeInOut(duration: 0.25), value: colorSeleccionado)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Color Circle Button

struct ColorCircleButton: View {
    let opcion: ColorOpcion
    let seleccionado: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            VStack(spacing: 8) {
                ZStack {
                    if seleccionado {
                        Circle()
                            .stroke(opcion.color, lineWidth: 3)
                            .frame(width: 58, height: 58)
                    }
                    Circle()
                        .fill(opcion.color)
                        .frame(width: 46, height: 46)
                        .shadow(color: opcion.color.opacity(seleccionado ? 0.5 : 0.2),
                                radius: seleccionado ? 8 : 4, x: 0, y: 3)
                        .overlay(
                            Group {
                                if seleccionado {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        )
                        .scaleEffect(seleccionado ? 1.1 : 1.0)
                }
                .frame(width: 60, height: 60)

                Text(opcion.nombre)
                    .font(.system(size: 11, weight: seleccionado ? .semibold : .regular))
                    .foregroundColor(seleccionado ? opcion.color : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CrearAlarmaView(alarmas: .constant([]))
    }
}
