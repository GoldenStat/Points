//
//  EditPlayerNames.swift
//  PointsUI
//
//  Created by Alexander Völz on 10.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditPlayerNames: View {
    @EnvironmentObject var settings : GameSettings
    @Binding var players: Players
        
    var body: some View {
        VStack {
            ForEach(0 ..< players.items.count, id: \.self) { id in
                EditableView(title: "Player \(id)", value: $players.items[id].name)
                    .keyboardType(.default)
            }
        }
    }
}

struct EditPlayerNames_PreviewBuilder : View {
    @State var players : Players = Players(names: [ "Yo", "Tu" ])
    
    var body: some View {
        EditPlayerNames(players: $players)
            .environmentObject(GameSettings())
    }
}
struct EditPlayerNames_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayerNames_PreviewBuilder()
    }
}
