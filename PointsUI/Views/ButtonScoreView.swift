//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ButtonScoreView: View {
    
    var score: Score
    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 0.0 }
    
    var body: some View {
        ZStack {
            Text(score.value.description)
            BufferView(score: Score(score.value))
            //            .emphasize()
        }
    }
}

struct ButtonScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonScoreView(score: Score(20, buffer: 10))
    }
}
