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
    @Published var maxGames: Int
    @Published var maxPoints: Int
    @Published var playerWonRound: Player?
    @Published var playerWonGame: Player?
    @Published var updateSpeed: UpdateTimes = UpdateTimes(value: GlobalSettings.updateTimeInterval) {
        didSet {
            GlobalSettings.updateTimeInterval = updateSpeed.double
        }
    }
    
    @Published var rule: Rule {
        didSet { processRuleUpdate() }
    }
    
    /// players that can be chosen. Will be set by rules
    var availablePlayers : [Int] = []

    /// assigns new values from the rules to the settings
    /// should be called whenever the rules change (the game changed)
    private func processRuleUpdate() {
        switch rule.maxPoints {
        case .none:
            maxPoints = 1000
        case .fixed(let value):
            maxPoints = value
        case .free(let value):
            maxPoints = value
        case .selection(let options):
            maxPoints = options.randomElement()! // for now, choose a random value, options should never be empty
        }

        switch rule.players {
            case .fixed(let fixedPlayers):
                availablePlayers = [ fixedPlayers ]
                chosenNumberOfPlayers = fixedPlayers
            case .selection(let allowedPlayers):
                availablePlayers = allowedPlayers
        }
        
    }
    
    @Published var chosenNumberOfPlayers : Int {
        didSet {
            history.reset()
        }
    }
    

    init() {
        chosenNumberOfPlayers = GlobalSettings.chosenNumberOfPlayers
        players = Players(names: GlobalSettings.playerNames)
        history = History(names: GlobalSettings.playerNames)
        maxPoints = GlobalSettings.scorePerGame
        maxGames = GlobalSettings.maxGames
        rule = .doppelkopf // needs to be set to call methods
        
        createRules()
        rule = rule(id: GlobalSettings.ruleID)
        processRuleUpdate()
    }
    
    func rule(id: Int) -> Rule {
        let defaultRule = possibleRules.randomElement()
        for rule in possibleRules {
            if rule.id == id {
                return rule
            }
        }
        return defaultRule!
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
        addRule(.trucoArgentino)
        addRule(.trucoVenezolano)
        addRule(.doppelkopf)
        addRule(.caida)
        addRule(.scopa)
        addRule(.skat)
        addRule(.shitzu)
    }
    
    func addRule(_ rule: Rule) {
        possibleRules.append(rule)
    }
                
    func updateSettings() {
        // if number of players changed, restart the game
        GlobalSettings.playerNames = players.names
        GlobalSettings.chosenNumberOfPlayers = chosenNumberOfPlayers
        GlobalSettings.scorePerGame = maxPoints
        GlobalSettings.maxGames = maxGames
        GlobalSettings.updateTimeInterval = updateSpeed.double
        GlobalSettings.ruleID = rule.id        
    }
        
    // MARK: control player data
    var numberOfPlayers: Int { players.items.count }
    
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
        storeBuffer(from: players)
        players.saveScore() // reset all player scores' buffers, updates values
        updateState()
        registerPointsTimer?.invalidate()
    }
    
    /// register player's points from this round into history's buffer
    func storeBuffer(from players: Players) {
        // add to  buffers
        if buffer != nil {
            for (index,playerBuffer) in players.scores.map({ $0.buffer } ).enumerated() {
                buffer![index] += playerBuffer
            }
        } else {
            buffer = players.scores.map { $0.buffer }
        }
        history.store(state: GameState(players: players.data))
    }
    
    var buffer: [Int]?
    
    /// this function adds the changes to the history, counting it as a round.
    /// history adds hist buffer to it's states
    @objc private func updateRound() {
        history.save()
        buffer = nil
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

