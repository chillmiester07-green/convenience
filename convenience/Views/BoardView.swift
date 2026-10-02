import SwiftUI

/// Lays one side's cards out in the grid that makes the cards as large as possible.
struct BoardView: View {
    let cards: [Card]
    let onSelect: (Card) -> Void

    private let spacing = 8.0
    /// Fraction of each grid cell left empty around the card so cards sit smaller on screen.
    private static let inset = 0.06

    var body: some View {
        GeometryReader { proxy in
            let layout = bestLayout(in: proxy.size)
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(0..<layout.rows, id: \.self) { row in
                    GridRow {
                        ForEach(Array(rowCards(row, columns: layout.columns).enumerated()), id: \.element.id) { column, card in
                            CardView(card: card, delay: Double(row * layout.columns + column) * 0.08) { onSelect(card) }
                                .padding(layout.cell * Self.inset)
                                .frame(width: layout.cell, height: layout.cell)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func rowCards(_ row: Int, columns: Int) -> ArraySlice<Card> {
        let start = row * columns
        return cards[start..<min(start + columns, cards.count)]
    }

    private func bestLayout(in size: CGSize) -> (columns: Int, rows: Int, cell: Double) {
        var best = (columns: 1, rows: max(cards.count, 1), cell: 0.0)
        for columns in 1...max(cards.count, 1) {
            let rows = (cards.count + columns - 1) / columns
            let width = (size.width - spacing * Double(columns - 1)) / Double(columns)
            let height = (size.height - spacing * Double(rows - 1)) / Double(rows)
            let cell = max(min(width, height), 0)
            if cell > best.cell {
                best = (columns, rows, cell)
            }
        }
        return best
    }
}
