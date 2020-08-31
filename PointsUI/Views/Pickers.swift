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

struct RulesPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var title: String
    var binding: Binding<Rule>
    var orderedSet: Array<Rule>
    
    
    var body: some View {
        HStack {
            Text(title)
            
            Picker(title, selection: $settings.rule) {
                ForEach(0 ..< settings.possibleRules.count) { index in
                    Text(settings.possibleRules[index].description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct JugadoresPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<Int>(title: "Jugadores", binding: $settings.chosenNumberOfPlayers, orderedSet: [ 2, 3, 4, 6 ])
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

struct JuegosPreview : View {
    @EnvironmentObject var settings: GameSettings
    @State var selection: Rule
    
    var allRules: [ Rule ] { settings.possibleRules }
    
    var body: some View {
        Picker("Sample", selection: $selection) {
            ForEach(allRules) { rule in
                Text(rule.name)
            }
        }
    }
}

struct Pickers_Previews: PreviewProvider {
    
    @State static var selection: Rule = .trucoVenezolano
    
    static var previews: some View {
        JuegosPreview(selection: selection)
            .environmentObject(GameSettings())
    }
}
