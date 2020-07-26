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
            NumbersOfPlayersPicker()
        }
        .padding(.vertical)
    }
}

struct GlobalSettingsView: View {
    @EnvironmentObject var settings: GameSettings
        
    var body: some View {
        VStack {
            HStack {
                FieldWithBackground("Puntos:") {
                    TextField("Max Puntos", text: $settings.maxPointsString)
                        .padding(.vertical, 5)
                }
                
                FieldWithBackground("Manos:") {
                    TextField("Max Manos", text: $settings.maxGamesString)
                        .padding(.vertical, 5)
                }
            }
            
            FieldWithBackground("Animacion:") {
                Slider(value: $settings.updateTimeInterval, in: 0.5 ... 5.0, step: 0.5)
                Text("\(settings.updateTimeInterval, specifier: "%.1f")")
            }
        }
        .keyboardType(.numberPad)
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
                .padding(.horizontal)

        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    Color.inactive
                )
        )
        .foregroundColor(Color.text)
    }
    
    private let minSpacing: CGFloat = 20
    private let cornerRadius: CGFloat = 8
    
}

/// only updates global settings
struct NumbersOfPlayersPicker: View {
    @EnvironmentObject var settings: GameSettings

    var body: some View {
        
        Picker("Jugadores", selection: $settings.chosenNumberOfPlayers) {
            ForEach(settings.availablePlayers, id: \.self) { count in
                Text("\(count)")
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color.inactive)
        .foregroundColor(Color.text)
    }
}
