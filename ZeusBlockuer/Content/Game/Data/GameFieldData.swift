import Foundation

struct GameFieldData {
    var countBlocks: Int
    var blockOrientation: BlockOrientaiton
    var colorFirst: BlockColor
    var initialPositions: [[BlockColor]]
}

enum BlockColor {
    case blue, orange
}

enum BlockOrientaiton {
    case horizontal, vertical
}


let gameFieldDataItems = [
    GameFieldData(countBlocks: 4, blockOrientation: .vertical, colorFirst: .blue, initialPositions: [[.blue, .orange], [.orange, .blue]]),
    GameFieldData(countBlocks: 6, blockOrientation: .horizontal, colorFirst: .orange, initialPositions: [
        [.blue, .orange, .blue], [.orange, .blue, .orange]
    ]),
    GameFieldData(countBlocks: 6, blockOrientation: .horizontal, colorFirst: .orange, initialPositions: [
        [.blue, .orange, .blue], [.orange, .blue, .orange]
    ]),
]
