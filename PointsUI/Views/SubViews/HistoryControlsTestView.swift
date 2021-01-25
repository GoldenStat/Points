//
//  HistoryControlView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryControlsTestView: View {
    
    var body: some View {
        ZStack {
            Color.blue
                .cornerRadius(4.0)
            
            Image(systemName: "arrow.left.circle")
        }
    }
}

struct HistoryControlsTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryControlsTestView()
    }
}
