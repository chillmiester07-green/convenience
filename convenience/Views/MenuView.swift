import SwiftUI

struct MenuView: View {
    @Environment(GameModel.self) private var game
    @State private var bounce = false

    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
                .symbolEffect(.bounce, options: .repeating.speed(0.4), value: bounce)

            Text("Convenience\nMatch!")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 4, y: 4)
                .scaleEffect(bounce ? 1.06 : 0.96)
                .rotationEffect(.degrees(bounce ? 3 : -3))

            Text("Uncover a picture on the left, then find its twin on the right!")
                .font(.title3.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)

            Button {
                game.showPackSelect()
            } label: {
                Label("Play", systemImage: "play.fill")
                    .font(.system(.title, design: .rounded, weight: .heavy))
                    .foregroundStyle(.pink)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .background(.white, in: .capsule)
                    .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
            }
            .buttonStyle(BouncyButtonStyle())
        }
        .padding()
        .onAppear {
            bounce = true
        }
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: bounce)
    }
}
