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

struct FixedView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct PointsPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var pointsPerGame: Int? { settings.rule.maxPoints }
    
    var body: some View {
        if let points = pointsPerGame {
            FixedView(title: "MaxPoints", value: points.description)
        } else {
            PointsUIPickerBuilder<Int>(title: "Puntos", binding: $settings.maxPoints, orderedSet: [24, 30])
        }
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
    
    var body: some View {
        Form {
            Picker(title, selection: $selection) {
                ForEach(settings.possibleRules) { rule in
                    Text(rule.name).tag(rule)
                }
            }
            .onDisappear(perform: {
                settings.updateSettings()
            })
        }
    }
}

struct JugadoresSelection: View {
    @EnvironmentObject var settings: GameSettings

    var playersCount: PlayerCount { settings.rule.players }
    
    @ViewBuilder var body: some View {
        switch playersCount {
        case .fixed(let num):
            HStack {
                Text("Players")
                Spacer()
                Text(num.description)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.vertical)
        case .selection(let values):
            PointsUIPickerBuilder<Int>(title: "Jugadores", binding: $settings.chosenNumberOfPlayers, orderedSet: values)
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
        VStack {
            RulesPicker()
            PointsPicker()
        }
        .environmentObject(GameSettings())
    }
}
