import SwiftUI

/// Gradient progress bar along the top of a level that drains as time runs out.
struct TimerBarView: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        TimelineView(.animation) { timeline in
            let remaining = game.timeRemainingFraction(at: timeline.date)
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(.black.opacity(0.25))
                    Capsule()
                        .fill(LinearGradient(
                            colors: [.green, .yellow, .orange, .red],
                            startPoint: .trailing,
                            endPoint: .leading
                        ))
                        // Gradient is sized to the full bar so the colour shifts as it drains.
                        .frame(width: proxy.size.width)
                        .mask(alignment: .leading) {
                            Capsule().frame(width: proxy.size.width * remaining)
                        }
                        .shadow(color: .white.opacity(0.35), radius: 4)
                }
            }
            .scaleEffect(y: remaining < 0.25 && remaining > 0 ? 1.0 + 0.25 * pulse(timeline.date) : 1)
        }
        .frame(height: 16)
        .overlay(Capsule().strokeBorder(.white.opacity(0.5), lineWidth: 2))
        .accessibilityElement()
        .accessibilityLabel("Time remaining")
    }

    private func pulse(_ date: Date) -> Double {
        (sin(date.timeIntervalSinceReferenceDate * 10) + 1) / 2
    }
}
