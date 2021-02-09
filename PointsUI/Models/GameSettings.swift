//
//  GameSettings.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

class GameSettings: ObservableObject {
    
    @Published var players : Players { didSet { history.reset() }}
    @Published var activePlayer: Player?
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
    
    @Published var pointBuffer: BufferSpace?
    
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
        activePlayer = nil
        players = Players.sample
        chosenNumberOfPlayers = players.names.count
        history = History()
        maxPoints = 0
        maxGames = 2
        rule = .maumau
        createRules()
    }
    
    init() {
        chosenNumberOfPlayers = GlobalSettings.chosenNumberOfPlayers
        players = Players(names: GlobalSettings.playerNames)
        history = History()
        maxPoints = GlobalSettings.scorePerGame
        maxGames = GlobalSettings.maxGames
        rule = .trucoVenezolano // needs to be set to enable calling methods
        setupRules()
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
        
    // MARK: - control player data
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
    
    /// reset the players. Changes scores, resets history - basically starts a new game
    func resetPlayers() {
        // create new players
        // also resets the wonGames!
        players = Players(names: playerNames)
        
        activePlayer = nil
    }
    
    // only reset the scores for a new round
    func resetPlayerScores() {
        _ = players.items.map { $0.score = Score(0) }
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

        // start a new game
        resetPlayers()
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
        resetPlayers()
    }
    
    func removeLastPlayer() {
        guard canRemovePlayer else { return }
        _ = players.removeLast()
        resetPlayers()
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
        resetPlayerScores()
        history.reset()
    }
    
    func newGame() {
        resetPlayers() // also resets history
        playerWonRound = nil
        playerWonGame = nil
    }
    
    /// clears all players buffers (used for undo)
    /// returns true if a buffer was cleared
    private func clearBuffers() -> Bool {
        return players.clearBuffers()
    }
        
    // MARK: - Timers
    private var registerPointsTimer : Timer?
    private var registerRoundTimer : Timer?

    public var timeIntervalToCountPoints: TimeInterval { updateSpeed.double }
    public var timeIntervalToCountRound: TimeInterval { updateSpeed.double }

    public var timerPointsStarted : Bool { registerPointsTimer != nil }
    public var timerRoundStarted : Bool { registerRoundTimer != nil }
    
    func start(interval: TimeInterval, selector: Selector) -> Timer {
        objectWillChange.send()
        return Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: selector,
                                     userInfo: nil,
                                     repeats: false)
    }
    
    func stop(timer: inout Timer?) {
        timer?.invalidate()
        timer = nil
        objectWillChange.send()
    }
    
    func startTimer() {
        
        /// starts two timers: one to register the points and one that counts the points as rounds in the background
        cancelTimers()
        registerPointsTimer = start(interval: timeIntervalToCountPoints, selector: #selector(updatePoints))
    }
    
    /// control Timer from outside
    /// invalidates it
    func cancelTimers() {
        stop(timer: &registerPointsTimer)
        stop(timer: &registerRoundTimer)
    }
    
    /// control Timer from outside
    /// execute the actions it should perform
    func fireTimer() {
        updatePoints()
        updateRound()
    }
    
    // when the timer fires, players need to be updated, and history buffer updated...
    @objc private func updatePoints() {
        // add to bufferForHistory
        players.saveScore() // reset all player scores' buffers, updates values, reflects visually
        history.store(state: GameState(players: players.data))
        updateState()
        registerPointsTimer?.invalidate()
        registerPointsTimer = nil
        pointBuffer = nil
        registerRoundTimer = start(interval: timeIntervalToCountRound, selector:  #selector(updateRound))
    }
            
    /// this function adds the changes to the history, counting it as a round.
    /// history adds hist buffer to it's states
    @objc private func updateRound() {
        history.save()
        cancelTimers()
    }
    
    // needed for object update
    func undo() {
        cancelTimers()
        history.undo()
        updateCurrentState()
    }
    
    func updateCurrentState() {
        /// update players with game state from current state?
        if let currentState = history.states.last {
            players.setScores(to: currentState.scores)
        } else {
            resetPlayerScores()
        }
    }
    
    func redo() {
        cancelTimers()
        history.redo()
        updateCurrentState()
    }
}

