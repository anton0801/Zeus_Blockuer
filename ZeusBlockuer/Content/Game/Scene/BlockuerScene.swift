import SwiftUI
import SpriteKit

class BlockuerScene: SKScene {

    var level: Int
    var gameFieldData: GameFieldData
    
    func restartGame() -> BlockuerScene {
        let s = BlockuerScene(level: level)
        view?.presentScene(s)
        return s
    }
    
    func restartGame(level: Int) -> BlockuerScene {
        let s = BlockuerScene(level: level)
        view?.presentScene(s)
        return s
    }
    
    private var selectedNode: SKSpriteNode?
    private var originalPosition: CGPoint?
    private var blockPositions: [String: BlockColor] = [:]
    
    init(level: Int) {
        self.level = level
        self.gameFieldData = gameFieldDataItems[self.level - 1]
        super.init(size: CGSize(width: 750, height: 1335))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var background: SKSpriteNode {
        get {
            let backgroundNode = SKSpriteNode()
            let backgroundImage = SKSpriteNode(imageNamed: "background")
            backgroundImage.size = size
            backgroundNode.addChild(backgroundImage)
            
            let backgroundOverlayBlack = SKSpriteNode(color: .black.withAlphaComponent(0.6), size: size)
            backgroundNode.addChild(backgroundOverlayBlack)
            
            backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            backgroundNode.size = size
            
            return backgroundNode
        }
    }
    
//    private var backLevelBtn: SKSpriteNode = SKSpriteNode(imageNamed: "arrow_left")
//    private var nextLevelBtn: SKSpriteNode = SKSpriteNode(imageNamed: "arrow_right")
    var levelText = SKLabelNode(text: "")
    private var levelLabel: SKSpriteNode {
        get {
            let levelNode = SKSpriteNode()
            let levelBack = SKSpriteNode(imageNamed: "level_background")
            levelBack.size = CGSize(width: 330, height: 70)
            levelNode.addChild(levelBack)
            
            levelText = .init(text: "\(level)")
            levelText.fontName = "Fredoka-Bold"
            levelText.fontSize = 42
            levelText.fontColor = .white
            levelText.position = CGPoint(x: 0, y: -15)
            levelNode.addChild(levelText)
            
            levelNode.position = CGPoint(x: size.width / 2, y: size.height - 150)
            
            return levelNode
        }
    }
    
    private var movesCount = 0 {
        didSet {
            movesCountLabel.text = "\(movesCount)"
            if movesCount >= 6 {
                movesCountLabel.fontColor = .red
            }
            if movesCount == 9 {
                NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil)
            }
        }
    }
    private var movesCountLabel: SKLabelNode = SKLabelNode(text: "0")
    
    private var pauseBtn: SKSpriteNode = SKSpriteNode(imageNamed: "pause_btn")
    
    override func didMove(to view: SKView) {
        addChild(background)
        
//        if level == 1 {
//            backLevelBtn.alpha = 0.6
//        } else {
//            backLevelBtn.alpha = 1
//        }
//        backLevelBtn.position = CGPoint(x: size.width / 2 - 120, y: size.height - 150)
//        
//        nextLevelBtn.position = CGPoint(x: size.width / 2 + 120, y: size.height - 150)
        
        addChild(levelLabel)
//        addChild(backLevelBtn)
//        addChild(nextLevelBtn)
        
        pauseBtn.position = CGPoint(x: size.width / 2, y: 150)
        pauseBtn.size = CGSize(width: 180, height: 150)
        addChild(pauseBtn)
        
        createMovesLabel()
        
        createGameField()
        
        if level == 1 {
            createTutor()
        }
    }
    
    private func createTutor() {
        let tutorOneText = SKLabelNode(text: "MOVE THE BLOCK")
        tutorOneText.fontName = "Fredoka-Bold"
        tutorOneText.fontSize = 52
        tutorOneText.fontColor = .white
        tutorOneText.position = CGPoint(x: size.width / 2, y: 330)
        addChild(tutorOneText)
        
        let tutorOneText2 = SKLabelNode(text: "TO SORT")
        tutorOneText2.fontName = "Fredoka-Bold"
        tutorOneText2.fontSize = 52
        tutorOneText2.fontColor = .white
        tutorOneText2.position = CGPoint(x: size.width / 2, y: 280)
        addChild(tutorOneText2)
        
        let cursor = SKSpriteNode(imageNamed: "cursor")
        cursor.position = CGPoint(x: size.width / 2 - 70, y: size.height / 2)
        cursor.size = CGSize(width: 62, height: 62)
        cursor.zPosition = 2
        addChild(cursor)
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width / 2 + 70, y: size.height / 2), duration: 2)
        let actionMove2 = SKAction.move(to: CGPoint(x: size.width / 2 - 70, y: size.height / 2), duration: 0.1)
        let seq = SKAction.sequence([actionMove, actionMove2])
        let forever = SKAction.repeatForever(seq)
        cursor.run(forever)
    }
    
    private func createMovesLabel() {
        let movesTitleLabel = SKLabelNode(text: "MOVES:")
        movesTitleLabel.fontName = "Fredoka-Bold"
        movesTitleLabel.fontSize = 82
        movesTitleLabel.fontColor = .white
        movesTitleLabel.position = CGPoint(x: size.width / 2, y: size.height - 330)
        addChild(movesTitleLabel)
        
        movesCountLabel.fontName = "Fredoka-Bold"
        movesCountLabel.fontSize = 82
        movesCountLabel.fontColor = .white
        movesCountLabel.position = CGPoint(x: size.width / 2, y: size.height - 410)
        addChild(movesCountLabel)
    }
    
    private func createGameField() {
        addBlocks(for: gameFieldData)
    }
    
    private var blockNodes = [SKNode]()
    private var starsNode = [SKNode]()
    
    func addBlocks(for data: GameFieldData, extraLevel: Bool = false) {
        blockPositions = [:]
        for blockNode in blockNodes {
            blockNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
        }
        for star in starsNode {
            star.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
        }
        
        let blockSize = CGSize(width: 150, height: 130)
        let spacing: CGFloat = 15  // Основной отступ между блоками

        // Вычисление количества строк и столбцов в зависимости от ориентации
        let (rows, columns): (Int, Int)
        switch data.blockOrientation {
        case .vertical:
            rows = data.initialPositions.count
            columns = data.initialPositions.first?.count ?? 0
        case .horizontal:
            rows = data.initialPositions.first?.count ?? 0
            columns = data.initialPositions.count
        }

        // Вычисление общих размеров поля
        let totalWidth = CGFloat(columns) * blockSize.width + CGFloat(columns - 1) * spacing
        let totalHeight = CGFloat(rows) * blockSize.height + CGFloat(rows - 1) * spacing

        var firstBlockPosition: CGPoint!
        var lastBlockPosition: CGPoint!
        
        var seconColonfirstBlockPosition: CGPoint!
        var secondColonlastBlockPosition: CGPoint!
        
        // Вычисление начальной позиции для центрирования
        var startX = (size.width - totalWidth) / 2
        let startY = (size.height - totalHeight) / 2
        
        if data.blockOrientation == .vertical {
            startX = (size.width - totalWidth) / 2 + 80
        }
        
        for (rowIndex, row) in data.initialPositions.enumerated() {
            for (colIndex, blockColor) in row.enumerated() {
                var blockSrc = "orange_block"
                if blockColor == .blue {
                    blockSrc = "blue_block"
                }
                if extraLevel {
                    blockSrc = "hades_red"
                    if blockColor == .blue {
                        blockSrc = "zeus_blue"
                    }
                    if blockColor == .stone {
                        blockSrc = "stone"
                    }
                }
                let block = SKSpriteNode(imageNamed: blockSrc)
                
                let xPosition: CGFloat
                let yPosition: CGFloat
                
                switch data.blockOrientation {
                case .horizontal:
                    xPosition = startX + CGFloat(colIndex) * (blockSize.width + spacing)
                    yPosition = startY + CGFloat(rowIndex) * (blockSize.height + spacing)
                case .vertical:
                    xPosition = startX + CGFloat(rowIndex) * (blockSize.width + spacing)
                    yPosition = startY + CGFloat(colIndex) * (blockSize.height + spacing)
                }
                
                block.position = CGPoint(x: xPosition, y: yPosition)
                block.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                block.size = blockSize
                block.zPosition = 1
                // block.name = blockSrc
                block.name = "\(rowIndex)*\(colIndex)"
                addChild(block)
                blockNodes.append(block)
                
                blockPositions[block.name!] = blockColor
                
                if rowIndex == 0 && colIndex == 0 {
                    firstBlockPosition = block.position
                }
                if rowIndex == 0 && colIndex == row.count - 1 {
                    lastBlockPosition = block.position
                }
                
                if rowIndex == 1 && colIndex == 0 {
                    seconColonfirstBlockPosition = block.position
                }
                if rowIndex == 1 && colIndex == row.count - 1 {
                    secondColonlastBlockPosition = block.position
                }
            }
        }
        
        if data.colorFirst == .blue {
            let starColorFirst = SKSpriteNode(imageNamed: "star_blue")
            starColorFirst.size = CGSize(width: 52, height: 42)
            starColorFirst.position = firstBlockPosition
            if data.blockOrientation == .horizontal {
                starColorFirst.position.x -= blockSize.width / 2 + 40
            } else {
                starColorFirst.position.y -= blockSize.height / 2 + 40
            }
            
            let starColorLast = SKSpriteNode(imageNamed: "star_blue")
            starColorLast.size = CGSize(width: 52, height: 42)
            starColorLast.position = lastBlockPosition
            if data.blockOrientation == .horizontal {
                starColorLast.position.x += blockSize.width / 2 + 40
            } else {
                starColorLast.position.y += blockSize.height / 2 + 40
            }
            starColorLast.zPosition = 20
            
            addChild(starColorFirst)
            addChild(starColorLast)
            starsNode.append(starColorFirst)
            starsNode.append(starColorLast)
            blockPositions["0*(-1))"] = .blue
            blockPositions["0*4"] = .blue
            
            let secondStarColorFirst = SKSpriteNode(imageNamed: "star_orange")
            secondStarColorFirst.size = CGSize(width: 52, height: 42)
            secondStarColorFirst.position = seconColonfirstBlockPosition
            if data.blockOrientation == .horizontal {
                secondStarColorFirst.position.x -= blockSize.width / 2 + 40
            } else {
                secondStarColorFirst.position.y -= blockSize.height / 2 + 40
            }
            
            addChild(secondStarColorFirst)
            
            let secondStarColorFirst2 = SKSpriteNode(imageNamed: "star_orange")
            secondStarColorFirst2.size = CGSize(width: 52, height: 42)
            secondStarColorFirst2.position = secondColonlastBlockPosition
            if data.blockOrientation == .horizontal {
                secondStarColorFirst2.position.x += blockSize.width / 2 + 40
            } else {
                secondStarColorFirst2.position.y += blockSize.height / 2 + 40
            }
            blockPositions["1*(-1))"] = .orange
            blockPositions["1*4"] = .orange
            
            addChild(secondStarColorFirst2)
            starsNode.append(secondStarColorFirst)
            starsNode.append(secondStarColorFirst2)
        } else {
            let starColorFirst = SKSpriteNode(imageNamed: "star_orange")
            starColorFirst.size = CGSize(width: 52, height: 42)
            starColorFirst.position = firstBlockPosition
            if data.blockOrientation == .horizontal {
                starColorFirst.position.x -= blockSize.width / 2 + 40
            } else {
                starColorFirst.position.y -= blockSize.height / 2 + 40
            }
            
            let starColorLast = SKSpriteNode(imageNamed: "star_orange")
            starColorLast.size = CGSize(width: 52, height: 42)
            starColorLast.position = lastBlockPosition
            if data.blockOrientation == .horizontal {
                starColorLast.position.x += blockSize.width / 2 + 40
            } else {
                starColorLast.position.y += blockSize.height / 2 + 40
            }
            starColorLast.zPosition = 20
            
            addChild(starColorFirst)
            addChild(starColorLast)
            starsNode.append(starColorFirst)
            starsNode.append(starColorLast)
            
            let secondStarColorFirst = SKSpriteNode(imageNamed: "star_blue")
            secondStarColorFirst.size = CGSize(width: 52, height: 42)
            secondStarColorFirst.position = seconColonfirstBlockPosition
            if data.blockOrientation == .horizontal {
                secondStarColorFirst.position.x -= blockSize.width / 2 + 40
            } else {
                secondStarColorFirst.position.y -= blockSize.height / 2 + 40
            }
            blockPositions["0*(-1))"] = .orange
            blockPositions["0*4"] = .orange
            
            addChild(secondStarColorFirst)
            
            let secondStarColorFirst2 = SKSpriteNode(imageNamed: "star_blue")
            secondStarColorFirst2.size = CGSize(width: 52, height: 42)
            secondStarColorFirst2.position = secondColonlastBlockPosition
            if data.blockOrientation == .horizontal {
                secondStarColorFirst2.position.x += blockSize.width / 2 + 40
            } else {
                secondStarColorFirst2.position.y += blockSize.height / 2 + 40
            }
            blockPositions["1*(-1))"] = .blue
            blockPositions["1*4"] = .blue
            
            addChild(secondStarColorFirst2)
            starsNode.append(secondStarColorFirst)
            starsNode.append(secondStarColorFirst2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtLocation = nodes(at: location)
        
        if nodesAtLocation.contains(pauseBtn) {
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("pause_content"), object: nil)
            return
        }
        
        if let touchedNode = nodesAtLocation.first as? SKSpriteNode, touchedNode.name != nil {
            selectedNode = touchedNode
            originalPosition = touchedNode.position
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = selectedNode else { return }
        let location = touch.location(in: self)
        node.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = selectedNode, let originalPosition = originalPosition else { return }
        
        let location = node.position
        let nodesAtLocation = nodes(at: location)
        
        if let targetNode = nodesAtLocation.first as? SKSpriteNode, targetNode != node, let targetName = targetNode.name, let nodeName = node.name {
            // Обновляем позиции узлов с анимацией
            let moveToTarget = SKAction.move(to: targetNode.position, duration: 0.2)
            let moveToOriginal = SKAction.move(to: originalPosition, duration: 0.2)
            
            node.run(moveToTarget)
            targetNode.run(moveToOriginal)
            
            movesCount += 1
            
            // Меняем цвета блоков в словаре
            let tempColor = blockPositions[nodeName]
            blockPositions[nodeName] = blockPositions[targetName]
            blockPositions[targetName] = tempColor
            let tempNodeName = node.name
            node.name = targetName
            targetNode.name = tempNodeName
            
            // Проверка линий после перемещения
            if checkAllBlocksInLinesAreSameColor() {
                if level % 3 == 0 {
                    createExtraLevel()
                } else {
                    NotificationCenter.default.post(name: Notification.Name("all_matched"), object: nil)
                }
            }
        } else {
            node.position = originalPosition
        }
        
        selectedNode = nil
        self.originalPosition = nil
    }
    
    private var extraLevel = false
    private var extraLevelData: GameFieldData? = nil
    
    func checkAllBlocksInLinesAreSameColor() -> Bool {
        var group: [String: [BlockColor]] = [:]
        
        for (key, value) in blockPositions {
            let comp = key.components(separatedBy: "*")
            let keyColumn = comp[0]
            let line = comp[1]
            if group[keyColumn] == nil {
                group[keyColumn] = []
            }
            if extraLevel {
                if !line.contains("(") && !line.contains("-") && !line.contains("4") {
                    group[keyColumn]!.append(value)
                }
            } else {
                group[keyColumn]!.append(value)
            }
        }
        
        if extraLevel {
            if let gameData = extraLevelData?.correctPositions {
                for (row, _) in group {
                    let rowLine = Int(row)!
                    let rowColors = group[row]!
                    let extraLevelDataLine = gameData[rowLine]
                    for rowColor in rowColors {
                        if !extraLevelDataLine.contains(rowColor) {
                            return false
                        }
                    }
                }
            }
        } else {
            for (_, colors) in group {
                var prevColor: BlockColor? = nil
                for color in colors {
                    if prevColor != nil && prevColor != color {
                        return false
                    }
                    prevColor = color
                }
            }
        }
        
        return true
    }
    
    func checkAllElementsEqual<T: Equatable>(_ elements: [T]) -> Bool {
        guard let firstElement = elements.first else { return true }
        return !elements.contains { $0 != firstElement }
    }
    
    private func createExtraLevel() {
        extraLevel = true
        extraLevelData = extras[Int.random(in: 0..<extras.count)]
        addBlocks(for: extraLevelData!, extraLevel: true)
        levelText.text = "extra"
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: BlockuerScene(level: 1))
            .ignoresSafeArea()
    }
}
