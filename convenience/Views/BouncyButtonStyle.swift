import SwiftUI

/// Squishes down while pressed and springs back, for a playful tap feel.
struct BouncyButtonStyle: ButtonStyle {
    var pressedScale = 0.9

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(.spring(duration: 0.3, bounce: 0.6), value: configuration.isPressed)
    }
}
