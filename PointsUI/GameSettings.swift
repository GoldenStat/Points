//
//  GameSettings.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

//protocol StringExpressable {
//    init(_ string: String) -> Self?
//}
//
//@propertyWrapper
//struct StringConvertible<Value : CustomStringConvertible, StringExpressable> {
//    var wrappedValue: Value
//    var defaultValue: Value
//    var string : String {
//        get { wrappedValue.description }
//        set { Value.init(newValue) ?? defaultValue }
//    }
//    
//    init(wrappedValue: Value, defaultValue: Value) {
//        self.wrappedValue = wrappedValue
//        self.defaultValue = defaultValue
//    }
//}

class GameSettings: ObservableObject {
    
    @Published var players : Players
    @Published var history : History
    @Published var maxGames: Int = GlobalSettings.maxGames
    @Published var maxPoints: Int = GlobalSettings.scorePerGame
    @Published var updateTimeInterval: TimeInterval = GlobalSettings.updateTime
    @Published var playerWonRound: Player?
    @Published var playerWonGame: Player?
    
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
    
    var updateTimeIntervalString: String {
        get { String(updateTime) }
        set { updateTime = TimeInterval(newValue) ?? GlobalSettings.updateTime }
    }
    
    // MARK: constant data for this class
    static let name = "Truco Points"
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
        resetPlayers()
    }
    
    func resetPlayers() {
        // create new players
        // also resets the wonGames!
        players = Players(names: GlobalSettings.playerNames)
        history = History()
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
    }

    func newGame() {
        resetPlayers()
        playerWonRound = nil
        playerWonGame = nil
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
        
        updateState()
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

