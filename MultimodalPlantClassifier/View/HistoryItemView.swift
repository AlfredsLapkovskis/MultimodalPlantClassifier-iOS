//
//  HistoryItemView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI

struct HistoryItemView: View {
    
    private let historyItem: HistoryItem
    
    init(historyItem: HistoryItem) {
        self.historyItem = historyItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                List {
                    HStack {
                        Spacer()
                        HistoryItemImageGridView(
                            historyItem: historyItem,
                            imageSize: min(256, min(geometry.size.width, geometry.size.height) * 0.4)
                        )
                        Spacer()
                    }
                    .padding()
                    
                    predictionDate
                    
                    let predictions = historyItem.predictions.sorted(by: { $0.probability > $1.probability })
                    
                    ForEach(predictions) { prediction in
                        PredictionItemView(prediction: prediction)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .navigationTitle("History item")
    }
    
    var predictionDate: some View {
        let dateString = historyItem.creationDate.formatted()
        
        return Text("Predicted at \(dateString)")
            .font(.subheadline)
    }
}

#Preview {
    let modelContainer = CommonUtils.shared.createFakeModelContainer()

    return NavigationStack {
        HistoryItemView(historyItem: CommonUtils.shared.createFakeHistoryItem(modelContainer))
    }
    .modelContainer(modelContainer)
}
