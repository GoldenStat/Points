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
//    var settings = GameSettings()
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
                        
                        EditPlayerNames()
                    }
                }
            }


            HStack {
                Button("Save") {
                    isPresented.wrappedValue.dismiss()
                    settings.updateSettings()
                    settings.needsUpdate = true
                }
                Button("Cancel") {
                    isPresented.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct PreviewView : View {
    @EnvironmentObject var settings: GameSettings
    @State private var presentView : Bool = true
    
    var body: some View {
        VStack {
            Text(settings.rule.name)
                .font(.title)
            
            Text("Players: \(settings.playerNames.count)")
            Text("MaxPoints: \(settings.maxPoints)")
            Text("MaxGames: \(settings.maxGames)")
            Text("Players: \(settings.chosenNumberOfPlayers)")
            
            HStack {
                Text("Names:")
                ForEach(settings.players.items, id: \.self.id) { player in
                    Text(player.name)
                }
            }
                
            Button() {
                presentView.toggle()
            } label: {
                Image(systemName: "gear")
            }
            .padding()
        }
        .sheet(isPresented: $presentView) {
            EditView()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
            .environmentObject(GameSettings())
    }
}
