import Foundation

struct GameFieldData {
    var countBlocks: Int
    var blockOrientation: BlockOrientaiton
    var colorFirst: BlockColor
    var initialPositions: [[BlockColor]]
    var correctPositions: [[BlockColor]]? = nil
}

enum BlockColor {
    case blue, orange, stone
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

let extras = [
    GameFieldData(countBlocks: 6, blockOrientation: .horizontal, colorFirst: .blue, initialPositions: [
        [.blue, .stone, .orange],
        [.blue, .blue, .orange]
    ], correctPositions: [
        [.blue, .stone, .blue],
        [.orange, .blue, .orange]
    ]),
//    GameFieldData(countBlocks: 6, blockOrientation: .vertical, colorFirst: .orange, initialPositions: [
//        [.orange, .blue],
//        [.orange, .stone],
//        [.orange, .orange]
//    ], correctPositions: [
//        [.orange, .orange],
//        [.blue, .stone],
//        [.orange, .orange]
//    ])
]
