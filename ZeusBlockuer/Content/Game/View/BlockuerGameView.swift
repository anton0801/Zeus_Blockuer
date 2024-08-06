import SwiftUI
import SpriteKit

struct BlockuerGameView: View {
    
    var level: Int
    @State var levelForUse: Int!
    @State var scene: BlockuerScene!
    
    @EnvironmentObject var levelsManager: LevelsManager
    
    @StateObject var viewModel: GameViewModel = GameViewModel()
    
    init(level: Int) {
        self.level = level
    }
    
    var body: some View {
        ZStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            switch (viewModel.gameActiveView) {
            case .win:
                BlockuerGameWinView {
                    scene = scene.restartGame()
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.gameActiveView = .game
                    }
                } nextLevelAction: {
                    scene = scene.restartGame(level: level + 1)
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.gameActiveView = .game
                    }
                }
            case .over:
                BlockuerGameOverView {
                    scene = scene.restartGame()
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.gameActiveView = .game
                    }
                }
            case .pause:
                BlockuerGamePauseView {
                    scene = scene.restartGame()
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.gameActiveView = .game
                    }
                } continueGame: {
                    scene.isPaused = false
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.gameActiveView = .game
                    }
                }
            default:
                EmptyView()
            }
        }
        .onAppear {
            self.levelForUse = level
            self.scene = BlockuerScene(level: self.levelForUse)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause_content")), perform: { _ in
            withAnimation {
                viewModel.gameActiveView = .pause
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over")), perform: { _ in
            withAnimation {
                viewModel.gameActiveView = .over
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("all_matched")), perform: { _ in
            levelsManager.levelForPlay += 1
            UserDefaults.standard.set(level + 1, forKey: "level_for_pass")
            withAnimation {
                viewModel.gameActiveView = .win
            }
        })
    }
    
}

#Preview {
    BlockuerGameView(level: 1)
        .environmentObject(LevelsManager())
}

class GameViewModel: ObservableObject {
    
    @Published var gameActiveView: GameView = .game
    
}

enum GameView {
    case game, win, over, pause
}
