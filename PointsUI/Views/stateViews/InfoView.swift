//
//  InfoView.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a description on how the program works
struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let description = "Cuenta tus puntos"
    
    let paragraph = """
    Juegos tienen mañeras distintas de anotar los puntos de los jugadores. Hay juegos con grupos dinamicos y puntos individuales, por ejemplo. Algunos juegos anotan puntos en numeros, otros en rayas o tambien en fosforos. Por esto hay aparencias distintas por tipos de juegos distintos.

    En la configuracion (se llega apretando el nombre del juego actual en la vista principal) se pueden cambiar unos ajustes, como la cantidad de jugadores, o los nombres. Ojo que algunos cambios resetean el juego actual.

    Apretando la pantalla aparece el menu historial donde se pueden ver los puntos anotados del juego actual.

    Y al final, apretando las pantallas de los jugadores uno añade puntos al jugador por cada mano. si dejas de anotar por un cierto tiempo, la applicacion lo va a contar como una Mano

    He encontrado algunas apps para anotar puntos, pero me parecian muy limitadas todas, cada una sirviendo solo para un cierto juego (por ejemplo solo para Truco Argentino). Por eso escribí esta app.

    Por supuesto habra juegos que no aparecen aqui, si quizieran verlos integrados, mandenme una nota, preferibilmente con un link para las reglas de anotacion.

    Tengo planeado aggregar un editor en la configuracion para que uno pueda agregar nuevas reglas directamente desde el app. Pero solo si me da tiempo.
"""
    
    var body: some View {
        VStack {
            Text(PointsUIApp.name)
                .font(.largeTitle)
            Text(description)
                .font(.subheadline)
            Spacer()
            ScrollView {
                Text(paragraph)
                    .font(.system(size: 24))
                Button("Cerrar") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .buttonStyle(DefaultButtonStyle())
                .padding()
            }
        }
        .padding()
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
