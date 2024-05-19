//
//  PredictionItemView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI

struct PredictionItemView: View {
    
    private let prediction: Prediction
    
    init(prediction: Prediction) {
        self.prediction = prediction
    }
    
    var body: some View {
        HStack {
            buildProbability(prediction)
            buildSpecies(prediction)
            Spacer()
            buildImage(prediction)
        }
        .contextMenu {
            Text(prediction.species)
            buildCopySpeciesButton(prediction)
        } preview: {
            Image(uiImage: prediction.image!)
        }
    }
    
    private func buildProbability(_ prediction: Prediction) -> some View {
        ProbabilityView(probability: prediction.probability)
    }
    
    private func buildSpecies(_ prediction: Prediction) -> some View {
        Text(prediction.species)
            .lineLimit(3)
            .font(.system(size: 16, design: .rounded))
    }
    
    private func buildImage(_ prediction: Prediction) -> some View {
        Image(uiImage: prediction.image!)
            .resizable()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 12, height: 12), style: .continuous))
    }
    
    private func buildCopySpeciesButton(_ prediction: Prediction) -> some View {
        Button {
            UIPasteboard.general.string = prediction.species
        } label: {
            HStack {
                Text("Copy species name")
                Image(systemName: "doc.on.doc")
            }
        }
    }
}

#Preview {
    let modelContainer = CommonUtils.shared.createFakeModelContainer()
    
    let prediction = Prediction(label: 0, probability: 0.65)
    
    modelContainer.mainContext.insert(prediction)
    
    return PredictionItemView(prediction: prediction)
        .modelContainer(modelContainer)
}
