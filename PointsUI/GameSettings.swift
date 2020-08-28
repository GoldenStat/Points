//
//  GameSettings.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

class GameSettings: ObservableObject {
    
    @Published var players : Players
    @Published var history : History
    @Published var maxGames: Int = GlobalSettings.maxGames
    @Published var maxPoints: Int = GlobalSettings.scorePerGame
    @Published var playerWonRound: Player?
    @Published var playerWonGame: Player?
    @Published var updateSpeed: UpdateTimes = UpdateTimes(value: GlobalSettings.updateTimeInterval) {
        didSet {
            GlobalSettings.updateTimeInterval = updateSpeed.double
        }
    }
    @Published var rules: Rules = .doppelkopf

    @Published var chosenNumberOfPlayers : Int = GlobalSettings.chosenNumberOfPlayers

    init() {
        self.players = Players(names: GlobalSettings.playerNames)
        self.history = History()
    }
    
    // MARK: TODO: make a stringconvertible property wrapper to save typing below functions
    var maxGamesString: String {
        get { String(maxGames) }
        set { maxGames = Int(newValue) ?? GlobalSettings.maxGames }
    }
    
    var maxPointsString: String {
        get { String(maxPoints) }
        set { maxPoints = Int(newValue) ?? GlobalSettings.scorePerGame }
    }
        
    
    // MARK: constant data for this class
    let availablePlayers = [ 2, 3, 4, 6 ]
            
    func updateSettings() {
        // if number of players changed, restart the game
        if (chosenNumberOfPlayers != GlobalSettings.chosenNumberOfPlayers) {
            players = Players(names: names(for: chosenNumberOfPlayers))
            history.reset()
        }
        GlobalSettings.playerNames = players.names
        GlobalSettings.chosenNumberOfPlayers = chosenNumberOfPlayers
        GlobalSettings.scorePerGame = maxPoints
        GlobalSettings.maxGames = maxGames
        GlobalSettings.updateTimeInterval = updateSpeed.double
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
            return [ pairedPlayers[0], pairedPlayers[1] ]
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
        resetPlayers()
    }
    
    func resetPlayers() {
        // create new players
        // also resets the wonGames!
        // history needs reset, when players reset
        players = Players(names: GlobalSettings.playerNames)
        history.reset()
    }
    
    func removeLastPlayer() {
        guard !GlobalSettings.playerNames.isEmpty else { return }
        _ = GlobalSettings.playerNames.removeLast()
        resetPlayers()    }
    
    func removePlayer(named name: String) {
        GlobalSettings.playerNames = GlobalSettings.playerNames.filter {$0 == name}
        resetPlayers()
    }
    
    func updateState() {
        playerWonRound = players.items.filter { $0.score.value >= maxPoints }.first
        playerWonGame = players.items.filter { $0.games >= maxGames }.first
        
        if playerWonRound != nil || playerWonGame != nil {
            history.save(state: GameState(players: players.data))
        }
    }

    func newRound() {
        if let playerWon = playerWonRound {
            playerWon.games += 1
            playerWonRound = nil
        }
        // only set scores to zero, don't reset won games!
        _ = players.items.map { $0.score = Score(0) }
        history.reset()
    }

    func newGame() {
        resetPlayers()
        history.reset()
        playerWonRound = nil
        playerWonGame = nil
    }
    
    
    // a hack to send an event to all observers when the history functions are used
    @Published var needsUpdate = false
    var canUndo: Bool { history.canUndo }
    var canRedo: Bool { history.canRedo }
    
    /// clears all players buffers (used for undo)
    /// returns true if a buffer was cleared
    private func clearBuffers() -> Bool {
        return players.clearBuffers()
    }
    
    // MARK: History functions
    /// clears buffers first, then goes back in history
    func undo() {
        needsUpdate.toggle()
        if !clearBuffers() {
            history.undo()
        }
        updatePlayersWithCurrentState()
    }
    
    func redo() {
        needsUpdate.toggle()
        history.redo()
        updatePlayersWithCurrentState()
    }

    // MARK: Timers
    private var registerPointsTimer : Timer?
    private var countAsRoundTimer : Timer?

    var updateTimeIntervalToRegisterPoints: TimeInterval { updateSpeed.double }
    var timeIntervalToCountAsRound: TimeInterval = 10

    func startTimer() {
        registerPointsTimer?.invalidate()
        countAsRoundTimer?.invalidate()
        registerPointsTimer = Timer.scheduledTimer(timeInterval: updateTimeIntervalToRegisterPoints,
                                     target: self,
                                     selector: #selector(update),
                                     userInfo: nil,
                                     repeats: true)
        countAsRoundTimer? = Timer.scheduledTimer(timeInterval: timeIntervalToCountAsRound,
                                     target: self,
                                     selector: #selector(update),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // when the timer fires, players need to be updated, and history saved...
    @objc private func update() {
        // send the history a signal that it should be saved
        players.saveScore() // update all scores' buffer
        registerPointsTimer?.invalidate()
        updateState()
    }
    
    // this function adds the changes to the history, counting it as a round.
    @objc private func updateRound() {
        history.save(state: GameState(players: players.data))
        countAsRoundTimer?.invalidate()
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

