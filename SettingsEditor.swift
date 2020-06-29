//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

// MARK: -- TODO: create a view to change settings
struct SettingsEditor: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: GameSettings
    
    @State var editMode: EditMode = .inactive
    
    // MARK: things to edit
    @State var names : [ String ] = []
    @State var maxGames: String = ""
    @State var maxPoints: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Players")) {
                        ForEach(names, id: \.self) { name in
                            if let index = names.firstIndex(of: name) {
                                TextField("Name", text: $names[index])
                            }
                        }
                        .onDelete() { indexSet in
                            names.remove(atOffsets: indexSet)
                        }
                    }
                    
                    Section(header: Text("Other")) {
                        TextField("Max Points", text: $maxPoints)
                            .keyboardType(.numberPad)
                        TextField("Rounds", text: $maxGames)
                            .keyboardType(.numberPad)
                    }
                }
                
                Button() {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                        .padding()
                }
            }
            .navigationBarItems(trailing: EditButton())
            .onDisappear() {
                GlobalSettings.playerNames = names
                GlobalSettings.maxGames = Int(maxGames) ?? GlobalSettings.maxGames
                GlobalSettings.scorePerGame = Int(maxPoints) ?? GlobalSettings.scorePerGame
            }
            .onAppear() {
                names = GlobalSettings.playerNames
                maxGames = String(GlobalSettings.maxGames)
                maxPoints = String(GlobalSettings.scorePerGame)
            }
            .environment(\.editMode, $editMode)
        }
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditor()
    }
}
