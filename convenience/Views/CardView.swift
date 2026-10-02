import SwiftUI

/// One tappable card. Flips from its cover to the hidden picture when selected.
struct CardView: View {
    let card: Card
    /// Seconds to wait before this card pops in, so the board fills in a wave.
    let delay: Double
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    @State private var floating = false

    var body: some View {
        Button(action: action) {
            FlippingFace(isFaceUp: card.state != .covered, card: card)
                .animation(.spring(duration: 0.55, bounce: 0.35), value: card.state)
        }
        .buttonStyle(BouncyButtonStyle(pressedScale: 0.85))
        .overlay {
            if card.state == .matched {
                ParticleBurst()
            }
        }
        .scaleEffect(card.state == .matched ? 1.06 : 1)
        .animation(.spring(duration: 0.5, bounce: 0.6), value: card.state == .matched)
        .keyframeAnimator(initialValue: 0.0, trigger: card.shakeCount) { content, angle in
            content.rotationEffect(.degrees(angle))
        } keyframes: { _ in
            KeyframeTrack {
                LinearKeyframe(0, duration: 0.01)
                SpringKeyframe(-10, duration: 0.1)
                SpringKeyframe(10, duration: 0.1)
                SpringKeyframe(-6, duration: 0.1)
                SpringKeyframe(0, duration: 0.15)
            }
        }
        .rotationEffect(.degrees(floating ? 2 : -2))
        .offset(y: floating ? -4 : 4)
        .scaleEffect(appeared ? 1 : 0.1)
        .rotationEffect(.degrees(appeared ? 0 : -25))
        .opacity(appeared ? 1 : 0)
        .animation(.spring(duration: 0.7, bounce: 0.6).delay(delay), value: appeared)
        .onAppear {
            appeared = true
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.4 + delay.truncatingRemainder(dividingBy: 0.6)).repeatForever(autoreverses: true).delay(delay)) {
                floating = true
            }
        }
        .disabled(card.state != .covered)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(card.state == .covered ? "Double tap to uncover" : "")
    }

    private var accessibilityLabel: String {
        let side = card.side == .left ? "Left" : "Right"
        switch card.state {
        case .covered: return "\(side) card, covered"
        case .revealed: return "\(side) card, uncovered"
        case .matched: return "\(side) card, matched"
        }
    }
}

/// Animatable two-sided card: the cover shows below 90 degrees, the picture above.
private struct FlippingFace: View, Animatable {
    var angle: Double
    let card: Card

    init(isFaceUp: Bool, card: Card) {
        angle = isFaceUp ? 180 : 0
        self.card = card
    }

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    var body: some View {
        ZStack {
            if angle < 90 {
                cover
            } else {
                picture
                    .rotation3DEffect(.degrees(180), axis: (0, 1, 0))
            }
        }
        .rotation3DEffect(.degrees(angle), axis: (0, 1, 0), perspective: 0.5)
        .scaleEffect(1 + 0.18 * sin(angle * .pi / 180))
    }

    private var cover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(coverGradient)
            Color.clear
                .overlay {
                    Image(card.coverName)
                        .resizable()
                        .scaledToFill()
                }
                .clipShape(.rect(cornerRadius: 22, style: .continuous))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(sideColor, lineWidth: 4)
        }
        .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
    }

    private var picture: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.white.opacity(0.9))
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .padding(10)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(card.state == .matched ? Color.green : .white, lineWidth: card.state == .matched ? 5 : 3)
        }
        .overlay(alignment: .topTrailing) {
            if card.state == .matched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white, .green)
                    .offset(x: 6, y: -6)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .shadow(color: card.state == .matched ? .green.opacity(0.7) : .black.opacity(0.25), radius: card.state == .matched ? 12 : 6, y: 4)
    }

    private var sideColor: Color {
        card.side == .left ? .cyan : .pink
    }

    private var coverGradient: LinearGradient {
        let colors: [Color] = card.side == .left ? [.blue, .cyan] : [.pink, .orange]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
