//
//  PlantClassifier.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 06/05/2024.
//

import Foundation
import UIKit
import CoreML


class PlantClassifier {
    
    static let shared = PlantClassifier()
 
    private init() {
    }
    
    func predict(_ images: [Modality : UIImage]) async -> Prediction? {
        if let (label, probability) = await _predict(images)?.topK(1).first {
            return Prediction(label: label, probability: Double(probability))
        }
        
        return nil
    }
    
    func predict(topK k: Int, images: [Modality : UIImage]) async -> [Prediction]? {
        if let probabilities = await _predict(images) {
            return probabilities.topK(k).map {
                Prediction(label: $0.index, probability: Double($0.probability))
            }
        }
        
        return nil
    }
    
    private func _predict(_ images: [Modality : UIImage]) async -> [Float32]? {
        guard !images.isEmpty
        else {
            return nil
        }
        
        return await withUnsafeContinuation { (continuation: UnsafeContinuation<[Float32]?, Never>) -> Void in
            let configuration = MLModelConfiguration()
            
            guard let model = try? PlantClassifierModel(configuration: configuration)
            else {
                continuation.resume(returning: nil)
                return
            }
            
            guard let output = try? model.prediction(
                flower: prepareForInference(images[.flower]),
                fruit: prepareForInference(images[.fruit]),
                leaf: prepareForInference(images[.leaf]),
                stem: prepareForInference(images[.stem])
            )
            else {
                continuation.resume(returning: nil)
                return
            }
            
            continuation.resume(returning: output.Identity.toFloat32Array())
        }
    }
    
    private func prepareForInference(_ image: UIImage?) -> MLMultiArray {
        image?
            .toRGB()
            .resized(Constants.imageSize)
            .square()?
            .toMLArray()
        ?? getEmptyMLArray()
    }
    
    private func getEmptyMLArray() -> MLMultiArray {
        let size = Constants.imageSize
        let shape = [1, NSNumber(value: size.width), NSNumber(value: size.height), 3]
        
        return try! MLMultiArray(shape: shape, dataType: .float32)
    }
}
