//
//  Copyright © 2018 Picsure. All rights reserved.
//

import UIKit
import Photos

typealias ParametersCompletion = (Parameters?) -> Void

final class MetadataService {

    private static let photoLibrary = PHPhotoLibrary.shared()

    static func metadata(from image: UIImage, completion: @escaping ParametersCompletion) {
        photoLibrary.save(image, albumName: "Picsure", completion: { asset in
            guard let asset = asset else {
                completion(nil)
                return
            }
            metadata(from: asset, completion: completion)
        })
    }

    private static func metadata(from asset: PHAsset, completion: @escaping ParametersCompletion) {
        PHImageManager.default().requestImageData(for: asset, options: nil) { data, _, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(metadata(from: data))
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

    func save(_ image: UIImage, albumName: String, completion: ((PHAsset?) -> Void)? = nil) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            completion?(nil)
            return
        }
        if let album = album(withName: albumName) {
            save(image, album: album, completion: completion)
        }
        else {
            createAlbum(withName: albumName, completion: { collection in
                if let collection = collection {
                    self.save(image, album: collection) { asset in
                        completion?(asset)
                    }
                }
                else {
                    completion?(nil)
                }
            })
        }
    }

    private func save(_ image: UIImage, album: PHAssetCollection, completion: ((PHAsset?) -> Void)? = nil) {
        var placeholder: PHObjectPlaceholder?
        performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                    completion?(nil)
                    return
            }
            placeholder = photoPlaceholder
            let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
            albumChangeRequest.addAssets(fastEnumeration)
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder, success else {
                completion?(nil)
                return
            }
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            let asset = assets.firstObject
            completion?(asset)
        })
    }

    private func album(withName name: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        guard let photoAlbum = fetchResult.firstObject else {
            return nil
        }
        return photoAlbum
    }

    private func createAlbum(withName name: String, completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, _ in
            guard let placeholder = albumPlaceholder, success else {
                completion(nil)
                return
            }
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            guard let album = fetchResult.firstObject else {
                completion(nil)
                return
            }
            completion(album)
        })
    }
}
