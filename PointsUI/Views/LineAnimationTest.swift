//
//  SwiftUIView.swift
//  PointsUI
//
//  Created by Alexander Völz on 04.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct LineAnimationTest: View {
    var body: some View {
        LineShape(from: 0, to: 3, animatingLastLine: true)
    }
}

struct LineAnimationTeest_Previews: PreviewProvider {
    static var previews: some View {
        LineAnimationTest()
        .padding()
    }
}
