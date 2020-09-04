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
        PointsUIPickerBuilder<Int>(title: "Juegos", binding: $settings.maxGames, orderedSet: [2,3,5])
    }
}

struct AnimacionPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<UpdateTimes>(title: "Animación", binding: $settings.updateSpeed, orderedSet: UpdateTimes.allCases)
    }
}

struct RulesPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var title: String = "Juegos"
    
    @State private var selection = Rule.trucoArgentino
    
//    enum Flavor: String, CaseIterable, Identifiable {
//        case chocolate
//        case vanilla
//        case strawberry
//
//        var id: String { self.rawValue }
//    }
    
//    @State private var selectedFlavor = Flavor.chocolate


    var body: some View {
//        Form {
//            Picker("Flavor", selection: $selectedFlavor) {
//                Text("Chocolate").tag(Flavor.chocolate)
//                Text("Vanilla").tag(Flavor.vanilla)
//                Text("Strawberry").tag(Flavor.strawberry)
//            }
//        }
//        Text("Selected flavor: \(selectedFlavor.rawValue)")
//        VStack {
//            Text(selection.name)
//            Form {
//
                Picker(title, selection: $selection) {
                    ForEach(settings.possibleRules) { rule in
                        Text(rule.name).tag(rule)
                    }
                }
//            }
//        }
    }
}

struct JugadoresSelection: View {
    @EnvironmentObject var settings: GameSettings

    var possiblePlayers: PlayerCount { settings.rule.players }
    
    var body: some View {
        switch possiblePlayers {
        case PlayerCount.fixed(let number):
            return AnyView { Text("Players: \(number.description)") }
        case PlayerCount.selection(let values):
            return AnyView {
                PointsUIPickerBuilder<Int>(title: "Jugadores", binding: $settings.chosenNumberOfPlayers, orderedSet: values)
            }
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
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct Pickers_Previews: PreviewProvider {
        
    static var previews: some View {
        RulesPicker()
            .environmentObject(GameSettings())
    }
}
