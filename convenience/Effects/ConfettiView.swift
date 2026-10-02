import SwiftUI

/// Full-screen confetti rain drawn with a single Canvas.
struct ConfettiView: View {
    private struct Piece {
        let x: Double
        let delay: Double
        let speed: Double
        let size: Double
        let sway: Double
        let swayRate: Double
        let spin: Double
        let color: Color
        let isRound: Bool
    }

    private static let colors: [Color] = [.yellow, .pink, .orange, .mint, .cyan, .white, .purple, .red, .green]

    @State private var pieces: [Piece] = (0..<140).map { _ in
        Piece(
            x: .random(in: 0...1),
            delay: .random(in: 0...2.5),
            speed: .random(in: 0.18...0.4),
            size: .random(in: 8...16),
            sway: .random(in: 10...40),
            swayRate: .random(in: 1...3),
            spin: .random(in: 2...8),
            color: colors.randomElement() ?? .yellow,
            isRound: Bool.random()
        )
    }
    @State private var start = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(start)
                for piece in pieces {
                    let t = elapsed - piece.delay
                    guard t > 0 else { continue }
                    // Loop each piece so confetti keeps falling while the overlay is up.
                    let fall = (t * piece.speed).truncatingRemainder(dividingBy: 1.2)
                    let point = CGPoint(
                        x: piece.x * size.width + sin(t * piece.swayRate) * piece.sway,
                        y: (fall - 0.1) * size.height
                    )
                    var layer = context
                    layer.translateBy(x: point.x, y: point.y)
                    layer.rotate(by: .radians(t * piece.spin))
                    layer.scaleBy(x: 1, y: cos(t * piece.spin))
                    let rect = CGRect(x: -piece.size / 2, y: -piece.size / 2, width: piece.size, height: piece.size * 0.6)
                    let path = piece.isRound ? Path(ellipseIn: rect) : Path(roundedRect: rect, cornerRadius: 2)
                    layer.fill(path, with: .color(piece.color))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
