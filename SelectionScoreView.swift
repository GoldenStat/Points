//
//  SelectionScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct SelectionScoreView: View {
    var score: Score = Score()
    var selection: [Int] = [-10,10]
    
    var body: some View {
        Text("Selection Score View")
    }
}

struct SelectionScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionScoreView()
    }
}
