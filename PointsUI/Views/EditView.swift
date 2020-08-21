//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
            PointsPicker()
            JuegosPicker()
            AnimacionPicker()
            JugadoresPicker()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(white: 1.0, opacity: 0.5))
        )
        // pickers stop working when this is active...
//        .shadow(color: .accentColor, radius: 5, x: 5, y: 5)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .environmentObject(GameSettings())
    }
}
