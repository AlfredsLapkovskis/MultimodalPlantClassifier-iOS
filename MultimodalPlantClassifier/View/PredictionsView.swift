//
//  PredictionsView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 08/05/2024.
//

import SwiftUI

struct PredictionsView: View {
    
    @Binding var predictions: [Prediction]
    
    var body: some View {
        List(predictions) { prediction in
            PredictionItemView(prediction: prediction)
        }
        .navigationTitle("Predictions")
    }
}

#Preview {
    return NavigationStack {
        let modelContainer = CommonUtils.shared.createFakeModelContainer()
        
        var predictions = (0..<5).map { _ in
            CommonUtils.shared.createFakePrediction(modelContainer)
        }
        
        PredictionsView(
            predictions: Binding(get: {
                predictions
            }, set: { newValue in
                predictions = newValue
            })
        )
        .modelContainer(modelContainer)
    }
}
