import SwiftUI

// MARK: - Alarmas View

struct AlarmasView: View {
    @Binding var alarmas: [Alarma]
    @State private var tabSeleccionada: Int = 0

    var body: some View {
        VStack(spacing: 0) {

            // ── Scrollable content ─────────────────────────────────────
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    plantillasSection
                    misAlarmasSection
                }
            }

            // ── Bottom tab bar ──────────────────────────────────────────
            TabBarView(seleccionada: $tabSeleccionada)
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
    }

    // MARK: Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Alarmas")
                    .font(.system(size: 34, weight: .bold))
                Text("Crea y gestiona tus alarmas")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                // Settings button
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 44, height: 44)
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                    }
                }

                // "+" button → push to CrearAlarmaView
                NavigationLink(value: AppRuta.crearAlarma) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.95, green: 0.75, blue: 0.25))
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 28)
    }

    // MARK: Quick Templates

    private var plantillasSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("PLANTILLAS RÁPIDAS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(1.0)
                .padding(.horizontal, 20)

            HStack(spacing: 16) {
                PlantillaButton(
                    icono: "cross.fill",
                    nombre: "Medicina",
                    colorFondo: Color(red: 1.0,  green: 0.88, blue: 0.88),
                    colorIcono: Color(red: 0.95, green: 0.35, blue: 0.35)
                )
                PlantillaButton(
                    icono: "calendar",
                    nombre: "Evento",
                    colorFondo: Color(red: 0.82, green: 0.96, blue: 0.94),
                    colorIcono: Color(red: 0.25, green: 0.75, blue: 0.65)
                )
                PlantillaButton(
                    icono: "moon.fill",
                    nombre: "Dormir",
                    colorFondo: Color(red: 0.92, green: 0.88, blue: 0.98),
                    colorIcono: Color(red: 0.55, green: 0.30, blue: 0.90)
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
    }

    // MARK: Alarm List

    private var misAlarmasSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("MIS ALARMAS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(1.0)
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
                ForEach($alarmas) { $alarma in
                    AlarmaCard(alarma: $alarma)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Plantilla Button

struct PlantillaButton: View {
    let icono: String
    let nombre: String
    let colorFondo: Color
    let colorIcono: Color

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(colorFondo)
                    .frame(width: 70, height: 70)
                Image(systemName: icono)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(colorIcono)
            }
            Text(nombre)
                .font(.system(size: 13))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Alarma Card

struct AlarmaCard: View {
    @Binding var alarma: Alarma

    var body: some View {
        HStack(spacing: 0) {
            // Color accent bar
            RoundedRectangle(cornerRadius: 3)
                .fill(alarma.activa ? alarma.color : Color(.systemGray4))
                .frame(width: 5)
                .padding(.vertical, 8)

            // Time + label
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(alarma.hora)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(alarma.activa ? .primary : .secondary)
                    Text(alarma.periodo)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(alarma.activa ? .primary : .secondary)
                }
                HStack(spacing: 4) {
                    Text(alarma.etiqueta)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text("·")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text(alarma.repeticion)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 16)

            Spacer()

            Toggle("", isOn: $alarma.activa)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.20, green: 0.80, blue: 0.40)))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Tab Bar

struct TabBarView: View {
    @Binding var seleccionada: Int

    private let tabs: [(icono: String, nombre: String)] = [
        ("alarm",     "ALARMAS"),
        ("stopwatch", "CRONÓMETRO"),
        ("clock",     "RELOJ"),
        ("hourglass", "TEMPORIZADOR"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { i in
                    Button(action: { seleccionada = i }) {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[i].icono)
                                .font(.system(size: 20, weight: seleccionada == i ? .semibold : .regular))
                                .foregroundColor(seleccionada == i ? .primary : Color(.systemGray3))
                            Text(tabs[i].nombre)
                                .font(.system(size: 9, weight: seleccionada == i ? .semibold : .regular))
                                .foregroundColor(seleccionada == i ? .primary : Color(.systemGray3))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                }
            }
            .background(Color(.systemBackground))
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    RootView()
}
