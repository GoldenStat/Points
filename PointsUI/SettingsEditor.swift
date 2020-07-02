//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditView : View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // MARK: add more later
        VStack {
            GlobalSettingsView()
            PickNumberOfPlayers()
        }
        .padding(.vertical)
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
        }
        .onAppear() {
            maxGames = String(GlobalSettings.maxGames)
            maxPoints = String(GlobalSettings.scorePerGame)
            updateTime = Double(GlobalSettings.updateTime)
        }
        
    }
}


/// only updates global settings
struct FieldWithBackground<Content: View>: View {
    
    var text: String
    var backgroundIntensity: Double
    var content: Content
    
    init(_ text: String, backgroundIntensity: Double = 1.0, @ViewBuilder content: () -> Content) {
        self.text = text
        self.content = content()
        self.backgroundIntensity = backgroundIntensity
    }
    
    var body: some View {
        HStack {
            Text(text)
            Spacer(minLength: minSpacing)
            content
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    Color(.sRGB, white: grayScale, opacity: backgroundIntensity)
                )
        )
    }
    
    private let minSpacing: CGFloat = 20
    private let cornerRadius: CGFloat = 5
    private let grayScale: Double = 0.8
    
}

/// only updates global settings
struct PickNumberOfPlayers: View {
    @EnvironmentObject var settings: GameSettings
    @State private var chosenPlayers: Int
    
    init() {
        _chosenPlayers = State(wrappedValue: GlobalSettings.chosenNumberOfPlayers)
    }
    
    var body: some View {
        
        Picker("Jugadores", selection: $chosenPlayers) {
            ForEach(GameSettings.availablePlayers, id: \.self) { (count: Int) in
                Text("\(count)")
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onDisappear() {
            if chosenPlayers != settings.chosenNumberOfPlayers {
                settings.chosenNumberOfPlayers = chosenPlayers
            }
        }
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
