import SwiftUI

// MARK: - Alarma Model

struct Alarma: Identifiable {
    let id = UUID()
    var hora: String        // e.g. "06:45"
    var periodo: String     // "AM" | "PM"
    var etiqueta: String
    var repeticion: String
    var activa: Bool
    var color: Color
}

// MARK: - Color Option Model

struct ColorOpcion: Identifiable, Equatable {
    let id = UUID()
    let nombre: String
    let color: Color

    static let todos: [ColorOpcion] = [
        ColorOpcion(nombre: "Amarillo", color: Color(red: 0.95, green: 0.75, blue: 0.25)),
        ColorOpcion(nombre: "Morado",   color: Color(red: 0.55, green: 0.35, blue: 0.95)),
        ColorOpcion(nombre: "Rojo",     color: Color(red: 0.95, green: 0.35, blue: 0.35)),
        ColorOpcion(nombre: "Verde",    color: Color(red: 0.25, green: 0.85, blue: 0.75)),
        ColorOpcion(nombre: "Azul",     color: Color(red: 0.25, green: 0.50, blue: 0.95)),
        ColorOpcion(nombre: "Naranja",  color: Color(red: 0.95, green: 0.55, blue: 0.20)),
        ColorOpcion(nombre: "Rosa",     color: Color(red: 0.95, green: 0.40, blue: 0.70)),
        ColorOpcion(nombre: "Cyan",     color: Color(red: 0.20, green: 0.80, blue: 0.95)),
        ColorOpcion(nombre: "Lima",     color: Color(red: 0.60, green: 0.90, blue: 0.20)),
        ColorOpcion(nombre: "Coral",    color: Color(red: 0.95, green: 0.55, blue: 0.45)),
        ColorOpcion(nombre: "Índigo",   color: Color(red: 0.35, green: 0.25, blue: 0.75)),
        ColorOpcion(nombre: "Menta",    color: Color(red: 0.40, green: 0.90, blue: 0.65)),
    ]

    static func == (lhs: ColorOpcion, rhs: ColorOpcion) -> Bool { lhs.id == rhs.id }
}

// MARK: - Navigation Routes

enum AppRuta: Hashable {
    case crearAlarma
}
