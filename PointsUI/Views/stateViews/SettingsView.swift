//
//  SettingsView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


struct SettingsView : View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var isPresented
    
    var pointsPerGame : PointsSelection { settings.rule.maxPoints }
    var playersCount: PlayerCount { settings.rule.players }
    var title: String { settings.rule.name }
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                RulesPicker()
                PointsPicker()
                JuegosPicker()
                JugadoresPicker()
            }
            
            Section(header: Text("Players")) {
                EditPlayerNames()
            }
            
            Button("Done") {
                isPresented.wrappedValue.dismiss()
            }
        }
        .onDisappear(perform: settings.updateSettings)
        .navigationTitle(Text(title))
    }
}

struct PreviewSettingsView : View {
    @EnvironmentObject var settings: GameSettings
    @State private var presentView : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("Players: \(settings.playerNames.count)")
                    Text("MaxPoints: \(settings.maxPoints)")
                    Text("MaxGames: \(settings.maxGames)")
                    Text("Players: \(settings.chosenNumberOfPlayers)")

                    Section(header: Text("Players")) {
                        ForEach(settings.players.items) { player in
                            Text(player.name)
                        }
                    }
                }

                Button() {
                    presentView.toggle()
                } label: {
                    Image(systemName: "gear")
                }
                .padding()
            }
            .navigationTitle(settings.rule.name)
            .sheet(isPresented: $presentView) {
                SettingsView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewSettingsView()
            .environmentObject(GameSettings())
    }
}
