//
//  SelectionScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct SelectionScoreView: View {
    @EnvironmentObject var settings: GameSettings
    
    var score: Score = Score()
    var selection: [Int] = [-10,10]
    
    var body: some View {
        ButtonScoreView(score: score)
            .contextMenu() {
                ForEach(selection, id: \.self) { value in
                    Button(value.description) {
                        settings.scoreStep = value
                    }
                }
            }
    }
}

struct SelectionScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionScoreView()
            .environmentObject(GameSettings())
    }
}
