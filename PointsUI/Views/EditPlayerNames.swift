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
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            } else {
                Text(binding)
            }
        }
        .padding(5)
    }
}

struct EditPlayerNames: View {
    @EnvironmentObject var settings: GameSettings
    
    var players: Players { settings.players}
    
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
        List(settings.players.items) { player in
            EditableTextField(binding: binding(for: player), placeholder: placeholder(for: player))
                .onTapGesture() {
                    selectedPlayer = player
                }
        }
    }

    // using a function found in an article on Stackoverflow:
    // https://stackoverflow.com/questions/58997248/how-to-edit-an-item-in-a-list-using-navigationlink
    // by Asperi: https://stackoverflow.com/users/12299030/asperi
    func binding(for player: Player) -> Binding<String> {
        $settings.players.items[players.items.firstIndex(where: { $0.id == player.id } )!].name
    }
}

struct TestEditing: View {
    @State private var settings = GameSettings()
        
    private var players : Players { settings.players }
    
    var error: String = "reached player maximum"
    @State var errorOpacity: Double = 1.0
    
    var body: some View {
        NavigationView() {
            VStack {
                EditPlayerNames()
                
                Text(error)
                    .opacity(errorOpacity)
                    .foregroundColor(.red)
                    .padding()
            }
            .navigationTitle(settings.rule.description)
            .toolbar() {
                ToolbarItem() {
                    Button() {
                        withAnimation() {
                            if settings.canAddPlayers {
                                settings.addRandomPlayer()
                            } else {
                                errorOpacity = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 32))
                    }
                    .disabled(!settings.canAddPlayers)
                }
                ToolbarItem() {
                    Button() {
                        settings.removeLastPlayer()
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 32))
                    }
                    .disabled(!settings.canRemovePlayer)
                }
//                .padding()
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
