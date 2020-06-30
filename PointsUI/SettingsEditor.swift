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
    @State var updateTime: Double = 0.0
    
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
                        HStack {
                            Text("Update Time:")
                            Spacer()
                            Slider(value: $updateTime, in: 0.5 ... 5.0, step: 0.1)
                            Text("\(updateTime, specifier: "%.1f")")
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
                GlobalSettings.updateTime = TimeInterval(updateTime)
                settings.updateSettings()
            }
            .onAppear() {
                names = GlobalSettings.playerNames
                maxGames = String(GlobalSettings.maxGames)
                maxPoints = String(GlobalSettings.scorePerGame)
                updateTime = Double(GlobalSettings.updateTime)
            }
            .environment(\.editMode, $editMode)
        }
    }
}

struct EditView : View {
    
    var body: some View {
        // MARK: add more later
        VStack {
            GlobalSettingsView()
            PickNumberOfPlayers()
        }
        .padding()
    }
}

struct HistoryButtons: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        HStack {
            Button() { settings.undo() }
                label: {
                    Image(systemName: "arrow.uturn.left")
                        .padding()
                }
            Button() { settings.redo() }
                label: {
                    Image(systemName: "arrow.uturn.right")
                        .padding()
                }
        }
    }
}

struct GlobalSettingsView: View {
    @EnvironmentObject var settings: GameSettings
    
    // MARK: things to edit
    @State var names : [ String ] = []
    @State var maxGames: String = ""
    @State var maxPoints: String = ""
    @State var updateTime: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                FieldWithBackground("Puntos:") {
                    TextField("Max Puntos", text: $maxPoints)
                }
                
                FieldWithBackground("Manos:") {
                    TextField("Max Manos", text: $maxGames)
                }
            }
            
            FieldWithBackground("Animacion:") {
                Slider(value: $updateTime, in: 0.5 ... 5.0, step: 0.1)
                Text("\(updateTime, specifier: "%.1f")")
            }
        }
        .keyboardType(.numberPad)
        .onDisappear() {
            GlobalSettings.maxGames = Int(maxGames) ?? GlobalSettings.maxGames
            GlobalSettings.scorePerGame = Int(maxPoints) ?? GlobalSettings.scorePerGame
            GlobalSettings.updateTime = TimeInterval(updateTime)
            if settings.chosenNumberOfPlayers != GlobalSettings.chosenNumberOfPlayers {
                settings.updateSettings()
            }
        }
        .onAppear() {
            maxGames = String(GlobalSettings.maxGames)
            maxPoints = String(GlobalSettings.scorePerGame)
            updateTime = Double(GlobalSettings.updateTime)
        }
        
    }
}

struct FieldWithBackground<Content: View>: View {
    
    var text: String
    var content: Content
    
    init(_ text: String, @ViewBuilder content: () -> Content) {
        self.text = text
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            content
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(
                    Color(.sRGB, white: 0.8, opacity: 0.2)
                )
        )
    }
    
}

struct PickNumberOfPlayers: View {
    @EnvironmentObject var settings: GameSettings
    @State private var chosenPlayers: Int
    var allOptions = GameSettings.availablePlayers
    
    init() {
        _chosenPlayers = State(wrappedValue: GlobalSettings.chosenNumberOfPlayers)
        print("Init: \(chosenPlayers)")
    }
    
    var body: some View {
        
        Picker("Jugadores", selection: $chosenPlayers) {
            ForEach(allOptions, id: \.self) { (count: Int) in
                Text("\(count)")
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onDisappear() {
            if chosenPlayers != GlobalSettings.chosenNumberOfPlayers {
                GlobalSettings.chosenNumberOfPlayers = chosenPlayers
                settings.chosenNumberOfPlayers = chosenPlayers
            }
        }
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditor()
    }
}
