//
//  SettingsEditor.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

// MARK: -- TODO: create a view to change settings
struct SettingsEditor: View {
//    @Environment(\.colorScheme) var scheme
//    @Environment(\.layoutDirection) var layout
//    @Environment(\.undoManager) var undoManager
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var settings: GameSettings
    @State var isShowing: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditor()
    }
}
