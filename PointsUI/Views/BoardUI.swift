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
    @ObservedObject var players: Players
    var objects : Int { players.items.count }
    
    // MARK: replace magic numbers!
    var columns = Array<GridItem>.init(repeating: GridItem(.fixed(160)), count: 2)
    var rows = Array<GridItem>.init(repeating: GridItem(.fixed(4*160), alignment: .center), count: 1)

    var body: some View {
        lazyGridView()
    }
    
    var numberOfPlayers : Int { GlobalSettings.playerNames.count }
//    var columns : Int {Int(numberOfPlayers <= 2 ? 1 : 2) }
//    var rows : Int { Int(numberOfPlayers / columns) }

    @available(iOS 14.0, *)
    func lazyGridView() -> some View {
        LazyHGrid(rows: rows) {
            LazyVGrid(columns: columns) {
                ForEach(players.items) { player in
                    PlayerView(player: player)
                        .frame(width: 160, height: 280)
                }
            }
        }
    }
    
//    func gridView() -> some View {
//        return VStack {
//            ForEach(0 ..< rows) { row in
//                HStack {
//                    ForEach(0 ..< columns) { column in
//                        PlayerView(player: players.items[ row * columns + column])
//                    }
//                }
//            }
//        }
//    }
//
//    func flowView() -> some View {
//        FlowStack(columns: objects <= 2 ? 1 : 2,
//                  numItems: objects,
//                  alignment: .center) { index, colWidth in
//            PlayerView(player: players.items[index])
//        }
//    }
}



struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(players: GameSettings().players)
    }
}

