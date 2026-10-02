import SwiftUI

struct PackSelectView: View {
    @Environment(GameModel.self) private var game
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Back", systemImage: "chevron.left") {
                    game.goToMenu()
                }
                .labelStyle(.iconOnly)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.white.opacity(0.25), in: .circle)
                .buttonStyle(BouncyButtonStyle())
                Spacer()
            }
            .padding(.horizontal)

            Text("Pick a pack!")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 4, y: 4)
                .accessibilityAddTraits(.isHeader)

            GeometryReader { proxy in
                let isWide = proxy.size.width > proxy.size.height
                let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: isWide ? 4 : 2)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Pack.all) { pack in
                            PackCoverButton(pack: pack, appeared: appeared) {
                                game.startNewGame(with: pack)
                            }
                        }
                    }
                    .padding()
                    .frame(minHeight: proxy.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .onAppear {
            appeared = true
        }
    }
}

/// A floating, gently wobbling pack cover that pops in and squishes when pressed.
private struct PackCoverButton: View {
    let pack: Pack
    let appeared: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var floating = false

    private var delay: Double { Double(pack.id) * 0.12 }

    var body: some View {
        Button(action: action) {
            Color.clear
                .aspectRatio(4 / 3, contentMode: .fit)
                .overlay {
                    Image(pack.coverName)
                        .resizable()
                        .scaledToFill()
                }
                .overlay(alignment: .bottom) {
                    Text(pack.title)
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(LinearGradient(colors: pack.colors, startPoint: .leading, endPoint: .trailing).opacity(0.9))
                }
                .clipShape(.rect(cornerRadius: 26, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .strokeBorder(.white, lineWidth: 5)
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "sparkle")
                        .font(.title)
                        .foregroundStyle(.yellow)
                        .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion)
                        .padding(10)
                }
                .shadow(color: pack.colors[0].opacity(0.8), radius: floating ? 18 : 6, y: floating ? 14 : 4)
        }
        .buttonStyle(BouncyButtonStyle(pressedScale: 0.88))
        .rotationEffect(.degrees(floating ? 2.5 : -2.5))
        .offset(y: floating ? -8 : 8)
        .scaleEffect(appeared ? 1 : 0.1)
        .rotationEffect(.degrees(appeared ? 0 : -25))
        .opacity(appeared ? 1 : 0)
        .animation(.spring(duration: 0.7, bounce: 0.6).delay(delay), value: appeared)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.6 + delay).repeatForever(autoreverses: true).delay(delay)) {
                floating = true
            }
        }
        .accessibilityLabel(pack.title)
        .accessibilityHint("Double tap to play with this pack")
    }
}
