//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PointsPicker: View {
    @EnvironmentObject var settings: GameSettings

    var body: some View {
        Picker("Puntos", selection: $settings.maxPoints) {
            ForEach([24, 30], id: \.self) { value in
                Text(value.description)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

protocol StringExpressable {
    var description: String { get }
}

extension Int : StringExpressable {
    var description: String { "\(self)" }
}


struct PointsUIPickerBuilder<Value: StringExpressable>: View where Value: Hashable {
    var title: String
    var binding: Binding<Value>
    var orderedSet: Array<Value>
    
    var body: some View {
        Picker(title, selection: binding) {
            ForEach(orderedSet, id: \.self) {
                Text($0.description)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct AnimationSpeedPicker: View {
    @EnvironmentObject var settings: GameSettings

    var body: some View {
        Picker("Animacion", selection: $settings.updateSpeed) {
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
                HStack {
                    PointsPicker()
                    PointsUIPickerBuilder<Int>(title: "Juegos", binding: $settings.maxGames, orderedSet: [2,3,4,5])
                }
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
