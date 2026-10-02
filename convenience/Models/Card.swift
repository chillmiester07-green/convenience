import Foundation

enum BoardSide: String, CaseIterable {
    case left
    case right

}

enum CardState {
    case covered
    case revealed
    case matched
}

struct Card: Identifiable {
    let id = UUID()
    /// Asset catalog name of the picture hidden under this card.
    let imageName: String
    let side: BoardSide
    /// Asset catalog name of the cover image (the pack's card cover).
    let coverName: String
    var state = CardState.covered
    /// Incremented every time the card should shake (a wrong guess).
    var shakeCount = 0
}
