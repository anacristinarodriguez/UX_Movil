import SwiftUI

// MARK: - Root View
// Wraps everything in a NavigationStack and owns the shared alarmas state.

struct RootView: View {
    @State private var alarmas: [Alarma] = [
        Alarma(hora: "06:45", periodo: "AM", etiqueta: "Despertarme",    repeticion: "L M X J V", activa: true,  color: Color(red: 0.55, green: 0.35, blue: 0.95)),
        Alarma(hora: "08:30", periodo: "AM", etiqueta: "Tomar medicina",  repeticion: "Diario",    activa: true,  color: Color(red: 0.95, green: 0.35, blue: 0.35)),
        Alarma(hora: "10:00", periodo: "AM", etiqueta: "Reunión",         repeticion: "Lunes",     activa: true,  color: Color(red: 0.25, green: 0.85, blue: 0.75)),
        Alarma(hora: "11:00", periodo: "PM", etiqueta: "Mi alarma",       repeticion: "Única",     activa: false, color: Color(red: 0.95, green: 0.75, blue: 0.25)),
    ]

    var body: some View {
        NavigationStack {
            AlarmasView(alarmas: $alarmas)
                // Defines where each AppRuta leads
                .navigationDestination(for: AppRuta.self) { ruta in
                    switch ruta {
                    case .crearAlarma:
                        CrearAlarmaView(alarmas: $alarmas)
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
