//
//  HistoryItemImageGridView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 12/05/2024.
//

import SwiftUI


struct HistoryItemImageGridView: View {
    
    private let historyItem: HistoryItem
    private let imageSize: CGFloat
    
    init(historyItem: HistoryItem, imageSize: CGFloat) {
        self.historyItem = historyItem
        self.imageSize = imageSize
    }
    
    var body: some View {
        let images = historyItem.images.reduce(into: [:]) { $0[$1.modality] = $1.image }
        
        return Grid(horizontalSpacing: 1, verticalSpacing: 1) {
            GridRow {
                buildSmallImage(images[.flower])
                buildSmallImage(images[.fruit])
            }
            GridRow {
                buildSmallImage(images[.leaf])
                buildSmallImage(images[.stem])
            }
        }
    }
    
    @ViewBuilder
    private func buildSmallImage(_ imageData: Data?) -> some View {
        let shape = RoundedRectangle(
            cornerSize: CGSize(width: imageSize / 6, height: imageSize / 6),
            style: .continuous
        )
        
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .aspectRatio(contentMode: .fill)
                .clipShape(shape)
        } else {
            shape
                .frame(width: imageSize, height: imageSize)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    let modelContainer = CommonUtils.shared.createFakeModelContainer()
    
    return List{HistoryItemImageGridView(historyItem: CommonUtils.shared.createFakeHistoryItem(modelContainer), imageSize: 50)
        .modelContainer(modelContainer)}
}
