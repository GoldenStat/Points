//
//  PlayerWon.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerWonRound: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    
    enum WinState { case won, lost, theyWon }
    
    var state: WinState {
        switch player.name {
        case "Yo", "Nosotros": return .won
        case "Tu", "Ustedes": return .lost
        case "Ellos", "El", "Ella": return .theyWon
        default: return .theyWon
        }
    }

    var player : Player { settings.playerWonRound ?? Player(name: "Wrong Player")}
    var message: String {
        switch state {
        case .won: return "Ganamos!!"
        case .lost: return "Perdimos!!"
        case .theyWon: return "Gano una!"
        }
    }
 
    let lostEmoji = ["😢","🤯","😒"]
    let wonEmoji = ["😆","🥳"]
    var emoji: String { (state == .won ? wonEmoji.randomElement() : lostEmoji.randomElement())! }
    @State var animatedSize: CGFloat = 0.0
    @State var animatedRotation: Angle = Angle(degrees: 0)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.darkNoon)
            .overlay(
                VStack {
                    Text(emoji)
                        .font(.system(size: animatedSize))
                        .rotationEffect(animatedRotation)
                    
                    Text(message)
                        .font(.title)
                    
                    Button("Otra") {
                        settings.newRound()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .onAppear() {
                withAnimation(.easeInOut(duration: 2)) {
                    animatedSize = 72
                    animatedRotation = .degrees(720)
                }
            }
    }
}

struct PlayerWonGame: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    var player : Player { settings.playerWonGame ?? Player(name: "Wrong Player")}
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.darkNoon)
            .overlay(
                VStack {
                    Text("Ganaste el Juego, \(player.name)! :)")
                        .font(.largeTitle)
                    Button("Otra") {
                        settings.newGame()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
    }
}

struct PlayerWon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayerWonRound()
            PlayerWonGame()
        }
    }
}
