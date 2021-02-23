//
//  EditPlayerNames.swift
//  PointsUI
//
//  Created by Alexander Völz on 10.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditableTextField: View {
    @Binding var binding: String
    let placeholder: String?
    var index: Int?
    
    var body: some View {
        HStack {
            
            Image(systemName: "person").foregroundColor(.gray)
            
            if let index = index {
                Text("\(index)")
                    .scaleEffect(0.6)
                    .padding(.horizontal)
            }
            
            if let placeholder = placeholder {
                TextField(placeholder, text: $binding)
                    .disableAutocorrection(true)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            } else {
                // hack to have the whole width detecting the touch
                Rectangle().fill(Color.white.opacity(0.001))
                    .overlay(
                        Text(binding),
                        alignment: .leading
                    )
            }
        }
        .padding(5)
    }
}

struct EditPlayerNames: View {
    @EnvironmentObject var settings: GameSettings
    
    var players: Players { settings.players }
    
    @State private var selectedPlayer: Player?

    // if we a player is selected, we need a placeholder
    func placeholder(for player: Player) -> String? {
        selectedPlayer == player ? "Player Name" : nil
    }
    
    var selectionText: String {
        if let name = selectedPlayer?.name {
            return name
        } else {
            return "No selection"
        }
    }
    
    var body: some View {
        List(players.items) { player in
            EditableTextField(binding: binding(for: player), placeholder: placeholder(for: player))
                .onTapGesture() {
                    selectedPlayer = player
                }
        }
    }

    // using a function found in an article on Stackoverflow:
    // TODO: find a better way to do this... https://stackoverflow.com/questions/58997248/how-to-edit-an-item-in-a-list-using-navigationlink
    // by Asperi: https://stackoverflow.com/users/12299030/asperi
    func binding(for player: Player) -> Binding<String> {
        $settings.players.items[players.items.firstIndex(where: { $0.id == player.id } )!].name
    }
}

struct TestEditing: View {
    @State private var settings = GameSettings()
        
    private var players : Players { settings.players }
    
    var minPlayers : Int { settings.rule.players.minValue }
    var maxPlayers : Int { settings.rule.players.maxValue }
    
    var error: String {
        guard maxPlayers != minPlayers else { return "" }
        switch players.count {
        case minPlayers:
            return "Reached Player Minimum"
        case maxPlayers:
            return "Reached Player Maximum"
        default:
            return ""
        }
    }
    
    var errorOpacity: Double { error == "" ? 0.0 : 1.0 }
    
    var canAddPlayer : Bool { settings.canAddPlayer }
    var canRemovePlayer: Bool { settings.canRemovePlayer }
    
    var body: some View {
        NavigationView() {
            VStack {
                EditPlayerNames()
                
                Text("Min: \(settings.rule.players.minValue) Max: \(settings.rule.players.maxValue)")
                
                Text(error)
                    .opacity(errorOpacity)
                    .foregroundColor(.red)
                    .padding()
            }
            .navigationTitle(settings.rule.description)
            .toolbar() {
                ToolbarItemGroup() {
                    HStack {
                        Button() {
                            withAnimation() {
                                if settings.rule.players.maxValue > players.count {
                                    settings.addRandomPlayer()
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 32))
                        }
                        .disabled(!settings.canAddPlayer)
                        
                        Button() {
                            withAnimation() {
                                if settings.rule.players.minValue < players.count {
                                    settings.removeLastPlayer()
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 32))
                        }
                        .disabled(!settings.canRemovePlayer)
                    }
                }
            }
            .environmentObject(settings)
        }
    }
}

struct EditPlayerNames_Previews: PreviewProvider {
    static var previews: some View {
        TestEditing()
            .environmentObject(GameSettings())
    }
}
