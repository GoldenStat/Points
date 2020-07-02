//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

/// UserDefault property wrapper:
/// define a default, and store the variable in UserDefaults whenever it is set
///
/// example:
///
///     enum GlobalSettings {
///         @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
///     }
///
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/// all our default values stored in UserDefaults as enum
///
/// - Parameters
/// - Parameter maxGames: how many games does a player have to win
/// - scorePerGame: how much can a player score before he wins a game
/// - playerNames: Who is playing
///
enum GlobalSettings {
    @UserDefault(key: "UpdateTime", defaultValue: 5) static var updateTime: TimeInterval
    @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
    @UserDefault(key: "MaxScore", defaultValue: 24) static var scorePerGame: Int
    @UserDefault(key: "PlayerNumber", defaultValue: 2) static var chosenNumberOfPlayers: Int
    @UserDefault(key: "PlayerNames", defaultValue: [ "Nosotros", "Ustedes", "Ellos" ])
    static var playerNames : [String]

}

class GameSettings: ObservableObject {
    
    @Published var players = Players(names: GlobalSettings.playerNames)
    @Published var history = History()
    
    var chosenNumberOfPlayers : Int {
        get { GlobalSettings.chosenNumberOfPlayers }
        set {
            GlobalSettings.chosenNumberOfPlayers = chosenNumberOfPlayers
            GlobalSettings.playerNames = GameSettings.names(for: newValue)
            updateSettings()
        }
    }
    
    init () {
        chosenNumberOfPlayers = 3
        GlobalSettings.scorePerGame = 24
        GlobalSettings.maxGames = 3
    }
    
    var playerWon: Player?

    static let name = "Truco Points"
    
    static let availablePlayers = [ 2, 3, 4, 6 ]

    static func names(for numberOfPlayers: Int) -> [String] {
        guard GameSettings.availablePlayers.contains(numberOfPlayers) else { return [] }
        
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
    
    var numberOfPlayers: Int { players.items.count }
    
    var playerNames: [ String ] {
        players.names
    }
    
    func player(named name: String) -> Player? {
        players.items.filter {$0.name == name}.first
    }
    
    func changePlayerName(from name: String, to newName: String) {
        if let player = player(named: name) {
            player.name = newName
        }
    }
        
    func updateSettings() {
        if (players.names != GlobalSettings.playerNames) {
            players = Players(names: GlobalSettings.playerNames)
            history = History()
        }
        updateTime = GlobalSettings.updateTime
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
    
    func undo() {
        history.undo()
        updatePlayersWithCurrentState()
    }
    
    func redo() {
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

