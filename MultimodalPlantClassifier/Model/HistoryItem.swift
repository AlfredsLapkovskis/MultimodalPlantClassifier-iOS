//
//  HistoryItem.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import Foundation
import SwiftData


@Model
class HistoryItem : Identifiable {
    @Attribute(.unique) let id: String
    @Relationship(deleteRule: .cascade) var images: [ImageItem]
    @Relationship(deleteRule: .cascade) var predictions: [Prediction]
    var creationDate: Date
    
    init(images: [ImageItem], predictions: [Prediction], creationDate: Date = .now) {
        self.id = ProcessInfo.processInfo.globallyUniqueString
        self.images = images
        self.predictions = predictions
        self.creationDate = creationDate
    }
}
