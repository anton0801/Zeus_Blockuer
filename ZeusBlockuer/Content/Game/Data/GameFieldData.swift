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
        [.blue, .orange, .blue], [.blue, .blue, .orange]
    ]),
    GameFieldData(countBlocks: 6, blockOrientation: .vertical, colorFirst: .blue, initialPositions: [
        [.blue, .orange], [.blue, .orange], [.orange, .blue]
    ]),
    GameFieldData(countBlocks: 4, blockOrientation: .vertical, colorFirst: .orange, initialPositions: [
        [.orange, .blue], [.orange, .blue]
    ]),
    GameFieldData(countBlocks: 6, blockOrientation: .horizontal, colorFirst: .blue, initialPositions: [
        [.orange, .orange, .blue], [.blue, .orange, .blue]
    ]),
    GameFieldData(countBlocks: 4, blockOrientation: .horizontal, colorFirst: .blue, initialPositions: [
        [.orange, .orange], [.blue, .orange]
    ]),
]
