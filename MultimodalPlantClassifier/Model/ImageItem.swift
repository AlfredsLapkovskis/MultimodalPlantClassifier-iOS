//
//  ImageItem.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import Foundation
import SwiftData


@Model
class ImageItem {
    var modality: Modality
    @Attribute(.externalStorage) var image: Data
    
    init(modality: Modality, image: Data) {
        self.modality = modality
        self.image = image
    }
}
