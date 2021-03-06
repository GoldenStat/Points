//
//  Pickers.swift
//  PointsUI
//
//  Created by Alexander Völz on 20.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// can be expressed as a String
/// used to use Integers and Strings with Text($0) expressions alike
protocol StringExpressable {
    var description: String { get }
}

extension Int : StringExpressable {
    var description: String { "\(self)" }
}

// to select score steps
struct ScorePicker : View {
    @EnvironmentObject var settings: GameSettings

    var sections: [String:[Int]] = ["Empty":[]]
    
    var keys: [String] { sections.keys.sorted() }
    
    var body : some View {
        ScalingTextView("\(settings.scoreStep)", scale: 0.5)
            .frame(width: 60, height: 40)
            .contextMenu() {
                ForEach(keys, id: \.self) { sectionName in
                    Section(header: Text(sectionName)) {
                        ForEach(sections[sectionName]!, id: \.self) { value in
                            Button("\(value)") {
                                settings.scoreStep = value
                            }
                        }
                    }
                }
            }
    }
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

struct EditableView: View {
    var title: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title)            
            Spacer()
            TextField("\(value)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .padding(2)
                .background(Color.blue.opacity(0.3))
                .frame(maxWidth: 100)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PointsPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var pointsPerGame: PointsSelection { settings.rule.maxPoints }
    
    @ViewBuilder var body: some View {
        switch pointsPerGame {
        case .fixed(let value):
            FixedView(title: "MaxPoints", value: value.description)
        case .none:
            EmptyView()
        case .selection(let options):
            PointsUIPickerBuilder<Int>(title: "Puntos", binding: $settings.maxPoints, orderedSet: options)
        case .free(_):
            EditableView(title: "Max Points: ", value: $settings.maxPointsString)
                .keyboardType(.numberPad)
        }
    }
}

struct ScoreValuePicker: View {
    @Binding var selectedValue: Int
    @EnvironmentObject var settings: GameSettings
    var set: [Int]

    var body: some View {
        PointsUIPickerBuilder<Int>(title: "Values", binding: $selectedValue, orderedSet: set)
    }
}

struct JuegosPicker: View {
    @EnvironmentObject var settings: GameSettings
    var set: [Int] = [2,3,5]
    
    var body: some View {
        PointsUIPickerBuilder<Int>(title: "Juegos", binding: $settings.maxGames, orderedSet: set)
    }
}

struct AnimacionPicker: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        PointsUIPickerBuilder<UpdateTimes>(title: "Animación", binding: $settings.updateSpeed, orderedSet: UpdateTimes.allCases)
    }
}

/// must be put into a form
struct RulesPicker: View {
    @EnvironmentObject var settings: GameSettings
    
    var title: String = "Rule"
        
    var body: some View {
        Picker(title, selection: $settings.rule) {
                ForEach(settings.possibleRules) { rule in
                    Text(rule.name).tag(rule)
                }
            }
        }
    }


struct JugadoresPicker: View {
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
                .onDisappear() {
                    settings.objectWillChange.send()
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
        Form {
            RulesPicker()
            PointsPicker()
        }
        .environmentObject(GameSettings())
    }
}
