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
    @Binding var settings: GameSettings
    @State private var games : Int = 0
    
    var history : History { settings.history }
    var players: Players { settings.players }
    
    // should we set this into the history class?
    @State var historyTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func resetTimer() {
        historyTimer.upstream.connect().cancel()
        historyTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    func triggerHistorySave() {
        // send the history a signal that it should be saved
        players.saveScore()
        history.save(state: GameState(players: players.data))
    }

    static let maxGames = GlobalSettings.maxGames
    static let columns = 2
    
    var numberOfPlayers : Int { players.items.count }
    
    var body: some View {
        FlowStack(columns: Self.columns, numItems: numberOfPlayers, alignment: .center) {
            index, colWidth in
            PlayerView(player: self.players.items[index])
        }
        .onTapGesture {
            resetTimer()
        }
        .onReceive(historyTimer) { input in
            triggerHistorySave()
        }

    }
}

struct BoardUI_Previews: PreviewProvider {
    
    static var defaultPlayers = Players(names: GlobalSettings.playerNames)

	static var previews: some View {
        BoardUI(settings: .constant(GameSettings()))
    }
}

