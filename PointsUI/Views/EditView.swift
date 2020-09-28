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
    
    var pointsPerGame : Int? { settings.rule.maxPoints }

    var body: some View {
        VStack {
            
            Text(settings.rule.name)
                .fontWeight(.bold)
            
            RulesPicker()
            
            if let points = pointsPerGame {
                Text("MaxPoints: \(points)")
            }

            JuegosPicker()
            
            JugadoresSelection()
            
            SaveButton()
        }
    }
}

struct SaveButton: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var isPresented

    var body: some View {
        Button("Save") {
            settings.updateSettings()
            isPresented.wrappedValue.dismiss()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .padding()
            .environmentObject(GameSettings())
    }
}
