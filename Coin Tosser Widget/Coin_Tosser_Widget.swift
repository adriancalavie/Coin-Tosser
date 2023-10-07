//
//  Coin_Tosser_Widget.swift
//  Coin Tosser Widget
//
//  Created by Adrian Călăvie on 07/10/2023.
//

import AppIntents
import SwiftUI
import WidgetKit

enum CoinFace: String {
    case HEADS = "Heads"
    case TAILS = "Tails"
    case UNKNOWN = "Unknown"
}

struct CoinEntry: TimelineEntry {
    let date: Date
    let face: CoinFace
}

struct CoinTossProvider: AppIntentTimelineProvider {
    func snapshot(for configuration: TossCoinConfigIntent, in context: Context) async -> CoinEntry {
        let date = Date()
        let coinToss = Int.random(in: 0 ... 1)
        let coinFace = coinToss == 1 ? CoinFace.HEADS : CoinFace.TAILS

        return CoinEntry(date: date, face: coinFace)
    }

    func timeline(for configuration: TossCoinConfigIntent, in context: Context) async -> Timeline<CoinEntry> {
        let entry: CoinEntry
        let date = Date()

        let currentCoinFace = Int.random(in: 0 ... 1) == 1 ? CoinFace.HEADS : CoinFace.TAILS
        entry = CoinEntry(date: date, face: currentCoinFace)

        // Create the timeline with the current entry and update policy.
        let timeline = Timeline(entries: [entry], policy: .atEnd)

        return timeline
    }

    typealias Entry = CoinEntry

    typealias Intent = TossCoinConfigIntent

    func placeholder(in context: Context) -> CoinEntry {
        return CoinEntry(date: Date(), face: CoinFace.UNKNOWN)
    }
}

struct Coin_Tosser_WidgetEntryView: View {
    var entry: CoinEntry

    var body: some View {
        VStack {
            Spacer()

            Text(entry.face.rawValue)
                .font(.title)

            Spacer()

            Button(intent: TossCoinConfigIntent()) {
                Label("Toss", systemImage: "arrow.clockwise")
                    .font(.caption)
            }
        }
        .foregroundColor(.accentColor)
        .containerBackground(for: .widget) {}
    }
}

struct TossCoinConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Toss a coin"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct Coin_Tosser_Widget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "Coin_Tosser_Widget",
            intent: TossCoinConfigIntent.self,
            provider: CoinTossProvider()
        ) { entry in
            Coin_Tosser_WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    Coin_Tosser_Widget()
} timeline: {
    CoinEntry(date: .now, face: CoinFace.UNKNOWN)
    CoinEntry(date: .now, face: CoinFace.TAILS)
    CoinEntry(date: .now, face: CoinFace.HEADS)
}
