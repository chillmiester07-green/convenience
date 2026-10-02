import SwiftUI

struct GameView: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        VStack(spacing: 12) {
            HUDView()

            Text("Uncover one picture on each side. Can you find the match?")
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 20) {
                BoardView(cards: game.leftCards, onSelect: game.select)
                    .id(game.level)
                Capsule()
                    .fill(.white.opacity(0.5))
                    .frame(width: 4)
                    .padding(.vertical, 20)
                    .accessibilityHidden(true)
                BoardView(cards: game.rightCards, onSelect: game.select)
                    .id(game.level)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .sensoryFeedback(.success, trigger: game.matchCount)
        .sensoryFeedback(.warning, trigger: game.missCount)
    }
}
