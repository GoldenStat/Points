//
//  BottomMenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 18.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BottomMenuBar : View {
    
    @Binding var showEditView: Bool
    @Binding var showInfo: Bool
    var backAction: () -> Void
    var forwardAction: () -> Void
    
    var body : some View {
        HStack {
            historyButtons
            Spacer()
            Button() {
                withAnimation() {
                    showEditView.toggle()
                }
            } label: {
                Text(.init(systemName: "gear"))
            }
            
            Spacer()
            InfoButton(showInfo: $showInfo)
        }
        .padding()
//        .background(Color.background.cornerRadius(10.0))
        .padding(5.0)
        .background(Color.white.opacity(0.3).cornerRadius(10.0))
        
    }
    
    // MARK: - Buttons
    
    // MARK: info
    @ViewBuilder private var infoButton: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
        }
    }
    
    // MARK: history
    @ViewBuilder private var historyButtons: some View {
        HStack {
            Button(action: backAction) {
                undoSymbol
            }
            Button(action: forwardAction) {
                redoSymbol
            }
        }
    }
        
    var undoSymbol: some View { Image(systemName: "arrow.left") }
    var redoSymbol: some View { Image(systemName: "arrow.right") }
}


struct BottomMenuPreviewBar: View {
    @EnvironmentObject var settings: GameSettings
    @State private var showEditView = false
    @State private var showInfo = false
    
    var body: some View {
        BottomMenuBar(showEditView: $showEditView,
                      showInfo: $showInfo,
                      backAction: { settings.history.undo() },
                      forwardAction: { settings.history.redo() }
        )
    }
}

struct InfoButton: View {
    @Binding var showInfo: Bool
    var body: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
        }
    }
}

struct BottomMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenuPreviewBar()
            .environmentObject(GameSettings())
            .previewLayout(.fixed(width: 480, height: 100))
    }
}
