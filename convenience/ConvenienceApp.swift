import SwiftUI

@main
struct ConvenienceApp: App {
    @State private var game = GameModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(game)
                .statusBarHidden()
        }
    }
}
