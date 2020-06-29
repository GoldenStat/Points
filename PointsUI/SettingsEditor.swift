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
                Form {
                    Section(header: Text("Players")) {
                        ForEach(names, id: \.self) { name in
                            if let index = names.firstIndex(of: name) {
                                TextField("Name", text: $names[index])
                            }
                        }
                        .onDelete() { indexSet in
                            names.remove(atOffsets: indexSet)
                        }
                        .animation(.easeInOut)
                    }
                    
                    Section(header: Text("Game Settings")) {
                        HStack {
                            Text("Points:")
                            Spacer()
                            TextField("Max Points", text: $maxPoints)
                                .keyboardType(.numberPad)
                        }
                        HStack {
                            Text("Rounds:")
                            Spacer()
                            TextField("Rounds", text: $maxGames)
                                .keyboardType(.numberPad)
                        }
                    }
                }
                
                Button() {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                        .padding()
                }
            }
            .navigationBarItems(
                leading: Button() { withAnimation(.easeInOut) { names.insert("New Player", at: 0) } }
                    label: { Image(systemName: "plus.circle").padding() },
                trailing: EditButton()
            )
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
