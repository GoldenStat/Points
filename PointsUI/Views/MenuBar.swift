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
    
    var body: some View {
        VStack {
            ZStack {
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

                    Spacer()
                    
                    Button() {
                        showInfo.toggle()
                    } label: {
                        Image(systemName:
                            "info.circle")
                            .padding()
                    }
                    
                }
                
                Button() {
                    presentEditView.toggle()
                    if !presentEditView {
                        settings.updateSettings()
                    }
                } label: {
                    presentEditView ? Image(systemName: "chevron.compact.up") : Image(systemName: "chevron.compact.down")
                }
                .font(.largeTitle)
                .foregroundColor(.gray)

                
            }
            .background(Color.darkNoon
                            .edgesIgnoringSafeArea(.top)
            )
            
            Divider()
            
            EditView()
                .background(Color.darkNoon)
                .offset(x: 0, y: editViewOffset)
                .animation(.default)
                .opacity(presentEditView ? 1.0 : 0.0)
                .zIndex(-1) // let it scroll down from 'behind' the menu bar
            
            Spacer()
        }
        // now, create an 'invisible' background that handles doubletaps
        .background(presentEditView ? backgroundAlmostInvisible : backgroundNotRespondigToClicks)
        .onTapGesture(count: 2) {
            presentEditView = false
        }
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }

    // MARK: present Info
    @State var showInfo: Bool = false
    
    // MARK: handle EditView appearance
    @State var presentEditView: Bool = false
    var editViewOffset: CGFloat { presentEditView ? endOffset : startOffset }
    
    let startOffset: CGFloat = -200 // height + safe area
    let endOffset: CGFloat = -10 // safe area?
    let backgroundAlmostInvisible = Color.white.opacity(0.01)
    let backgroundNotRespondigToClicks: Color = Color.clear
}
