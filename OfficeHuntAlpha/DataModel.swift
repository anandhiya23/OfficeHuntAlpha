/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import SwiftUI
import Vision
//import os.log

@MainActor
final class DataModel: ObservableObject {
    let camera = Camera()
    
    @Published var viewfinderImage: Image?
    @Published var categories: [String: VNConfidence]?
    @Published var searchTerms: [String: VNConfidence]?
    @Published var confidentObservations: [String: VNConfidence]?
    @Published var confidentObservationKeys: [String]?
    //@Published var thumbnailImage: Image?
    
    var isPhotosLoaded = false
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { await self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                //thumbnailImage = photoData.thumbnailImage
            }
            savePhoto(imageData: photoData.imageData)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
            guard let imageData = photo.fileDataRepresentation() else { return nil }

            let photoDimensions = photo.resolvedSettings.photoDimensions
            let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        
            return PhotoData(imageData: imageData, imageSize: imageSize)
        }
    
    func savePhoto(imageData: Data) {
        
        //classifications of observations
        
        
        // Classify the images
        
        let handler = VNImageRequestHandler(data: imageData)
        let request = VNClassifyImageRequest()
        try? handler.perform([request])
        
        // Process classification results
        guard let observations = request.results else {
            categories = [:]
            searchTerms = [:]
            return
        }
        
//        categories = observations
//            .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
//            .reduce(into: [String: VNConfidence]()) { dict, observation in dict[observation.identifier] = observation.confidence }
//            
//        searchTerms = observations
//            .filter { $0.hasMinimumPrecision(0.01, forRecall: 0.7) }
//            .reduce(into: [String: VNConfidence]()) { (dict, observation) in dict[observation.identifier] = observation.confidence }
        
        confidentObservations = observations
            .filter { $0.confidence > 0.07 }
            .reduce(into: [String: VNConfidence]()) { (dict, observation) in dict[observation.identifier] = observation.confidence }
        
        confidentObservationKeys = observations
            .filter { $0.confidence > 0.07 }
            .reduce(into: [String]()) { (array, observation) in array.append(observation.identifier)}
        
    }
}

fileprivate struct PhotoData {
    //var thumbnailImage: Image
    //var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

//fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")
