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
            Group {
            GlobalSettingsView()
            NumbersOfPlayersPicker()
            }
            .padding(.vertical)
            
            Spacer()
                .background(Color.background.opacity(0.01))
        }
    }
}

struct GlobalSettingsView: View {
    @EnvironmentObject var settings: GameSettings
        
    @State var lineWidth : CGFloat = GlobalSettings.pointsLineWidth {
        didSet {
            GlobalSettings.pointsLineWidth = $lineWidth.wrappedValue
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                FieldWithBackground("Puntos:") {
                    TextField("Max Puntos", text: $settings.maxPointsString)
                }
                
                FieldWithBackground("Manos:") {
                    TextField("Max Manos", text: $settings.maxGamesString)
                }
                
            }
            .padding(.vertical, 5)
            
            FieldWithBackground("Animación:") {
                Slider(value: $settings.updateTimeInterval, in: 0.5 ... 5.0, step: 0.5)
                Text("\(settings.updateTimeInterval, specifier: "%.1f")")
            }

            FieldWithBackground("Line Width:") {
                Slider(value: $lineWidth, in: 0.5 ... 5.0, step: 0.1)
                Text("\(lineWidth, specifier: "%.1f")")
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
    
    private let minSpacing: CGFloat = 10
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
        .foregroundColor(Color.text)
    }
}
