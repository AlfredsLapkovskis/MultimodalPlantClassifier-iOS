//
//  UIImage+Extension.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI
import CoreML


extension UIImage {
    
    func resized(_ size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true
        
        let rect = CGRect(origin: .zero, size: size)
        
        return UIGraphicsImageRenderer(bounds: rect, format: format).image { context in
            draw(in: rect)
        }
    }
    
    func fixOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        if let cgImage, let colorSpace = cgImage.colorSpace, let ctx = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) {
            ctx.concatenate(transform)
            
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let ctxImage = ctx.makeImage() {
                return UIImage(cgImage: ctxImage)
            } else {
                return self
            }
        }
        
        return self
    }
    
    func toRGB() -> UIImage {
        if let cgImage {
            let rgbCGImage = cgImage.toRGB()
            if rgbCGImage !== cgImage {
                return UIImage(cgImage: rgbCGImage)
            }
        }
        
        return self
    }
    
    func square() -> UIImage? {
        cgImage?.square().map { UIImage(cgImage: $0) }
    }
    
    func toMLArray() -> MLMultiArray? {
        cgImage?.toMLArray()
    }
}
