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
    @Environment(\.verticalSizeClass) var vSizeClass
   
    var objects : [Player] { settings.players.items }
    let minAmount: CGFloat = 200
    
    
    var oneColumn : [GridItem]  { [                 GridItem(.adaptive(minimum: minAmount)),
    ] }
    var twoColumns : [GridItem]  { [
        GridItem(.adaptive(minimum: minAmount)),
        GridItem(.adaptive(minimum: minAmount)),
    ] }

    var vGridItems : [GridItem] {
        objects.count == 2 ? oneColumn : twoColumns
    }

    @ViewBuilder var body: some View {
        if hSizeClass == .compact {
            // if the 'screen' is 'vertical'
            if vSizeClass == .compact {
                // we are on a small phone, not sure what to do...
                if UIDevice.current.orientation.isLandscape {
                    HStack(alignment: .center) {
                        ForEach(objects) { player in
                            PlayerView(player: player)
                        }
                    }
                } else {
                    // small device, not landscape
                    LazyVGrid(columns: vGridItems,
                              alignment: .center) {
                        ForEach(objects) { player in
                            PlayerView(player: player)
                        }
                    }
                }
                
            } else {
            LazyVGrid(columns: vGridItems,
                      alignment: .center) {
                ForEach(objects) { player in
                    PlayerView(player: player)
                }
            }
            }
        }
        else {
            HStack(alignment: .center) {
                ForEach(objects) { player in
                    PlayerView(player: player)
                }
            }
        }
    }
}

