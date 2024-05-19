//
//  MLMultiArray+Extension.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import Foundation
import CoreML


extension MLMultiArray {
    
    func toFloat32Array() -> [Float32] {
        var arr: [Float32] = Array(repeating: 0, count: count)
        let ptr = UnsafeMutablePointer<Float32>(OpaquePointer(dataPointer))
        for i in 0..<count {
            arr[i] = Float32(ptr[i])
        }
        return arr
    }
}
