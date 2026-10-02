import SwiftUI

/// A themed set of eight pictures plus the card cover that goes with it.
struct Pack: Identifiable {
    let id: Int
    let title: String
    /// Asset catalog name of the cover shown on the cards and on the pack screen.
    let coverName: String
    let imageNames: [String]
    /// Name of the sound data set in the asset catalog, played when a level is completed.
    let soundName: String
    let colors: [Color]

    /// Every pack folder is a namespaced asset group, so names need a `packN/` prefix.
    private static func names(_ ids: ClosedRange<Int>, pack: Int) -> [String] {
        ids.map { "pack\(pack)/\($0)" }
    }

    static let all = [
        Pack(id: 1, title: "K POP", coverName: "pack1/pack1", imageNames: names(10...17, pack: 1), soundName: "pack1/1", colors: [.green, .mint]),
        Pack(id: 2, title: "Music", coverName: "pack2/pack2", imageNames: names(21...28, pack: 2), soundName: "pack2/2", colors: [.purple, .pink]),
        Pack(id: 3, title: "Star Wars", coverName: "pack3/pack3", imageNames: names(31...38, pack: 3), soundName: "pack3/3", colors: [.orange, .yellow]),
        Pack(id: 4, title: "Pack 4", coverName: "pack4/pack4", imageNames: names(41...48, pack: 4), soundName: "pack4/4", colors: [.blue, .cyan]),
    ]
}
