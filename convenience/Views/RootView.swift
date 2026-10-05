import SwiftUI

struct RootView: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        ZStack {
            GradientBackground(level: backgroundLevel)

            switch game.phase {
            case .menu:
                MenuView()
                    .transition(.scale.combined(with: .opacity))
            case .packSelect:
                PackSelectView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .playing, .levelComplete, .failed:
                GameView()
                    .transition(.opacity)
            }

            if game.phase == .levelComplete {
                LevelCompleteView()
                    .transition(.opacity)
            }

            if game.phase == .failed {
                TimeUpView()
                    .transition(.opacity)
            }
        }
        .animation(.spring(duration: 0.6, bounce: 0.3), value: game.phase)
    }

    private var backgroundLevel: Int {
        switch game.phase {
        case .menu: 2
        case .packSelect: 4
        case .playing, .levelComplete, .failed: game.level + 4
        }
    }
}
