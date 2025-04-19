//
//  ImageEditorView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/17/25.
//

import SwiftUI
import Mantis

struct ImageEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        if let image = selectedImage {
            CropViewControllerWrapper(
                image: image,
                cropShapeType: .circle()
            ) { croppedImage in
                selectedImage = croppedImage
                dismiss()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
    }
}

// MARK: - Mantis Crop View Controller Wrapper
struct CropViewControllerWrapper: UIViewControllerRepresentable {
    let image: UIImage
    let cropShapeType: CropShapeType
    let completion: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = context.coordinator
        
        // 커스텀 설정
        var config = Mantis.Config()
        config.cropShapeType = cropShapeType
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.0)
        config.showRotationDial = true
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate, .reset, .ratio]
        
        cropViewController.config = config
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(originalImage: image, completion: completion)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            self.completion(original)
        }
        
        let originalImage: UIImage
        let completion: (UIImage) -> Void
        
        init(originalImage: UIImage, completion: @escaping (UIImage) -> Void) {
            self.originalImage = originalImage
            self.completion = completion
            super.init()
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            self.completion(cropped)
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            self.completion(original)
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {}
        
        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {}
    }
}
