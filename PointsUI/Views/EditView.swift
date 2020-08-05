//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct AnimationSpeedPicker: View {
    @EnvironmentObject var settings: GameSettings

    var body: some View {
        Picker("animation", selection: $settings.updateSpeed) {
            ForEach(UpdateTimes.allCases, id: \.self) { value in
                Text(value.description)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct EditView : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        ZStack {
            VStack {
                    GlobalSettingsView()
                    AnimationSpeedPicker()
                    NumbersOfPlayersPicker()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(white: 1.0, opacity: 0.5))
            )
        }
    }
    
}

struct GlobalSettingsView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        HStack {
            HStack {
                Text("Puntos:")
                Spacer()
                TextField("Max Puntos", text: $settings.maxPointsString)
            }
            
            HStack {
                Text("Manos:")
                Spacer()
                TextField("Max Manos", text: $settings.maxGamesString)
                
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(Color.inactive)
        .padding(.vertical, 5)
        .keyboardType(.numberPad)
    }
}


/// only updates global settings
struct NumbersOfPlayersPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
            Picker("Jugadores", selection: $settings.chosenNumberOfPlayers) {
                ForEach(settings.availablePlayers, id:
                            \.self) { number in
                    Text(number.description)
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .foregroundColor(Color.text)
    }
    

    func emojis(for count: Int) -> String {
        [String](repeating: "👨", count: count).joined()
    }
    
    func peopleSymbol(for players: Int) -> some View {
        switch players {
        case 2:
            return AnyView { HStack {
                Image(systemName: "person")
                Image(systemName: "person.fill")
                } }
        case 3:
            return AnyView { HStack {
                Image(systemName: "person")
                Image(systemName: "person.circle.fill")
                Image(systemName: "person.fill")
            } }
        case 4:
            return AnyView { HStack {
                Image(systemName: "person.2")
                Image(systemName: "person.2.fill")
            } }
        case 6:
            return AnyView { HStack {
                Image(systemName: "person.3")
                Image(systemName: "person.3.fill")
            } }
        default:
            return AnyView { HStack {
                Image(systemName: "person.3")
                Image(systemName: "person.3.fill")
            } }
        }
    }

}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
