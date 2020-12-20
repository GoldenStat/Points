//
//  HistoryControlView.swift
//  PointsUI
//
//  Created by Alexander Völz on 20.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryControlView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var showHistory : Bool
    
    var body: some View {
        
        HStack {
            Button(action:{ settings.undo() }) {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            Button(action:{
                showHistory = true
            }) {
                Text("Show History")
            }
            
            Spacer()
            
            Button(action:{ settings.redo() }) {
                Image(systemName: "arrow.right")
            }
        }
        .padding()
        .font(.largeTitle)
        .emphasizeShape()
        
    }
}

struct HistoryControlView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryControlView(showHistory: .constant(true))
            .environmentObject(GameSettings())
    }
}
