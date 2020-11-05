//
//  EditPlayerNames.swift
//  PointsUI
//
//  Created by Alexander Völz on 10.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditableTextField: View {
    @Binding var name: String
    var index: Int
    @State var selected: Bool = false

//    var field: some View {
//        if selected {
//            return AnyView { TextField("Player Name", text: $name) }
//        } else {
//            return AnyView { Text(name) }
//        }
//    }
    
    var body: some View {
        HStack {
            Image(systemName: "person").foregroundColor(.gray)
            Text("\(index)")
                .scaleEffect(0.6)
                .padding(.horizontal)
            TextField("Player Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}

struct EditPlayerNames: View {
    @EnvironmentObject var settings: GameSettings
    
    var players: Players { settings.players}
    
    @State private var editMode = EditMode.inactive
    @State var newName: String = "Player 1"
    
    var body: some View {
        NavigationView {
            List(players.items) { player in
                switch editMode {
                case EditMode.active:
                    TextField("Player Name", text: $newName)
                default:
                    Text(player.name)
                }
            }
            .navigationBarItems(leading: EditButton())
            .environment(\.editMode, $editMode)
        }
    }
}

struct EditPlayerNames_PreviewBuilder : View {
    @State var players : Players = Players(names: [ "Yo", "Tu", "El" ])
    
    var body: some View {
        VStack {
            EditPlayerNames()
                .environmentObject(GameSettings())
                .padding()
        }
    }
}

struct FieldPreview: View {
    @State var name : String = "Alex"
    
    var body: some View {
        VStack {
            EditableTextField(name: $name, index: 0)
            Text(name)
        }
    }
}

struct EditPlayerNames_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayerNames()
            .environmentObject(GameSettings())
//        EditPlayerNames_PreviewBuilder()
    }
}
