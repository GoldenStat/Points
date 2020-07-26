//
//  PlayerWon.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

enum WinState { case won, lost, theyWon }

struct PlayerWonRound: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    
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
    @State var dim = true
    @State var offset : CGFloat = 50
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.background)
            .overlay(
                VStack {
                    Spacer()
                    
                    Text(emoji)
                        .font(.system(size: 144))
                        .scaleEffect(animatedSize)
                        .fixedSize()
                        .rotationEffect(animatedRotation)
                        .offset(x: 0, y: offset)
                        .animation(animation)
                    Text(message)
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Button("Jugamos Otra") {
                        settings.newRound()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                }
                .opacity(dim ? 0.0 : 1.0)
            )
            .onAppear() {
                animatedSize = 1
                animatedRotation = .degrees(720)
                dim  = false
                offset = -50
            }
    }
    
    var animation: Animation { state == .won ? animationWon : animationLost }
    let animationWon = Animation.interpolatingSpring(mass: 1, stiffness: 0.8, damping: 0.8, initialVelocity: 2)
    let animationLost = Animation.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0.8)
    
}

struct PlayerWonGame: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode
    @State var isShowing = true
    var player : Player { settings.playerWonGame ?? Player(name: "Wrong Player")}
    
    var state: WinState {
        switch player.name {
        case "Yo", "Nosotros": return .won
        case "Tu", "Ustedes": return .lost
        case "Ellos", "El", "Ella": return .theyWon
        default: return .theyWon
        }
    }
    
    var message: String {
        switch state {
        case .won: return "Ganaste toda las manos, chamo!!"
        case .lost: return "Ay, Perdimos!!"
        case .theyWon: return "Nos ganaron!"
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.background)
            .overlay(
                VStack {
                    Text(message)
                        .font(.largeTitle)
                    Button("Otro juego!") {
                        settings.newGame()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
    }
}

//struct PlayerWon_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            PlayerWonRound()
//            PlayerWonGame()
//        }
//    }
//}
