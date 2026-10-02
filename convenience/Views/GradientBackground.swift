import SwiftUI

/// Colourful, slowly drifting gradient that changes with every level.
struct GradientBackground: View {
    let level: Int

    private static let palettes: [[Color]] = [
        [.pink, .orange, .yellow],
        [.indigo, .purple, .pink],
        [.teal, .mint, .yellow],
        [.blue, .cyan, .mint],
        [.purple, .blue, .cyan],
        [.red, .orange, .pink],
        [.green, .mint, .cyan],
        [.orange, .pink, .purple],
    ]

    private var colors: [Color] {
        Self.palettes[(level - 1) % Self.palettes.count]
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            LinearGradient(
                colors: colors,
                startPoint: UnitPoint(x: 0.5 + 0.5 * sin(t / 6), y: 0),
                endPoint: UnitPoint(x: 0.5 - 0.5 * sin(t / 6), y: 1)
            )
            .overlay {
                RadialGradient(
                    colors: [.white.opacity(0.35), .clear],
                    center: .top,
                    startRadius: 0,
                    endRadius: 500
                )
            }
        }
        .animation(.easeInOut(duration: 1), value: level)
        .ignoresSafeArea()
    }
}
