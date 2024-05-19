//
//  HistoryView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI
import SwiftData


struct HistoryView: View {
    
    @Query(sort: \HistoryItem.creationDate, order: .reverse) private var historyItems: [HistoryItem]
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            if !historyItems.isEmpty {
                List {
                    ForEach(historyItems) { historyItem in
                        NavigationLink {
                            HistoryItemView(historyItem: historyItem)
                        } label: {
                            HStack {
                                let bestPrediction = historyItem.predictions.max(by: { $0.probability < $1.probability })
                                
                                buildProbability(bestPrediction)
                                buildSpecies(bestPrediction)
                                Spacer()
                                buildImageGrid(historyItem)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        let deletedIds = Set(historyItems
                            .enumerated()
                            .filter { indexSet.contains($0.offset) }
                            .map { $0.element.id })
                        
                        try? modelContext.delete(model: HistoryItem.self, where: #Predicate {
                            deletedIds.contains($0.id)
                        })
                    })
                }
                .navigationTitle("History")
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isEditing = !isEditing
                        } label: {
                            Text(isEditing ? "Cancel" : "Edit")
                        }
                    }
                }
            } else {
                Text("No items found")
                    .font(.system(size: 16, weight: .thin, design: .rounded))
                    .navigationTitle("History")
            }
        }
    }
    
    private func buildImageGrid(_ historyItem: HistoryItem) -> some View {
        HistoryItemImageGridView(historyItem: historyItem, imageSize: 24)
    }
    
    private func buildSpecies(_ prediction: Prediction?) -> some View {
        Text(prediction?.species ?? "Unknown")
            .lineLimit(3)
            .font(.system(size: 16, design: .rounded))
    }
    
    private func buildProbability(_ prediction: Prediction?) -> some View {
        ProbabilityView(probability: prediction?.probability ?? 0.0)
    }
}

#Preview {
    let modelContainer = CommonUtils.shared.createFakeModelContainer()
    
    for _ in 0..<5 {
        _ = CommonUtils.shared.createFakeHistoryItem(modelContainer)
    }
    
    return NavigationStack {
        HistoryView()
            .navigationTitle("History")
    }
    .modelContainer(modelContainer)
}
