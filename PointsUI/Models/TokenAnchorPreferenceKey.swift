//
//  TokenAnchorPreferenceKey.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TokenAnchor {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
}

struct TokenAnchorPreferenceKey: PreferenceKey {
    typealias Value = [TokenAnchor]
    static var defaultValue: [TokenAnchor] = []
    static func reduce(value: inout [TokenAnchor], nextValue: () -> [TokenAnchor]) {
        value.append(contentsOf: nextValue())
    }
}

