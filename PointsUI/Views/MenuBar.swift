//
//  MenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MenuBar: View {
    @EnvironmentObject var settings: GameSettings
    
    @Binding // this is a binding so the calling view can blur...
    var presentEditView: Bool
    {
        didSet {
            if !presentEditView { settings.updateSettings() }
        }
    }
    
    // MARK: -- make this less confusing:
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    // History Buttons
                    HStack {
                        Button() { settings.undo() }
                            label: {
                                Image(systemName: "arrow.uturn.left")
                                    .padding()
                            }
                            .disabled(!settings.canUndo)
                        Button() { settings.redo() }
                            label: {
                                Image(systemName: "arrow.uturn.right")
                                    .padding()
                            }
                            .disabled(!settings.canRedo)
                    }
                    .emphasizeShape()
//                    .framedClip(borderColor: .clear, cornerRadius: 25.0, lineWidth: 1.0)
//                    .emphasizeCircle(maxHeight: 60)

                    Spacer()
                    
                    // Info Button
                    Button() {
                        showInfo.toggle()
                    } label: {
                        Image(systemName:
                                "info")
                            .padding()
                    }
                    .emphasizeShape()
//                    .framedClip(borderColor: .white, cornerRadius: 25.0, lineWidth: 1.0)
//                    .emphasizeCircle(maxHeight: 60)
                }
                .padding()
                
                // Drag Down
                Button() {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        presentEditView.toggle()
                    }
                    if !presentEditView {
                        settings.updateSettings()
                    }
                } label: {
                    presentEditView ? Image(systemName: "arrow.up") : Image(systemName: "arrow.down")
                }
                .foregroundColor(.gray)
                .padding()
                .framedClip(borderColor: .clear, cornerRadius: 25.0, lineWidth: 1.0)
                .emphasizeCircle(maxHeight: 60)

            }
            
            EditView()
                .background(Color.darkNoon)
                .offset(x: 0, y: editViewOffset)
                .opacity(presentEditView ? 1.0 : 0.0)
                .zIndex(-1) // let it scroll down from 'behind' the menu bar
            
            Spacer()
        }
        // now, create an 'invisible' background that handles doubletaps
        .background(presentEditView ? backgroundAlmostInvisible : backgroundNotRespondigToClicks)
        .onTapGesture(count: 2) {
            presentEditView = false
            settings.updateSettings()
        }
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    // MARK: present Info
    @State var showInfo: Bool = false
    
    // MARK: handle EditView appearance
    var editViewOffset: CGFloat { presentEditView ? endOffset : startOffset }
    
    let startOffset: CGFloat = -200 // height + safe area
    let endOffset: CGFloat = -10 // safe area?
    let backgroundAlmostInvisible = Color.white.opacity(0.01)
    let backgroundNotRespondigToClicks: Color = Color.clear
}
