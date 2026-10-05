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
    /// Plain card back for packs whose cover would give the pictures away; falls back to the cover.
    var backName: String?

    var cardBackName: String { backName ?? coverName }

    /// Every pack folder is a namespaced asset group, so names need a `packN/` prefix.
    private static func names(_ ids: ClosedRange<Int>, pack: Int) -> [String] {
        ids.map { "pack\(pack)/\($0)" }
    }

    static let all = [
        Pack(id: 1, title: "K POP", coverName: "pack1/pack1", imageNames: names(10...17, pack: 1), soundName: "pack1/1", colors: [.green, .mint]),
        Pack(id: 2, title: "Music", coverName: "pack2/pack2", imageNames: names(21...28, pack: 2), soundName: "pack2/2", colors: [.purple, .pink]),
        Pack(id: 3, title: "Star Wars", coverName: "pack3/pack3", imageNames: names(31...38, pack: 3), soundName: "pack3/3", colors: [.orange, .yellow]),
        Pack(id: 4, title: "Pack 4", coverName: "pack4/pack4", imageNames: names(41...48, pack: 4), soundName: "pack4/4", colors: [.blue, .cyan]),
        Pack(id: 5, title: "Animals", coverName: "pack5/pack5", imageNames: names(51...58, pack: 5), soundName: "pack5/5", colors: [.orange, .red], backName: "pack5/back5"),
        Pack(id: 6, title: "Ocean", coverName: "pack6/pack6", imageNames: names(61...68, pack: 6), soundName: "pack6/6", colors: [.cyan, .blue], backName: "pack6/back6"),
        Pack(id: 7, title: "Space", coverName: "pack7/pack7", imageNames: names(71...78, pack: 7), soundName: "pack7/7", colors: [.indigo, .purple], backName: "pack7/back7"),
        Pack(id: 8, title: "Robots", coverName: "pack8/pack8", imageNames: names(81...88, pack: 8), soundName: "pack8/8", colors: [.green, .teal], backName: "pack8/back8"),
        Pack(id: 9, title: "Monsters", coverName: "pack9/pack9", imageNames: names(91...98, pack: 9), soundName: "pack9/9", colors: [.purple, .indigo], backName: "pack9/back9"),
        Pack(id: 10, title: "Yummy Treats", coverName: "pack10/pack10", imageNames: names(101...108, pack: 10), soundName: "pack10/10", colors: [.pink, .orange], backName: "pack10/back10"),
        Pack(id: 11, title: "Aliens", coverName: "pack11/pack11", imageNames: names(111...118, pack: 11), soundName: "pack11/11", colors: [.mint, .blue], backName: "pack11/back11"),
        Pack(id: 12, title: "Happy Shapes", coverName: "pack12/pack12", imageNames: names(121...128, pack: 12), soundName: "pack12/12", colors: [.yellow, .orange], backName: "pack12/back12"),
    ]
}
