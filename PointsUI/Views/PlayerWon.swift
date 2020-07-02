//
//  PlayerWon.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerWonRound: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    var player : Player
    
    var body: some View {
        VStack {
            Text("Ganaste una, \(player.name)! :)")
                .font(.title)
            
            Button("Otra") {
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
}

struct PlayerWonGame: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    var player : Player
    
    var body: some View {
        VStack {
            Text("Ganaste el Juego, \(player.name)! :)")
                    .font(.largeTitle)
            Button("Otra") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PlayerWon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        PlayerWonRound(player: Player(name: "Lili"))
        PlayerWonGame(player: Player(name: "Lili"))
        }
    }
}
