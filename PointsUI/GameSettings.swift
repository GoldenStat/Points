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
            case .selection(let allowedPlayers): // only change chosenNumberOfPlayers if new selection does not include
                availablePlayers = allowedPlayers
                if !allowedPlayers.contains(chosenNumberOfPlayers) {
                    if let randomPlayerCount = allowedPlayers.randomElement() {
                        chosenNumberOfPlayers = randomPlayerCount
                    } else {
                        assertionFailure("allowedPlayers must not be empty. Check rule <\(rule.name)>")
                    }
                }
        }
        
    }
    
    @Published var chosenNumberOfPlayers : Int {
        didSet {
            handlePlayerChange(to: chosenNumberOfPlayers)
        }
    }

    /// reset the settings to get a defined default
    func resetToFactorySettings() {
        players = Players.sample
        chosenNumberOfPlayers = players.names.count
        history = History(names: players.names)
        maxPoints = 0
        maxGames = 2
        rule = .maumau
        createRules()
    }
    
    init() {
        chosenNumberOfPlayers = GlobalSettings.chosenNumberOfPlayers
        players = Players(names: GlobalSettings.playerNames)
        history = History(names: GlobalSettings.playerNames)
        maxPoints = GlobalSettings.scorePerGame
        maxGames = GlobalSettings.maxGames
        rule = .trucoVenezolano // needs to be set to enable calling methods
        setupRules()
//        resetToFactorySettings()
    }
    
    
    func setupRules() {
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
        addRule(.maumau)
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
    var numberOfPlayers: Int { players.count }
    
    var playerNames: [ String ] { players.names }
    
    func player(named name: String) -> Player? {
        players.items.filter {$0.name == name}.first
    }
    
    func changePlayerName(from name: String, to newName: String) {
        if let player = player(named: name) {
            player.name = newName
        }
    }
    
    /// reset the players. Only changes scores and resets history
    func resetPlayers() {
        // create new players
        // also resets the wonGames!
        players = Players(names: GlobalSettings.playerNames)
        
        // history needs reset, when players reset
        history.reset()
    }
    
    // add or remove players appropriately
    func handlePlayerChange(to newPlayers: Int) {
        while newPlayers > players.count {
            // add random names
            addRandomPlayer()
        }
        while newPlayers < players.count {
            removeLastPlayer()
        }
    }

    // add or remove players appropriately
    func handlePlayerChange() {
        handlePlayerChange(to: chosenNumberOfPlayers)
    }

    /// checks the current rules if they have flexible player amounts
    var canAddPlayers: Bool { players.count < rule.players.maxValue }
    
    /// checks the current rules if they have flexible player amounts
    var canRemovePlayer: Bool { players.count > rule.players.minValue }
    
    func addRandomPlayer() {
        guard canAddPlayers else { return }
        players.add(name: "Player \(players.count + 1)")
        objectWillChange.send()
    }
    
    func removeLastPlayer() {
        guard canRemovePlayer else { return }
        _ = players.removeLast()
    }


    
    // MARK: - control game State
    
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
    private var registerPointsTimer : Timer? { didSet { objectWillChange.send() } } // send modification notice to observers
    private var countAsRoundTimer : Timer? { didSet { objectWillChange.send() } } // send modification notice to observers

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
    
    // when the timer fires, players need to be updated, and history buffer updated...
    @objc private func updateRegisterPoints() {
        // add to bufferForHistory
        updateHistoryBuffer(from: players.scores) // add player's score buffer to bufferForHistoryStore
        players.saveScore() // reset all player scores' buffers, updates values, reflects visually
        updateState()
        registerPointsTimer?.invalidate()
        registerPointsTimer = nil
    }

    /// a points buffer for history
    var bufferForHistoryStore: [Int]?
    
    /// register player's points from this round into history's buffer
    func updateHistoryBuffer(from scores: [Score]) {
        // add to  buffers
        if bufferForHistoryStore != nil {
            for (index,scoreBuffer) in scores.map({ $0.buffer }).enumerated() {
                // as long as the round is not over
                bufferForHistoryStore![index] += scoreBuffer
            }
        } else {
            bufferForHistoryStore = scores.map { $0.buffer }
        }
        
        // overwirte history store
        history.store(state: GameState(buffer: bufferForHistoryStore))
    }
        
    /// this function adds the changes to the history, counting it as a round.
    /// history adds hist buffer to it's states
    @objc private func updateRound() {
        history.save() 
        bufferForHistoryStore = nil
        countAsRoundTimer?.invalidate()
        countAsRoundTimer = nil
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

