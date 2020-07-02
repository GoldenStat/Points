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
                        .padding(2)
                }
                
                FieldWithBackground("Manos:") {
                    TextField("Max Manos", text: $settings.maxGamesString)
                        .padding(5)
                }
            }
            
            FieldWithBackground("Animacion:") {
                Slider(value: $settings.updateTimeInterval, in: 0.5 ... 5.0, step: 0.1)
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
                    Color(.sRGB, white: grayScale, opacity: backgroundIntensity)
                )
        )
    }
    
    private let minSpacing: CGFloat = 20
    private let cornerRadius: CGFloat = 5
    private let grayScale: Double = 0.8
    
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
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
