//
//  HistoryControlView.swift
//  PointsUI
//
//  Created by Alexander Völz on 20.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// this is not used anymore and obsolete. History is manages in ScoreHistoryView, now
fileprivate struct HistoryControlView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var showHistory : Bool
    
    var body: some View {
        
        HStack {
            Button(action:{ settings.undoHistory() }) {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            Button(action:{
                showHistory = true
            }) {
                Text("Show History")
            }
            
            Spacer()
            
            Button(action:{ settings.redoHistory() }) {
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
