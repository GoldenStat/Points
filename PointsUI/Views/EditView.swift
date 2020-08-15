//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

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
        HStack {
            Text(title)
            
            Picker(title, selection: binding) {
                ForEach(orderedSet, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct PointsPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<Int>(title: "Puntos", binding: $settings.maxPoints, orderedSet: [24, 30])
    }
}

struct JuegosPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<Int>(title: "Juegos", binding: $settings.maxGames, orderedSet: [2,3,4,5])
    }
}

struct AnimacionPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<UpdateTimes>(title: "Animación", binding: $settings.updateSpeed, orderedSet: UpdateTimes.allCases)
    }
}

struct JugadoresPicker: View {
    @EnvironmentObject var settings: GameSettings
    var bind: Binding<Int> { get { $settings.chosenNumberOfPlayers }
        set { settings.chosenNumberOfPlayers = newValue.wrappedValue }
    }
    @State var selectedNumber: Int = 2
    let orderedSet = [ 2, 3, 4, 6 ]
    let title = "Jugadores"
    
    var body: some View {
        HStack {
            Text(title)
            
            Picker(title, selection: binding) {
                ForEach(orderedSet, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct EditView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        ZStack {
            VStack {
                PointsPicker()
                JuegosPicker()
                AnimacionPicker()
                JugadoresPicker()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(white: 1.0, opacity: 0.5))
            )
            .shadow(color: .accentColor, radius: 5, x: 5, y: 5)

        }
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .environmentObject(GameSettings())
    }
}
