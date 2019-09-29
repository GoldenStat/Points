//
//  PointsViewController,swift
//  Points
//
//  Created by Alexander Völz on 09.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//


import UIKit
import GameKit

fileprivate extension Selector {
	static let setupGame = #selector(PointsViewController.setupGame(with:))
	static let editSettings = #selector(PointsViewController.editSettings)
	static let addPoints = #selector(PointsViewController.addPoint(for:))
	static let resetScores = #selector(PointsViewController.resetScores)
}

class PointsViewController: UIViewController, UITextFieldDelegate {

	
	var boardView : GameBoardView!

	var world: GameWorld!
	var gameStateHistory: History!

	let allowedPointSteps = [ 1, 5, 10, 100 ]
	var pointSteps : Int { get { return allowedPointSteps[selectedIndexForPoints] } }

	var selectedIndexForPoints = 0 { didSet { pointStepsSegmentedControl.selectedSegmentIndex = selectedIndexForPoints
		saveSettings()
		}}
	
	var maxPoints: Int { get { return world.maxPoints } set { world.maxPoints = newValue
		maxPointsTextField.text = String(newValue)
		boardView.update(with: world)
		saveSettings()
		}}
	
	var maxGames: Int { get { return world.maxGames } set {
		world.maxGames = newValue
		maxGamesTextField.text = String(newValue)
		saveSettings()
		}}
	
	/// section: Settings
	var gameMode = ControlMode.play

	@IBOutlet var settingsView: UIStackView!
	@IBOutlet var maxPointsTextField: UITextField!
	@IBOutlet var maxGamesTextField: UITextField!
	@IBOutlet var pointStepsSegmentedControl: UISegmentedControl!
	
	var lastViewPoint : CGPoint?
	var settingHeight : CGFloat {
		get { return settingsView.frame.height }
	}
	
	// REMARK: -- initialization

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.

		initRightBarButtonItems(mode: .play)
		
		maxPointsTextField.delegate = self
		maxGamesTextField.delegate = self

		setup(count: 2)
		loadSettings()
		updateUI()
		
		view.bringSubviewToFront(gameScoreArea)
	}

	// REMARK: -- ViewController configuration

	func initRightBarButtonItems(mode: ControlMode) {
		switch mode {
		case .edit:
			let editItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .editSettings)
			///enable user interactions in board and score areas whilst in edit mode
			var playerGameItems = [UIBarButtonItem]()
			for count in 2 ... 6 {
				playerGameItems.append(UIBarButtonItem(title: String(count),
													   style: .plain,
													   target: self,
													   action: .setupGame))
			}
			playerGameItems.append(editItem)
			navigationItem.rightBarButtonItems = playerGameItems
		case .play:
			let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: .editSettings)
			
			navigationItem.rightBarButtonItems = [ editItem ]
		}
	}
	
	@objc func setupGame(with button: UIBarButtonItem) {
		// crash if the button doesn't have a title or the title is not a number: we should not be here!
		let numberOfPlayers : Int = Int(button.title!)!
		self.setup(count: numberOfPlayers)
	}

	// REMARK: -- edit Mode
	
	@objc func editSettings() {

		gameMode.toggle()
		initRightBarButtonItems(mode: gameMode)

		var newAlpha : CGFloat

		switch gameMode {
		case .edit:
			// disable user interactions in board and score areas whilst in edit mode
			newAlpha = 1.0
			boardView.deactivate()
			gameScoreArea.isUserInteractionEnabled = false
			settingsView.isUserInteractionEnabled = true
			view.bringSubviewToFront(settingsView)
		case .play:
			// enable user interactions in board and score areas whilst in edit mode
			newAlpha = 0.0
			boardView.activate()
			gameScoreArea.isUserInteractionEnabled = true
			settingsView.isUserInteractionEnabled = false
			view.bringSubviewToFront(gameScoreArea)
		}
		
		UIView.animate(withDuration: 0.5) {
			[ weak self ] in
			self?.settingsView.alpha = newAlpha
			self?.gameScoreArea.alpha = 1.0 - newAlpha
		}
		
		updateSettings()
	}

	func rearrange(view: UIView, to point: CGPoint) {
		UIView.animate(withDuration: 1.0) {
			[ weak view ] in
			view?.center = point
		}
	}
	
	func updateUI() {
		updateGameScores()
		updateSettings()
	}
	
	func updateSettings() {
		// pointStepsSegmentedControl
		maxGamesTextField.text = "\(maxGames)"
		maxPointsTextField.text = "\(maxPoints)"
	}
	
	@objc func addNewPlayer() {
		let ac = UIAlertController(title: "Nuevo Jugador", message: "como te llamas?", preferredStyle: .alert)
		ac.addTextField()
		
		let action = UIAlertAction(title: "Invita!", style: .default) {
			[ weak self, weak ac ] sender in
			if let field = ac?.textFields?.first {
				if let newName = field.text {
					self?.addPlayer(name: newName)
				}
			}
			
		}
		
		ac.addAction(action)
		
		present(ac, animated: true) {
			[ weak self ] in
			self?.updateUI()
		}
	}
	
	func addPlayer(name: String) {
		var playerNames = world.players.map {$0.name}
		playerNames.append(name)
		
		updateUI()
	}
	
	var textFieldPositionBeforeEditing: CGPoint?

	func textFieldDidEndEditing(_ textField: UITextField) {
		// idea:
		// move textfield back animated, covering everything else, maybe zooming
		UIView.animate(withDuration: 1.0) { [weak self, weak textField] in
			if let oldPosition = self?.textFieldPositionBeforeEditing {
				textField?.frame.center = oldPosition
			} }
		textFieldPositionBeforeEditing = nil
		
		if let newValue = textField.text {
			if let number = Int(newValue) {
				switch textField {
				case maxGamesTextField:
					maxGames = number
				case maxPointsTextField:
					maxPoints = number
				default:
					break
				}
			} else {
				let name = newValue
				let index = textField.tag
				world.players[index].name = name
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// idea:
		// get textfield position
		// move textfield up animated, covering everything else, maybe zooming
		textFieldPositionBeforeEditing = textField.frame.center
		UIView.animate(withDuration: 1.0) { [weak self, weak textField] in
			let tempPosition = CGPoint(x: self?.view.frame.center.x ?? 0.0, y: 400)
			textField?.frame.center = tempPosition
		}
	}
	
	func saveSettings() {
		let settings : [String : Any] = [ "gamePoints": maxPoints,
										  "selectedPointsIndex": selectedIndexForPoints,
										  "maxGames": maxGames,
										  "playerNames" : [world.players.map {$0.name}] ]
		
		let defaults = UserDefaults.standard
		defaults.set(settings, forKey: "Settings")
	}
	
	func loadSettings() {
		let defaults = UserDefaults.standard
		if let settings = defaults.dictionary(forKey: "Settings") {
			maxGames = settings["maxGames"] as! Int
			maxPoints = settings["gamePoints"] as! Int
			selectedIndexForPoints = settings["selectedPointsIndex"] as! Int
			if let playerNames = settings["PlayerNames"] as? [ String ] {
				world.resetPlayers(with: playerNames)
			}
		}
	}
	
	func setup(count numberOfPlayers: Int) {
		
		world = GameWorld(count: numberOfPlayers)
		gameStateHistory = History()

		setupGameScoreArea()
		setupBoardView()
		loadSettings()
		updateUI()
	}
	
	func setupBoardView() {
		boardView?.removeFromSuperview()
		
		boardView = GameBoardView(frame: view.frame)
		boardView.set(delegate: self)
		boardView.clipsToBounds = true
		view.addSubview(boardView)
		boardView.translatesAutoresizingMaskIntoConstraints = false
		boardView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
		boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		boardView.bottomAnchor.constraint(equalTo: gameScoreArea.topAnchor).isActive = true
		boardView.setup(for: world.players)
		for id in 0 ..< boardView.players.count {
			if let ui = boardView.ui(for: id) {
				ui.addTarget(target: self, action: .addPoints)
			}
		}
	}
		
	var gameScoreArea: GameScoreArea!

	func setupGameScoreArea() {

		var lastPosition : CGPoint?
		var newAlpha : CGFloat = 1.0
		
		if let area = gameScoreArea {
			lastPosition = area.center
			area.removeFromSuperview()
			newAlpha = area.alpha
		}
		
		gameScoreArea = GameScoreArea(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
		
		gameScoreArea.setup()
		gameScoreArea.alpha = newAlpha
		
		gameScoreArea.center = lastPosition ?? CGPoint(x: view.center.x, y: view.frame.maxY - gameScoreArea.frame.height / 2.0 - 20.0)
		
		gameScoreArea.buttonAction(from: self, action: .resetScores)

		view.addSubview(gameScoreArea)
	}
	
	func updateGameScores() {
		gameScoreArea.set(scores: world.games)
	}

	@objc func resetScores() {
		
		world.resetScores()
		gameStateHistory = History()
		updateUI()
	}
	
	/// SECTION: game Ended
	
	func gameEnded(winningTeam: Player) {
		
		var ac : UIAlertController
		
		winningTeam.won()

		if winningTeam.name == world.players[0].name {
			ac = UIAlertController(title: "we won! 😃", message: "continue?", preferredStyle: .alert)
		} else {
			ac = UIAlertController(title: "we lost! 😭", message: "revanche?", preferredStyle: .alert)
		}
		
		let alertAction = UIAlertAction(title: "OK", style: .default)  {
			[ weak self ] action in
			self?.resetScores()
			self?.updateUI()
		}
		ac.addAction(alertAction)
		
		present(ac, animated: true)

	}
	
	func checkIfWon() {
		if let winningPlayer = world.players.filter({ $0.score >= maxPoints }).first {
			gameEnded(winningTeam: winningPlayer)
		}
	}
	
	func resetAll(_ sender: Any) {
		setup(count: 2)
		updateUI()
	}
	
	@objc func addPoint(for sender: ScoreButton) {
	
		let currentState = GameState(with: world!.players)
		gameStateHistory.add(state: currentState)
	
		if let ui = sender.parentFocusEnvironment as? PlayerUI {
			ui.add(points: pointSteps)
		}
		
		checkIfWon()
		updateUI()
	}

	@IBAction func undo(_ sender: Any) {
		if let curState = gameStateHistory.restoreLast() {
			for (index, points) in curState.points.enumerated() {
				world.players[index].score = points
			}
		}
		updateUI()
	}
	
	@IBAction func updateLimit(_ textField: UITextField) {
		if let text = textField.text {
			if let newMax = Int(text) {
				switch textField {
				case maxGamesTextField:
					world.maxGames = newMax
				case maxPointsTextField:
					world.maxPoints = newMax
				default:
					return
				}
			}
		}
		checkIfWon()
		updateUI()
	}
	
	@IBAction func updatePointSteps(_ sender: UISegmentedControl) {
		selectedIndexForPoints = sender.selectedSegmentIndex
	}

}
