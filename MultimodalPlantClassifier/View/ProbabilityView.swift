//
//  ProbabilityView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI

struct ProbabilityView: View {
    
    private let probability: Double
    
    init(probability: Double) {
        self.probability = probability
    }
    
    var body: some View {
        let circleSize: CGFloat = 48
        
        ZStack {
            let probabilityString = {
                let intProb = Int(probability * 100)
                return intProb <= 0 ? "<0%" : "\(intProb)%"
            }()
            
            Text(probabilityString)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            Circle()
                .stroke(lineWidth: 3)
                .frame(width: circleSize, height: circleSize)
                .foregroundStyle(.gray.opacity(0.25))
            Circle()
                .trim(from: 0, to: probability)
                .stroke(lineWidth: 3)
                .frame(width: circleSize, height: circleSize)
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    ProbabilityView(probability: 0.56)
}
