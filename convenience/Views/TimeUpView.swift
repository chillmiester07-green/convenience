import SwiftUI

/// Overlay shown when the timer runs out before every pair is found.
struct TimeUpView: View {
    @Environment(GameModel.self) private var game
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "hourglass.bottomhalf.filled")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .shadow(color: .red, radius: 10)

                Text("Bad Luck!")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .red, radius: 0, x: 0, y: 5)
                    .minimumScaleFactor(0.5)

                Text("Time ran out. You found \(game.matchedPairs) of \(game.pairsInLevel) pairs.")
                    .font(.title3.weight(.bold))
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Button {
                    game.retryLevel()
                } label: {
                    Label("Retry Level", systemImage: "arrow.counterclockwise.circle.fill")
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 16)
                        .background(.orange.gradient, in: .capsule)
                        .shadow(color: .black.opacity(0.3), radius: 8, y: 6)
                }
                .buttonStyle(BouncyButtonStyle())
                .padding(.top, 8)
            }
            .padding(32)
            .scaleEffect(appeared ? 1 : 0.2)
            .opacity(appeared ? 1 : 0)
        }
        .sensoryFeedback(.error, trigger: appeared)
        .onAppear {
            withAnimation(.spring(duration: 0.7, bounce: 0.5)) {
                appeared = true
            }
        }
        .accessibilityElement(children: .contain)
    }
}
