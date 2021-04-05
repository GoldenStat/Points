//
//  GameSettings.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

class GameSettings: ObservableObject {
    
    /// the player objects store all current data
    /// reset history when this is reset
    @Published var players : Players { didSet { history.reset() }}
        
    /// track all game states - scores of all rounds
    @Published var history : History
    
    /// after these many games the game is over and a winning animation is shon
    @Published var maxGames: Int
    
    // MARK: TODO: make a stringconvertible property wrapper to save typing below functions
    var maxGamesString: String {
        get { String(maxGames) }
        set { maxGames = Int(newValue) ?? GlobalSettings.maxGames }
    }
    
    /// the amount you need to win a game
    @Published var maxPoints: Int
    
    var maxPointsString: String {
        get { String(maxPoints) }
        set { maxPoints = Int(newValue) ?? GlobalSettings.scorePerGame }
    }

    /// set this if a player has reached max points
    @Published var playerWonRound: Player?
    
    /// set this if a player has reached max games
    @Published var playerWonGame: Player?
    
    /// how fast should do you have to type points to count for a round
    @Published var updateSpeed: UpdateTimes = UpdateTimes(value: GlobalSettings.updateTimeInterval) {
        didSet {
            GlobalSettings.updateTimeInterval = updateSpeed.double
        }
    }
    
    /// used to drag'n drop points around
    @Published var pointBuffer: Int?

        
    /// players that can be chosen. Will be set by rules
    var availablePlayers : [Int] = []

    /// how many players are actually playing
    /// modifies the players object
    // NOTE: can be refactored if it is not used anywhere else (cleanup stage)
    @Published var chosenNumberOfPlayers : Int {
        didSet {
            handlePlayerChange(to: chosenNumberOfPlayers)
        }
    }
    
    // MARK: - setup
    
    /// reset the settings to get a defined default
    func resetToFactorySettings() {
        players = Players.sample
        chosenNumberOfPlayers = players.names.count
        history.reset()
        maxGames = 2
        rule = .trucoVenezolano
        maxPoints = rule.maxPoints.maxValue
    }
        
    init() {
        chosenNumberOfPlayers = GlobalSettings.chosenNumberOfPlayers
        players = Players(names: GlobalSettings.playerNames)
        history = History()
        maxPoints = GlobalSettings.scorePerGame
        maxGames = GlobalSettings.maxGames
        rule = Rule.defaultRule // needs to be set to enable calling methods
        setupRules()
    }
    
    /// update stored glogal - TODO: chek if obsolete
    func updateSettings() {
        // if number of players changed, restart the game
        GlobalSettings.playerNames = players.names
        GlobalSettings.chosenNumberOfPlayers = chosenNumberOfPlayers
        GlobalSettings.scorePerGame = maxPoints
        GlobalSettings.maxGames = maxGames
        GlobalSettings.updateTimeInterval = updateSpeed.double
        GlobalSettings.ruleID = rule.id
    }

    // setup something for testing
    fileprivate func setupHistoryTests() {
        var scores: [Int] = .init(repeating: 0, count: numberOfPlayers)
        
        for _ in 1 ... 10 {
            scores[0] += Int.random(in: (1 ... 3)) * 10
            history.add(state: GameState(buffer: scores))
            history.save()
        }
        updatePlayers()
    }
    
    // MARK: - rules
    /// the rules of the game - determines player interface, possible score steps, maxpoints
    @Published var rule: Rule { didSet { processRuleUpdate() } }

    func setupRules() {
        Rule.setup()
        rule = rule(id: GlobalSettings.ruleID)
        processRuleUpdate()
    }

    /// returns the rule with given ID or the default rule
    func rule(id: Int) -> Rule {
        possibleRules.first() { $0.id == id } ?? Rule.defaultRule
    }

    /// when rules change, several values have to be re-read
    ///
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
        
        scoreStep = rule.scoreStep.defaultValue
        
        // reset player's scores and history
        players.resetScores()
        history.reset()
    }
            
    var possibleRules : [Rule] { Rule.selectableRules }
    
    /// a value to be added to player's scores in interface
    /// must be updated when the rules change
    @Published var scoreStep: Int = 1
                
    // MARK: - control player data
    var numberOfPlayers: Int { players.count }
        
    @Published var editingPlayer: Player?
    
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
        players.reset()
    }

    // add or remove players appropriately
    func handlePlayerChange() {
        handlePlayerChange(to: chosenNumberOfPlayers)
    }

    /// checks the current rules if they have flexible player amounts
    var canAddPlayer: Bool { players.count < rule.players.maxValue }
    
    /// checks the current rules if they have flexible player amounts
    var canRemovePlayer: Bool { players.count > rule.players.minValue }
    
    func addRandomPlayer() {
        guard canAddPlayer else { return }
        players.add(name: "Player \(players.count + 1)")
        players.reset() // set all counts to zerio
        objectWillChange.send()
    }
    
    func removeLastPlayer() {
        guard canRemovePlayer else { return }
        _ = players.removeLast()
        players.reset()
    }

    // MARK: - control game State
    
    /// check if a player won the game or all games, sets the win-variables, accordingly
    // TODO: refactor and change to enum for possible outcomes
    func checkPlayerWon() {
        playerWonRound = players.items.filter { $0.score.value >= maxPoints }.first
        playerWonGame = players.items.filter { $0.games >= maxGames }.first
    }
    
    /// handle the beginning of a new round
    func newRound() {
        if let playerWon = playerWonRound {
            playerWon.games += 1
            playerWonRound = nil
        }
        
        // only set scores to zero, don't reset won games!
        players.resetScores()
        history.reset()
    }
    
    func newGame() {
        players.reset() // also resets history
        playerWonRound = nil
        playerWonGame = nil
    }
            
    // MARK: - Timers
    @Published private var registerPointsTimer : Timer?
    @Published private var registerRoundTimer : Timer?

    public var timeIntervalToCountPoints: TimeInterval { updateSpeed.double }
    public var timeIntervalToCountRound: TimeInterval { updateSpeed.double }

    public var timerPointsStarted : Bool { registerPointsTimer != nil }
    public var timerRoundStarted : Bool { registerRoundTimer != nil }
    
    func timer(interval: TimeInterval, selector: Selector) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: selector,
                                     userInfo: nil,
                                     repeats: false)
    }
    
    /// invalidates timer and sets it to nil
    func stop(timer: inout Timer?) {
        timer?.invalidate()
        timer = nil
    }
    
    /// stops timers and starts the registerPointsTimer
    func startTimer() {
        /// starts two timers: one to register the points and one that counts the points as rounds in the background
        cancelTimers()
        registerPointsTimer = timer(interval: timeIntervalToCountPoints, selector: #selector(updatePoints))
    }
    
    /// stops all timers
    func cancelTimers() {
        stop(timer: &registerPointsTimer)
        stop(timer: &registerRoundTimer)
    }
    
    /// control Timer from outside
    /// execute the actions it should perform
    func fireTimer() {
        updatePoints()
        registerRound()
    }
    
    /// use this when you want to update points and start the countdown
    func startCountDown() {
        updatePoints()
        objectWillChange.send()
    }
    
    /// start of a countdown, after the trigger action.
    /// points are added to the player's buffer and *updatePoints()* is started when we touch a *PlayerView()*
    ///
    /// 1. cancel Timers
    /// 2. players' *score*s are saved, adding their *buffer* to their *value*,
    /// 3. we check if a player has won
    /// 4. start the *updatePoints()* timer
    ///
    @objc private func updatePoints() {

        cancelTimers()

        players.saveScores() // reset all player scores' buffers, updates values, reflects visually
        
        // check if a player has won and handle the win
        checkPlayerWon()

        registerRoundTimer = timer(interval: timeIntervalToCountRound, selector:  #selector(registerRound))
    }
            
    /// 3. updateRound()
    ///     1. save the history's <buffer>, appending the last value to the state queue
    ///     2. invalidate all running timers
    @objc private func registerRound() {
        history.save()
        cancelTimers()
        players.updateActivePlayerIndex()
    }
        
    // MARK: - history functions
    
    // remember how to visualize history
    @Published var showSumsInHistory: Bool = false
    
    /// overwrite history in save buffer with player's points totals
    func storeInHistory() {
        history.store(state: players.totals)
        updatePlayers()
        players.objectWillChange.send()
        objectWillChange.send()
    }
        
    // needed for object update
    func undoHistory() {
        cancelTimers()
        history.undo()
        updatePlayers() // ignore buffer
    }

    func redoHistory() {
        cancelTimers()
        history.redo()
        updatePlayers() // ignore buffer
    }
    
    /// call this when you want to delete the redo-stack
    public func updateHistory() {
        /// we have the history states where we want them, just have to erase the  buffers of set the last state as the current one
        cancelTimers()
        history.save() // update history, throw buffer away
        history.clearBuffer()
        updatePlayers()
    }
    
    /// updates Players to current history state
    /// calculates the difference of buffer and score, if buffer is given (assumes that buffer is in a 'later' state)
    private func updatePlayers() {
        let zeroScores = [Score](repeating: Score(0), count: numberOfPlayers)
        
        // sets values and buffers according to history stacks
        players.setScores(to: history.redoScores ?? zeroScores)
        
    }
    
}

