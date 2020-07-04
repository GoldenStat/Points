//
//  GameSettings.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

class GameSettings: ObservableObject {
    
    @Published var players = Players(names: GlobalSettings.playerNames)
    @Published var history = History()
    @Published var maxGames: Int = GlobalSettings.maxGames
    @Published var maxPoints: Int = GlobalSettings.scorePerGame
    @Published var updateTimeInterval: TimeInterval = GlobalSettings.updateTime
    @Published var playerWon: Player?

    @Published var chosenNumberOfPlayers : Int = GlobalSettings.chosenNumberOfPlayers {
        didSet {
            updateSettings()
        }
    }
    
    init () {
        chosenNumberOfPlayers = 3
        GlobalSettings.scorePerGame = 24
        GlobalSettings.maxGames = 3
    }

    var maxGamesString: String {
        get { String(maxGames) }
        set { maxGames = Int(newValue) ?? GlobalSettings.maxGames
            updateSettings()
        }
    }
    
    var maxPointsString: String {
        get { String(maxPoints) }
        set { maxPoints = Int(newValue) ?? GlobalSettings.scorePerGame
            updateSettings()
        }
    }
    
    var updateTimeIntervalString: String {
        get { String(updateTime) }
        set { updateTime = TimeInterval(newValue) ?? GlobalSettings.updateTime
            updateSettings()
        }
    }
    
    // MARK: constant data for this class
    static let name = "Truco Points"
    let availablePlayers = [ 2, 3, 4, 6 ]
            
    func updateSettings() {
        // if number of players changed, restart the game
        if (chosenNumberOfPlayers != GlobalSettings.chosenNumberOfPlayers) {
            players = Players(names: names(for: chosenNumberOfPlayers))
            history = History()
        }
        GlobalSettings.playerNames = players.names
        GlobalSettings.chosenNumberOfPlayers = chosenNumberOfPlayers
        GlobalSettings.scorePerGame = maxPoints
        GlobalSettings.maxGames = maxGames
        GlobalSettings.updateTime = updateTime
    }
        
    // MARK: control player data
    var numberOfPlayers: Int { players.items.count }

    func names(for numberOfPlayers: Int) -> [String] {
        guard availablePlayers.contains(numberOfPlayers) else { return [] }
        
        let singlePlayers = [ "Yo", "Tu", "El" ]
        let pairedPlayers = [ "Nosotros", "Ustedes", "Ellos" ]
        
        switch numberOfPlayers {
        case 2:
            return [ singlePlayers[0], singlePlayers[1] ]
        case 3:
            return [ singlePlayers[0], singlePlayers[1], singlePlayers[2] ]
        case 4:
            return [ pairedPlayers[0], pairedPlayers[1] ]
        case 6:
            return [ pairedPlayers[0], pairedPlayers[1], pairedPlayers[2] ]
        default:
            return []
        }
    }

    var playerNames: [ String ] { players.names }
    
    func player(named name: String) -> Player? {
        players.items.filter {$0.name == name}.first
    }
    
    func changePlayerName(from name: String, to newName: String) {
        if let player = player(named: name) {
            player.name = newName
        }
    }

    func addPlayer(named name: String) {
        GlobalSettings.playerNames.append(name)
        players = Players(names: GlobalSettings.playerNames)
        history = History()
    }
    
    func removeLastPlayer() {
        guard !GlobalSettings.playerNames.isEmpty else { return }
        _ = GlobalSettings.playerNames.removeLast()
        players = Players(names: GlobalSettings.playerNames)
        history = History()
    }
    
    func removePlayer(named name: String) {
        let newPlayerNames = GlobalSettings.playerNames.filter {$0 == name}
        GlobalSettings.playerNames = newPlayerNames
        players = Players(names: GlobalSettings.playerNames)
        history = History()
    }
    
    // a hack to send an event to all observers when the history functions are used
    @Published var needsUpdate = false
    var canUndo: Bool { history.canUndo }
    var canRedo: Bool { history.canRedo }

    // MARK: History functions
    func undo() {
        needsUpdate.toggle()
        history.undo()
        updatePlayersWithCurrentState()
    }
    
    func redo() {
        needsUpdate.toggle()
        history.redo()
        updatePlayersWithCurrentState()
    }

    // MARK: Timer
    private var timer : Timer?
    private var updateTime: TimeInterval = GlobalSettings.updateTime
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: updateTime,
                                     target: self,
                                     selector: #selector(update),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // when the timer fires, players need to be updated, and history saved...
    @objc private func update() {
        // send the history a signal that it should be saved
        players.saveScore() // update all scores' buffer
        history.save(state: GameState(players: players.data))
        timer?.invalidate()
        
        playerWon = players.items.filter({ $0.score.value >= GlobalSettings.scorePerGame }).first
    }
    
    /// updates the players with score from current state
    func updatePlayersWithCurrentState() {
        if history.currentPlayers.isEmpty {
            // set all to zero
            players = Players(names: GlobalSettings.playerNames)
        } else {
            players.data = history.currentPlayers
        }
    }

}

