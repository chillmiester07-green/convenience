import SwiftUI

/// Big celebration overlay shown when every pair has been found.
struct LevelCompleteView: View {
    @Environment(GameModel.self) private var game
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    @State private var starsPopped = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            if !reduceMotion {
                RaysView()
                ConfettiView()
            }

            VStack(spacing: 20) {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: index == 1 ? 90 : 64))
                            .foregroundStyle(.yellow.gradient)
                            .shadow(color: .orange, radius: 10)
                            .scaleEffect(starsPopped ? 1 : 0.01)
                            .rotationEffect(.degrees(starsPopped ? 0 : -180))
                            .offset(y: index == 1 ? -16 : 0)
                            .animation(.spring(duration: 0.7, bounce: 0.6).delay(0.25 + 0.2 * Double(index)), value: starsPopped)
                    }
                }

                Text("Level \(game.level)\nComplete!")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .shadow(color: .pink, radius: 0, x: 0, y: 5)
                    .minimumScaleFactor(0.5)

                Text("You found all \(game.pairsInLevel) pairs in \(game.tries) tries!")
                    .font(.title3.weight(.bold))
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Button {
                    if game.isFinalSize {
                        game.showPackSelect()
                    } else {
                        game.nextLevel()
                    }
                } label: {
                    Label(nextLevelText, systemImage: "arrow.right.circle.fill")
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 16)
                        .background(.green.gradient, in: .capsule)
                        .shadow(color: .black.opacity(0.3), radius: 8, y: 6)
                }
                .buttonStyle(BouncyButtonStyle())
                .padding(.top, 8)
            }
            .padding(32)
            .scaleEffect(appeared ? 1 : 0.2)
            .rotationEffect(.degrees(appeared ? 0 : -15))
            .opacity(appeared ? 1 : 0)
        }
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear {
            withAnimation(.spring(duration: 0.8, bounce: 0.55)) {
                appeared = true
            }
            starsPopped = true
        }
        .accessibilityElement(children: .contain)
    }

    private var nextLevelText: String {
        game.isFinalSize ? "Choose a Pack" : "Next Level: \(game.pairsInLevel + GameModel.pairsAddedPerLevel) pairs"
    }
}

/// Slowly spinning sunburst behind the celebration.
private struct RaysView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let angle = timeline.date.timeIntervalSinceReferenceDate * 20
            Canvas { context, size in
                let centre = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = hypot(size.width, size.height)
                let rayCount = 16
                for index in 0..<rayCount where index.isMultiple(of: 2) {
                    var path = Path()
                    let start = Angle.degrees(angle + Double(index) * 360 / Double(rayCount))
                    let end = Angle.degrees(angle + Double(index + 1) * 360 / Double(rayCount))
                    path.move(to: centre)
                    path.addArc(center: centre, radius: radius, startAngle: start, endAngle: end, clockwise: false)
                    path.closeSubpath()
                    context.fill(path, with: .color(.white.opacity(0.18)))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
