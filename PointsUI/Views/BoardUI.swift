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
    
    var objects : [Player] { settings.players.items }
    let minAmount: CGFloat = 300
    let maxAmount: CGFloat = 400
    
    
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
        if UIDevice.current.orientation.isLandscape {
            // in landscape we always put all players in a row -- there is always enough space
            HStack(alignment: .center) {
                playerViews()
            }
        } else {
            // not landscape
            if objects.count == 2 {
                VStack(alignment: .center) {
                    playerViews()
                }
            } else {
                LazyVGrid(columns: twoColumns,
                          alignment: .center) {
                    playerViews()
                }
            }
        }
    }
    
    func playerViews() -> some View {
        ForEach(objects) { player in
            PlayerView(player: player)
        }
    }
}


struct BoardUI_Previews: PreviewProvider {
    static var previews: some View {
        BoardUI()
            .environmentObject(GameSettings())
    }
}
