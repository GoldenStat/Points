//
//  PickNumberOfPlayers.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PickNumberOfPlayers: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        Picker("Jugadores", selection: $settings.chosenNumberOfPlayers) {
            ForEach(GameSettings.availablePlayers, id: \.self) { count in
                Text("\(count)")
            }
        }.pickerStyle(SegmentedPickerStyle())    }
}

struct PickNumberOfPlayers_Previews: PreviewProvider {
    static var previews: some View {
        PickNumberOfPlayers()
    }
}
