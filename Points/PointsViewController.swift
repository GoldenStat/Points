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
	static let setupGame = #selector(PointsViewController.setupGame(from:))
	static let editSettings = #selector(PointsViewController.editSettings)
	static let addPoint = #selector(PointsViewController.addPoint)
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
		boardView?.update(with: world)
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
	var numberOfPlayers = 2
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.

		initRightBarButtonItems(mode: .play)
		
		world = GameWorld(count: numberOfPlayers)
		loadSettings()
		setup(count: numberOfPlayers)
		updateUI()
		
		view.bringSubviewToFront(gameScoreArea)
		gameScoreArea.backgroundColor = view.backgroundColor
		settingsView.backgroundColor = view.backgroundColor
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		for constraint in view.constraints {
			if constraint.identifier == "bottomConstraint" {
				bottomConstraint = constraint
				bottomConstraintConstant = bottomConstraint.constant
			}
		}
	}
	
	var bottomConstraint: NSLayoutConstraint! // save a pointer to the constraint we might need to modify
	
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
	
	/// setupGame
	/// sets up a new game
	/// side effects: erases History
	/// - Parameter barButton: the UIBarButtonItem that invokes the function. It's title must be a number.
	@objc func setupGame(from barButton: UIBarButtonItem) {
		// crash if the button doesn't have a title or the title is not a number: we should not be here!
		let numberOfPlayers : Int = Int(barButton.title!)!
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
			updateControlView()
		case .play:
			// enable user interactions in board and score areas whilst in edit mode
			newAlpha = 0.0
			boardView.activate()
			gameScoreArea.isUserInteractionEnabled = true
			settingsView.isUserInteractionEnabled = false
			updateControlView()
		}
		
		UIView.animate(withDuration: 0.5) {
			[ weak self ] in
			self?.settingsView.alpha = newAlpha
			self?.gameScoreArea.alpha = 1.0 - newAlpha
			self?.boardView.setNeedsUpdateConstraints()
		}
		
		updateSettings()
	}
	
	func updateControlView() {
		if gameMode == ControlMode.play {
			view.bringSubviewToFront(gameScoreArea)
		} else {
			view.bringSubviewToFront(settingsView)
		}
	}
	
	func updateUI() {
		boardView.updatePlayerUIs()
		updateGameScores()
		updateSettings()
		updateControlView()
	}
	
	func updateSettings() {
		// pointStepsSegmentedControl
		maxGamesTextField.text = "\(maxGames)"
		maxPointsTextField.text = "\(maxPoints)"
	}
		
	/// Settings
	
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
	
	/// set up a new game
	/// throws everything away and create a new world
	func setup(count numberOfPlayers: Int) {

		world = GameWorld(count: numberOfPlayers)
		gameStateHistory = History()

		setupGameScoreArea()
		setupBoardView()
		setDelegations(to: self)
		updateUI()
	}
	
	func setDelegations(to delegate: UITextFieldDelegate) {
		// set the textField delegate in all places
		boardView.delegate = delegate
		maxGamesTextField.delegate = delegate
		maxPointsTextField.delegate = delegate
		
		// set the actions for the buttons
		for ui in boardView.playerUIs {
			ui.scoreButton!.addTarget(self, action: .addPoint, for: .touchUpInside)
		}
	}
	
	func setupBoardView() {
		boardView?.removeFromSuperview()
		
		boardView = GameBoardView(frame: view.frame)
		boardView.clipsToBounds = true
		view.addSubview(boardView)
		boardView.translatesAutoresizingMaskIntoConstraints = false
		boardView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
		boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//		boardView.bottomAnchor.constraint(equalTo: gameScoreArea.topAnchor).isActive = true
		boardView.heightAnchor.constraint(equalToConstant: view.frame.height - gameScoreArea.frame.height).isActive = true
		boardView.setup(for: world.players) // creates world.players PlayerUIs
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
	
	/// Text Field Handlers
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// moving up the view is covered with NotificationCenter observers
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
	
	// limit all textFields (for names, especially) to 32 characters
	let characterLimitForTextFields = 32
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else {return false}

		let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
		
		return updatedText.count <= characterLimitForTextFields
	}

	/// REMARK: -- move view frame if software keyboard appears

	var bottomConstraintConstant: CGFloat!

	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			// keyboard hides, go back to normal
			// restore anchor to old constant value
			UIView.animate(withDuration: 1.0) { [weak self ] in
				self?.bottomConstraint.constant = self?.bottomConstraintConstant ?? 20
				self?.view.layoutIfNeeded()
			}
		} else {
			// trigger animation
			UIView.animate(withDuration: 1.0) { [weak self] in
				// move up the keyboard height
				self?.bottomConstraint.constant = keyboardViewEndFrame.height + (self?.bottomConstraintConstant ?? 20)
				self?.view.layoutIfNeeded()
			}
		}
	}
	
}
