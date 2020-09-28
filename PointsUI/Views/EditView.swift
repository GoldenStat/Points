//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct EditView : View {
    @EnvironmentObject var settings: GameSettings
    
    var pointsPerGame : PointsSelection { settings.rule.maxPoints }
    var playersCount: PlayerCount { settings.rule.players }
    var title: String { settings.rule.name }
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    VStack {
                        
                        Text(title)
                            .fontWeight(.bold)
                        RulesPicker()
                        PointsPicker()
                        JuegosPicker()
                        
                        JugadoresSelection()
                    }
                }
            }
            SaveButton()
        }
    }
}

struct SaveButton: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.presentationMode) var isPresented
    
    var body: some View {
        Button("Save") {
            isPresented.wrappedValue.dismiss()
            settings.updateSettings()
        }
    }
}

struct PreviewView : View {
    @EnvironmentObject var settings: GameSettings
    @State var presentView : Bool = false
    
    var body: some View {
        VStack {
            Text(settings.rule.name)
                .font(.title)
            
            Button("Edit") {
                presentView = true
            }
            .padding()
        }
        .sheet(isPresented: $presentView) {
            EditView()
                .environmentObject(settings)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
            .environmentObject(GameSettings())
    }
}
