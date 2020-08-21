//
//  Pickers.swift
//  PointsUI
//
//  Created by Alexander Völz on 20.08.20.
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
    var binding: Binding<Int> { get { $settings.chosenNumberOfPlayers }
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


struct Preview : View {
    @State var selection: Bool = true
    
    var body: some View {
        VStack {
            Picker("Sample Picker", selection: $selection) {
                ForEach([ true, false ], id: \.self) {
                    Text($0.description)
                }
            }
            Picker("Sample Picker", selection: $selection) {
                ForEach([ true, false ], id: \.self) {
                    Text($0.description)
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        // only firstpicker works when this is active...
//        .shadow(color: .accentColor, radius: 5, x: 5, y: 5)
    }
}

struct Pickers_Previews: PreviewProvider {
    
    @State static var selection: Bool = false
    
    static var previews: some View {
        Preview()
    }
}
