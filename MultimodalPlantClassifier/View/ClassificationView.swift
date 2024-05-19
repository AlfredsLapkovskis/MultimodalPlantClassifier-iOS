//
//  ClassificationView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 06/05/2024.
//

import SwiftUI

struct ClassificationView: View {
    @State private var isSelectingPickerSource = false
    @State private var isDeletingImage = false
    @State private var isPicking = false
    @State private var isPredicting = false
    @State private var isPresentingPredictions = false
    @State private var pickerSource: ImagePicker.Source = .gallery
    @State private var selectedModality: Modality = .flower
    @State private var images: [Modality : UIImage] = [:]
    @State private var predictions: [Prediction] = []
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    buildModalityButton(
                        modality: .flower
                    )
                    buildModalityButton(
                        modality: .fruit
                    )
                }
                HStack {
                    buildModalityButton(
                        modality: .leaf
                    )
                    buildModalityButton(
                        modality: .stem
                    )
                }
                Spacer()
                if !images.isEmpty {
                    buildClassificationButton()
                } else {
                    buildClassificationButton().hidden()
                }
            }
            .navigationTitle("Classify")
            .padding(.all, 16)
            .confirmationDialog("Select source", isPresented: $isSelectingPickerSource) {
                buildSourceButton(source: .gallery)
                buildSourceButton(source: .camera)
            }
            .navigationDestination(isPresented: $isPresentingPredictions) {
                PredictionsView(predictions: $predictions)
                    .onDisappear {
                        predictions.removeAll()
                    }
            }
            .sheet(isPresented: $isPicking) {
                ImagePicker(source: pickerSource) { image in
                    guard let image else { return }
                    
                    Task { @MainActor in
                        images[selectedModality] = image.fixOrientation()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
    
    private func buildModalityButton(modality: Modality) -> some View {
        let title: String
        let icon: String
        let color: Color
        
        switch modality {
        case .flower:
            title = "Flower"
            icon = "camera.macro.circle.fill"
            color = .purple
        case .leaf:
            title = "Leaf"
            icon = "leaf.circle.fill"
            color = .green
        case .fruit:
            title = "Fruit"
            icon = "carrot.fill"
            color = .indigo
        case .stem:
            title = "Stem"
            icon = "tree.fill"
            color = .orange
        }
        
        return Button {
            selectedModality = modality
            isSelectingPickerSource = true
        } label: {
            let shape = RoundedRectangle(
                cornerSize: .init(width: 16, height: 16),
                style: .continuous
            )
            
            VStack(spacing: 0) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .tint(.white)
                    .padding(.all, 32)
                    .opacity(images.keys.contains(modality) ? 0 : 1)
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.bottom, 16)
            }
            .background {
                if let image = images[modality] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .contextMenu {
                            Button(role: .destructive) {
                                images.removeValue(forKey: modality)
                            } label: {
                                Text("Delete image")
                            }
                        }
                } else {
                    shape
                        .foregroundStyle(color)
                }
            }
            .clipShape(shape)
        }
    }
    
    private func buildSourceButton(source: ImagePicker.Source) -> some View {
        Button {
            pickerSource = source
            isPicking = true
        } label: {
            switch source {
            case .gallery:
                Text("Gallery")
            case .camera:
                Text("Camera")
            }
        }
    }
    
    private func buildClassificationButton() -> some View {
        Button {
            guard !isPredicting else { return }
            
            Task {
                isPredicting = true
                defer {
                    isPredicting = false
                }
                
                if let predictions = await PlantClassifier.shared.predict(topK: 10, images: images) {
                    self.predictions = predictions
                    self.isPresentingPredictions = true
                    
                    let imageItems = images.compactMap { entry in
                        if let img = entry.value.toRGB().resized(Constants.imageSize).square()?.jpegData(compressionQuality: 1) {
                            return ImageItem(modality: entry.key, image: img)
                        }
                        
                        return nil
                    }
                    
                    let historyItem = HistoryItem(
                        images: imageItems,
                        predictions: predictions
                    )
                    
                    modelContext.insert(historyItem)
                }
            }
        } label: {
            ZStack {
                let text = Text("Classify")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(
                            cornerSize: .init(width: 12, height: 12),
                            style: .continuous
                        )
                        .foregroundStyle(.gray.opacity(0.25))
                    }
                
                if !isPredicting {
                    text
                } else {
                    text.hidden()
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClassificationView()
            .navigationTitle("Classify")
    }
}
