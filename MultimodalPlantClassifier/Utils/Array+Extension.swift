//
//  Array+Extension.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import Foundation


extension Array where Element: FloatingPoint {
    
    func topK(_ k: Int) -> [(index: Int, probability: Element)] {
        Array<(index: Int, probability: Element)>(
            enumerated()
                .map { (index: $0, probability: $1) }
                .sorted(by: { $0.probability > $1.probability })
                .prefix(Swift.min(k, count))
        )
    }
}
