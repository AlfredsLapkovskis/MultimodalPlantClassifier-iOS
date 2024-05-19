//
//  CGImage+Extension.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI
import CoreML


extension CGImage {
    
    func square() -> CGImage? {
        let shortSide = min(width, height)
        let cropRect = CGRect(
            x: (width - shortSide) / 2,
            y: (height - shortSide) / 2,
            width: shortSide,
            height: shortSide
        )
        
        return cropping(to: cropRect)
    }
    
    func toRGB() -> CGImage {
        if let colorSpace, colorSpace.name == CGColorSpace.sRGB {
            return self
        }
        if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) {
            return copy(colorSpace: colorSpace) ?? self
        }
        
        return self
    }
    
    func toMLArray() -> MLMultiArray {
        assert(colorSpace?.name == CGColorSpace.sRGB)
        
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        bytes.withUnsafeMutableBytes { ptr in
            if let colorSpace = colorSpace,
                let context = CGContext(
                    data: ptr.baseAddress,
                    width: width,
                    height: height,
                    bitsPerComponent: bitsPerComponent,
                    bytesPerRow: bytesPerRow,
                    space: colorSpace,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                ) {
                let rect = CGRect(x: 0, y: 0, width: width, height: height)
                context.draw(self, in: rect)
            }
        }
        
        let shape = [1, NSNumber(value: width), NSNumber(value: height), 3]
        let mlArray = try! MLMultiArray(shape: shape, dataType: .float32)
        
        for i in 0..<(width * height) {
            let j = i * 4
            
            let r = Float32(bytes[j]) / 127.5 - 1
            let g = Float32(bytes[j + 1]) / 127.5 - 1
            let b = Float32(bytes[j + 2]) / 127.5 - 1

            let k = i * 3
            
            mlArray[k] = r as NSNumber
            mlArray[k + 1] = g as NSNumber
            mlArray[k + 2] = b as NSNumber
        }
        
        return mlArray
    }
}
