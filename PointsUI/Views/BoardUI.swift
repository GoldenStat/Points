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
        
    // MARK: replace magic numbers!
//    var columns = Array<GridItem>.init(repeating: GridItem(.flexible(minimum: 80, maximum: 160)()), count: Int(settings.numberOfPlayers / 2))
//    var rows = Array<GridItem>.init(repeating: GridItem(.flexible(minimum: 320, maximum: 4*160)), count: 2)
//
    var body: some View {
//        return lazyGridView()
        return flowView()
    }
    
//    @available(iOS 14.0, *)
//    func lazyGridView() -> some View {
//        LazyHGrid(rows: rows) {
//            LazyVGrid(columns: columns) {
//                ForEach(players.items) { player in
//                    PlayerView(player: player)
//                }
//            }
//        }
//    }
        
    func flowView() -> some View {
        FlowStack(columns: columns,
                  numItems: numberOfPlayers,
                  alignment: .center) { index, colWidth in
            PlayerView(player: players.items[index])
        }
    }
    
    // MARK: local variables -- make columns depend on number of players and device orientation
    // MARK: also inspect new LazyGridView option
    private var numberOfPlayers : Int { GlobalSettings.playerNames.count }
    private var maxGames : Int { GlobalSettings.maxGames }
    private var columns : Int { Int(numberOfPlayers / 2) }

}
    
//@avaliable(iOS 13.0, iOS 13.8)
//struct BoardUI: View {
//    @EnvironmentObject var settings: GameSettings
//    @ObservedObject var players: Players
//        
//    var numberOfPlayers : Int { players.items.count }
//
//    // MARK: replace magic numbers!
//    var columns = Array<GridItem>.init(repeating: GridItem(.flexible()), count: 2)
//    var rows = Array<GridItem>.init(repeating: GridItem(.flexible()), count: 2)
//
//    
//    var body: some View {
//        return lazyGridView()
//    }
//    
//    @available(iOS 14.0, *)
//    func lazyGridView() -> some View {
//        LazyHGrid(rows: rows) {
//            LazyVGrid(columns: columns) {
//                ForEach(players.items) { player in
//                    PlayerView(player: player)
//                }
//            }
//        }
//    }
//        
////    func flowView() -> some View {
////        FlowStack(columns: columns,
////                  numItems: numberOfPlayers,
////                  alignment: .center) { index, colWidth in
////            PlayerView(player: players.items[index])
////        }
////    }
//    
//    // MARK: local variables -- make columns depend on number of players and device orientation
//    // MARK: also inspect new LazyGridView option
//    private var maxGames : Int { GlobalSettings.maxGames }
////    private let columns = 2
//
//}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(players: GameSettings().players)
    }
}

