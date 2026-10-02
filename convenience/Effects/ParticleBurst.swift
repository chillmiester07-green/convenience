import SwiftUI

/// A one-shot burst of stars and sparkles that flies outward from the centre.
struct ParticleBurst: View {
    private struct Particle: Identifiable {
        let id: Int
        let angle: Double
        let distance: Double
        let size: Double
        let color: Color
        let isStar: Bool
        let spin: Double
    }

    private static let colors: [Color] = [.yellow, .pink, .orange, .mint, .cyan, .white, .purple]

    @State private var particles: [Particle] = (0..<22).map { index in
        Particle(
            id: index,
            angle: Double(index) / 22 * 2 * .pi + .random(in: -0.15...0.15),
            distance: .random(in: 55...120),
            size: .random(in: 10...22),
            color: colors.randomElement() ?? .yellow,
            isStar: Bool.random(),
            spin: .random(in: -360...360)
        )
    }
    @State private var progress = 0.0

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(systemName: particle.isStar ? "star.fill" : "circle.fill")
                    .font(.system(size: particle.size))
                    .foregroundStyle(particle.color)
                    .rotationEffect(.degrees(particle.spin * progress))
                    .scaleEffect(1 - progress * 0.6)
                    .offset(
                        x: cos(particle.angle) * particle.distance * progress,
                        y: sin(particle.angle) * particle.distance * progress
                    )
                    .opacity(1 - progress)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                progress = 1
            }
        }
    }
}
