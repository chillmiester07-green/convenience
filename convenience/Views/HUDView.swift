import SwiftUI

struct HUDView: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        HStack(spacing: 12) {
            Button("Choose a pack", systemImage: "house.fill") {
                game.showPackSelect()
            }
            .labelStyle(.iconOnly)
            .font(.title2.weight(.bold))
            .foregroundStyle(.white)
            .frame(width: 48, height: 48)
            .background(.white.opacity(0.25), in: .circle)
            .buttonStyle(BouncyButtonStyle())

            Spacer()

            pill("\(game.level)", systemImage: "flag.fill")
                .accessibilityLabel("Level \(game.level)")
            pill("\(game.matchedPairs)/\(game.pairsInLevel)", systemImage: "star.fill")
                .accessibilityLabel("\(game.matchedPairs) of \(game.pairsInLevel) pairs found")
            pill("\(game.tries)", systemImage: "hand.tap.fill")
                .accessibilityLabel("\(game.tries) tries")
        }
        .padding(.horizontal)
    }

    private func pill(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.headline.weight(.heavy))
            .fontDesign(.rounded)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.black.opacity(0.22), in: .capsule)
            .contentTransition(.numericText())
            .animation(.bouncy, value: text)
    }
}
