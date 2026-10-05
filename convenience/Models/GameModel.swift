import Observation
import SwiftUI

enum GamePhase {
    case menu
    case packSelect
    case playing
    case levelComplete
    case failed
}

@Observable
final class GameModel {
    static let firstLevelPairs = 4
    static let pairsAddedPerLevel = 1
    static let firstLevelSeconds = 15.0
    static let secondsAddedPerLevel = 5.0

    private(set) var phase = GamePhase.menu
    private(set) var level = 1
    private(set) var pack = Pack.all[0]
    private(set) var leftCards = [Card]()
    private(set) var rightCards = [Card]()
    private(set) var tries = 0
    private(set) var matchedPairs = 0
    /// Bumped on every right/wrong guess so views can trigger haptics.
    private(set) var matchCount = 0
    private(set) var missCount = 0

    /// When the current level's countdown began, and when it was frozen (win or loss).
    private(set) var timerStart = Date.now
    private(set) var timerEnd: Date?

    private let soundPlayer = SoundPlayer()
    private var isResolving = false
    private var resolveTask: Task<Void, Never>?
    private var timerTask: Task<Void, Never>?

    var pairsInLevel: Int {
        min(Self.firstLevelPairs + (level - 1) * Self.pairsAddedPerLevel, pack.imageNames.count)
    }

    var timeLimit: Double {
        Self.firstLevelSeconds + Double(level - 1) * Self.secondsAddedPerLevel
    }

    /// Fraction of time left, from 1 (full) to 0 (out of time).
    func timeRemainingFraction(at date: Date) -> Double {
        let elapsed = (timerEnd ?? date).timeIntervalSince(timerStart)
        return min(1, max(0, 1 - elapsed / timeLimit))
    }

    var isFinalSize: Bool {
        pairsInLevel == pack.imageNames.count
    }

    // MARK: - Flow

    func showPackSelect() {
        soundPlayer.stop()
        resolveTask?.cancel()
        timerTask?.cancel()
        isResolving = false
        phase = .packSelect
    }

    func startNewGame(with pack: Pack) {
        self.pack = pack
        level = 1
        startLevel()
    }

    func nextLevel() {
        level += 1
        startLevel()
    }

    func retryLevel() {
        startLevel()
    }

    func goToMenu() {
        soundPlayer.stop()
        resolveTask?.cancel()
        timerTask?.cancel()
        isResolving = false
        phase = .menu
    }

    private func startLevel() {
        soundPlayer.stop()
        resolveTask?.cancel()
        timerTask?.cancel()
        isResolving = false
        tries = 0
        matchedPairs = 0

        let names = Array(pack.imageNames.shuffled().prefix(pairsInLevel))
        leftCards = names.shuffled().map { Card(imageName: $0, side: .left, coverName: pack.coverName) }
        rightCards = names.shuffled().map { Card(imageName: $0, side: .right, coverName: pack.coverName) }
        phase = .playing
        startTimer()
    }

    private func startTimer() {
        let limit = timeLimit
        timerStart = .now
        timerEnd = nil
        timerTask = Task {
            try? await Task.sleep(for: .seconds(limit))
            guard !Task.isCancelled else { return }
            timeRanOut()
        }
    }

    private func timeRanOut() {
        guard phase == .playing, matchedPairs < pairsInLevel else { return }
        timerEnd = .now
        resolveTask?.cancel()
        isResolving = false
        soundPlayer.stop()
        withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
            phase = .failed
        }
    }

    // MARK: - Playing

    func select(_ card: Card) {
        guard phase == .playing, !isResolving, card.state == .covered else { return }

        // Only one picture can be open per side, so picking another swaps it.
        for index in indices(of: card.side) where cards(for: card.side)[index].state == .revealed {
            setState(.covered, at: index, side: card.side)
        }
        if let index = index(of: card) {
            setState(.revealed, at: index, side: card.side)
            soundPlayer.playFlip()
        }

        guard let left = leftCards.first(where: { $0.state == .revealed }),
              let right = rightCards.first(where: { $0.state == .revealed })
        else { return }

        tries += 1
        isResolving = true
        resolveTask = Task {
            await resolve(left: left, right: right)
        }
    }

    private func resolve(left: Card, right: Card) async {
        if left.imageName == right.imageName {
            try? await Task.sleep(for: .milliseconds(450))
            guard !Task.isCancelled else { return }
            withAnimation(.spring(duration: 0.5, bounce: 0.6)) {
                set(.matched, for: left)
                set(.matched, for: right)
            }
            soundPlayer.playMatch()
            matchedPairs += 1
            matchCount += 1
            isResolving = false

            if matchedPairs == pairsInLevel {
                timerTask?.cancel()
                timerEnd = .now
                try? await Task.sleep(for: .milliseconds(1100))
                guard !Task.isCancelled else { return }
                soundPlayer.play(pack.soundName)
                withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                    phase = .levelComplete
                }
            }
        } else {
            missCount += 1
            try? await Task.sleep(for: .milliseconds(1000))
            guard !Task.isCancelled else { return }
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                set(.covered, for: left)
                set(.covered, for: right)
            }
            isResolving = false
        }
    }

    // MARK: - Card helpers

    private func cards(for side: BoardSide) -> [Card] {
        side == .left ? leftCards : rightCards
    }

    private func indices(of side: BoardSide) -> Range<Int> {
        cards(for: side).indices
    }

    private func index(of card: Card) -> Int? {
        cards(for: card.side).firstIndex { $0.id == card.id }
    }

    private func set(_ state: CardState, for card: Card) {
        guard let index = index(of: card) else { return }
        setState(state, at: index, side: card.side)
        if state == .covered {
            switch card.side {
            case .left: leftCards[index].shakeCount += 1
            case .right: rightCards[index].shakeCount += 1
            }
        }
    }

    private func setState(_ state: CardState, at index: Int, side: BoardSide) {
        switch side {
        case .left: leftCards[index].state = state
        case .right: rightCards[index].state = state
        }
    }
}
