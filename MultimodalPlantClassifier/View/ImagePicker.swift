//
//  ImagePicker.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 06/05/2024.
//

import Foundation
import PhotosUI
import Photos
import SwiftUI


struct ImagePicker : UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    typealias OnPickedBlock = (UIImage?) -> Void
    
    enum Source {
        case gallery
        case camera
    }
    
    private let source: Source
    private let onPicked: OnPickedBlock
    
    init(source: Source, onPicked: @escaping OnPickedBlock) {
        self.source = source
        self.onPicked = onPicked
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        switch source {
        case .gallery:
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let controller = PHPickerViewController(configuration: configuration)
            controller.delegate = context.coordinator
            
            return controller
        case .camera:
            let controller = UIImagePickerController()
            
            controller.sourceType = .camera
            controller.mediaTypes = [UTType.image.identifier]
            controller.delegate = context.coordinator
            
            return controller
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // do nothing
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        
        private let onPicked: OnPickedBlock
        
        fileprivate init(onPicked: @escaping OnPickedBlock) {
            self.onPicked = onPicked
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first
            else {
                onPicked(nil)
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] data, error in
                guard let self else { return }
                
                guard let image = data as? UIImage, error == nil
                else {
                    onPicked(nil)
                    return
                }
                
                onPicked(image)
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
            let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            onPicked(image)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            
            onPicked(nil)
        }
    }
}
