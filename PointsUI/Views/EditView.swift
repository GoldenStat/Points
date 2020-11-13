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
    @Environment(\.presentationMode) var isPresented
    
    var pointsPerGame : PointsSelection { settings.rule.maxPoints }
    var playersCount: PlayerCount { settings.rule.players }
    var title: String { settings.rule.name }
    var body: some View {
        NavigationView {
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
            }
            .navigationTitle(Text(title))
            .toolbar() {
                Button("Dismiss") {
                    settings.updateSettings()
                    settings.needsUpdate = true
                    isPresented.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct PreviewEditView : View {
    @EnvironmentObject var settings: GameSettings
    @State private var presentView : Bool = false
    
    var body: some View {
        VStack {
            Text(settings.rule.name)
                .font(.title)
            
            Text("Players: \(settings.playerNames.count)")
            Text("MaxPoints: \(settings.maxPoints)")
            Text("MaxGames: \(settings.maxGames)")
            Text("Players: \(settings.chosenNumberOfPlayers)")
            
            Section(header: Text("Players")) {
            HStack {
                Text("Names:")
                ForEach(settings.players.items, id: \.self.id) { player in
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
        .sheet(isPresented: $presentView) {
            EditView()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewEditView()
            .environmentObject(GameSettings())
    }
}
