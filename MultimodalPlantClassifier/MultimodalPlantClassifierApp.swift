//
//  MultimodalPlantClassifierApp.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 06/05/2024.
//

import SwiftUI
import SwiftData


@main
struct MultimodalPlantClassifierApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    HistoryItem.self,
                    ImageItem.self,
                    Prediction.self,
                ])
        }
    }
}
