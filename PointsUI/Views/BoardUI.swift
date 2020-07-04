//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

/// the whole board, all player's points are seen here
struct BoardUI: View {
    @EnvironmentObject var settings: GameSettings
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var objects : [Player] { settings.players.items }
    let minAmount: CGFloat = 200
    
    /// working in iPhone 11 Pro Max in all configurations but .compact, 3 players
    var gridItems: [GridItem] {
        switch hSizeClass {
        case .compact:
            if objects.count == 2 {
                return [
                    GridItem(.adaptive(minimum: minAmount)),
                    GridItem(.adaptive(minimum: minAmount)),
                ]
            }
            // two columns with three objects
            return [
                GridItem(.adaptive(minimum: minAmount)),
                GridItem(.adaptive(minimum: minAmount)),
            ]
        case .regular:
//            return Array<GridItem>.init(repeating: GridItem(.flexible(minimum: minAmount)), count: objects.count)
            return [ GridItem(.adaptive(minimum: minAmount)) ]
        default:
            return [
                GridItem(.adaptive(minimum: minAmount))
            ]
        }
    }
    
    var body: some View {
        LazyHGrid(rows: gridItems,
                  alignment: .center) {
            ForEach(objects) { player in
                PlayerView(player: player)
            }
        }
    }
}

