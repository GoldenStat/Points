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
    
    @Binding var selectedRule: Rule
//    @Binding var selectedPoints: Int
//    @Binding var selectedRounds: Int
////    @State var selectedAnimationSpeed:
//    @State var selectedNumberOfPlayers: Int

    init(currentRule: Binding<Rule>) {
        _selectedRule = currentRule
//        self.selectedPoints = settings.maxPoints
//        self.selectedRounds = settings.maxGames
//        self.selectedNumberOfPlayers = settings.chosenNumberOfPlayers
    }
    
    var body: some View {
        VStack {
            Text(settings.rule.name)
                .fontWeight(.bold)
            
            JuegosPreview(selection: $selectedRule)
//            PointsPicker(selection: $selectedPoints)
//            JuegosPicker(selection: $selectedRounds)
//            AnimacionPicker(selection: $selectedAnimationSpeed)
//            JugadoresPicker(selection: $selectedNumberOfPlayers)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(currentRule: .constant(.trucoArgentino))
            .padding()
            .environmentObject(GameSettings())
    }
}
