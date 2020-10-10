//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditButton : View {
    @State var toggle: Bool = false
    var body: some View {
        Button() {
            toggle = true
        } label: {
            Image(systemName: "gear")
        }
        .sheet(isPresented: $toggle) {
            EditView()
        }
    }
}

struct EditView : View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var isPresented

    var pointsPerGame : PointsSelection { settings.rule.maxPoints }
    var playersCount: PlayerCount { settings.rule.players }
    var title: String { settings.rule.name }
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    VStack {
                        
                        Text(title)
                            .fontWeight(.bold)
                        RulesPicker()
                        PointsPicker()
                        JuegosPicker()
                        JugadoresPicker()
                        
                        EditPlayerNames(players: $settings.players)
                    }
                }
            }
            
            Button("Save") {
                isPresented.wrappedValue.dismiss()
            }
        }
        .onDisappear(perform: {
            settings.updateSettings()
            settings.needsUpdate = true
        })
    }
}

struct PreviewView : View {
    @EnvironmentObject var settings: GameSettings
    @State var presentView : Bool = false
    
    var body: some View {
        VStack {
            Text(settings.rule.name)
                .font(.title)
            
            Text("Players: \(settings.playerNames.count)")
            Text("MaxPoints: \(settings.maxPoints)")
            Text("MaxGames: \(settings.maxGames)")
            Text("Players: \(settings.chosenNumberOfPlayers)")
                
            EditButton()
                .padding()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
            .environmentObject(GameSettings())
    }
}
