class ScoreBox {
	static var maxScore = 5
	
	var score = 0
	var tmpScore = 0
}

class BoxContainer {
	
	var score = 0
	var tmpScore = 0
	var boxes = [ScoreBox(),ScoreBox(),ScoreBox(),ScoreBox(),ScoreBox()]

	func finalizeScore() {
		score += tmpScore
		tmpScore = 0
	}
	
	func updateScore() {
		var black = self.score
		var red = self.tmpScore
		
		for box in boxes {
			if black > 0 {
				let thisScore = min(ScoreBox.maxScore, black)
				box.score = thisScore
				black -= thisScore
				if black == 0 { // we finished the black lines, continue with red
					let tmpScore = min(ScoreBox.maxScore - thisScore, red)
					box.tmpScore = tmpScore
					red -= tmpScore
				} else {
					box.tmpScore = 0 // don't count red lines down
				}
			} else {
				let tmpScore = min(ScoreBox.maxScore, red)
				box.tmpScore = tmpScore
				red -= tmpScore
			}
		}
	}
	
}

var container = BoxContainer()

container.score = 13
container.tmpScore = 3

container.updateScore()

for box in container.boxes {
	print("black lines: \(box.score)")
	print("red lines: \(box.tmpScore)")
}









