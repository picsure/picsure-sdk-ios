//
//  Copyright © 2018 Picsure. All rights reserved.
//

import UIKit
import Photos

typealias ParametersCompletion = (Parameters?, Error?) -> Void

final class MetadataService {

    private static let photoLibrary = PHPhotoLibrary.shared()

    static func metadata(from image: UIImage, completion: @escaping ParametersCompletion) {
        photoLibrary.save(image) { asset, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let asset = asset else {
                completion(nil, nil)
                return
            }
            metadata(from: asset, completion: completion)
        }
    }

    private static func metadata(from asset: PHAsset, completion: @escaping ParametersCompletion) {
        PHImageManager.default().requestImageData(for: asset, options: nil) { data, _, _, _ in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            completion(metadata(from: data), nil)
        }
    }

    private static func metadata(from data: Data) -> Parameters? {
        guard let selectedImageSourceRef = CGImageSourceCreateWithData(data as CFData, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(selectedImageSourceRef, 0, nil) as? Parameters else {
                return nil
        }
        return properties
    }
}

private extension PHPhotoLibrary {

    func save(_ image: UIImage, completion: ((PHAsset?, Error?) -> Void)? = nil) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            completion?(nil, PicsureErrors.ImageErrors.missingPhotoPermission)
            return
        }
        var placeholder: PHObjectPlaceholder?
        performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                completion?(nil, nil)
                return
            }
            placeholder = photoPlaceholder
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder, success else {
                completion?(nil, nil)
                return
            }
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            let asset = assets.firstObject
            completion?(asset, nil)
        })
    }
}
