//
//  CommonUtils.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import UIKit
import SwiftData


class CommonUtils {
    static let shared = CommonUtils()
    
    private init() {
    }
    
    func createFakeModelContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: HistoryItem.self, configurations: config)
    }
    
    @MainActor
    func createFakeHistoryItem(_ modelContainer: ModelContainer) -> HistoryItem {
        let item = HistoryItem(
            images: (0..<4).compactMap {
                if let img = UIImage(named: "cls_\(Int.random(in: 0..<956))")?.jpegData(compressionQuality: 1) {
                    return ImageItem(modality: Modality.allCases[$0], image: img)
                }
                
                return nil
            },
            predictions: (0..<10).map { _ in
                Prediction(label: Int.random(in: 0..<956), probability: Double.random(in: 0...1))
            }
        )
        
        modelContainer.mainContext.insert(item)
        
        return item
    }
    
    @MainActor
    func createFakePrediction(_ modelContainer: ModelContainer) -> Prediction {
        let item = Prediction(label: Int.random(in: 0..<956), probability: Double.random(in: 0...1))
        
        modelContainer.mainContext.insert(item)
        
        return item
    }
}
