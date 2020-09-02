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
    @Published var maxPoints: Int
    @Published var playerWonRound: Player?
    @Published var playerWonGame: Player?
    @Published var updateSpeed: UpdateTimes = UpdateTimes(value: GlobalSettings.updateTimeInterval) {
        didSet {
            GlobalSettings.updateTimeInterval = updateSpeed.double
        }
    }
    
    @Published var rule: Rule = .trucoVenezolano {
        didSet { updateCurrentRule() }
    }
    
    /// assigns new values from the rules to the settings
    private func updateCurrentRule() {
        self.maxPoints = rule.maxPoints ?? 1000
        
        switch rule.players {
        case .fixed(let fixedPlayers):
            self.availablePlayers = [ fixedPlayers ]
        case .selection(let allowedPlayers):
            availablePlayers = allowedPlayers
        }
    }

    var playerScores : [ [ Int ] ] { history.differentialScores }
    @Published var chosenNumberOfPlayers : Int = GlobalSettings.chosenNumberOfPlayers

    init() {
        GlobalSettings.chosenNumberOfPlayers = 2
        self.players = Players(names: GlobalSettings.playerNames)
        self.history = History()
        self.maxPoints = GlobalSettings.scorePerGame
        createRules()
        updateCurrentRule()
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
        
    var possibleRules = [Rule]()
    
    func createRules() {
        possibleRules.append(Rule.trucoArgentino)
        possibleRules.append(Rule.trucoVenezolano)
        possibleRules.append(Rule.doppelkopf)
    }
    
    // MARK: constant data for this class
    var availablePlayers = [ 2, 3, 4, 6 ]
            
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
    var timeIntervalToCountAsRound: TimeInterval = 10 // the time we wait from last touch to register this as a round and add it to the history menu

    func startTimer() {
        /// starts two timers: one to register the points and one that counts the points as rounds in the background
        registerPointsTimer?.invalidate()
        registerPointsTimer = Timer.scheduledTimer(timeInterval: updateTimeIntervalToRegisterPoints,
                                     target: self,
                                     selector: #selector(updateRegisterPoints),
                                     userInfo: nil,
                                     repeats: false)

        countAsRoundTimer?.invalidate()
        countAsRoundTimer = Timer.scheduledTimer(timeInterval: timeIntervalToCountAsRound,
                                     target: self,
                                     selector: #selector(updateRound),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    // when the timer fires, players need to be updated, and history saved...
    @objc private func updateRegisterPoints() {
        // send the history a signal that it should be saved
        players.saveScore() // update all scores' buffer
        updateState()
        registerPointsTimer?.invalidate()
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

