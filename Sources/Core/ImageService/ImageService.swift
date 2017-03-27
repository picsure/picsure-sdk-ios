//
//  ImageService.swift
//  Snapsure
//
//  Created by Artem Novichkov on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

final class ImageService {
    
    private enum Constants {
        static let maxKbSize = 1500
        static let maxSide = 1920
        static let maxSize = CGSize(width: maxSide, height: maxSide)
    }
    
    /// Returns data for resized and compressed image. Maximum side is equal to 1920px, compression quality is equal to 85%.
    ///
    /// - Parameter image: The image for converting to data.
    /// - Returns: The data for resized and compressed image.
    /// - Throws: `SnapsureErrors.ImageErrors` types, if image has unsupported bitmap format or size of final data is more than 600 Kb.
    static func convert(_ image: UIImage) throws -> Data {
        let resizedImage = image.resized(within: Constants.maxSize)
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.85) else {
            throw SnapsureErrors.ImageErrors.unsupportedBitmapFormat
        }
        guard imageData.kbSize < Constants.maxKbSize else {
            throw SnapsureErrors.ImageErrors.bigSize
        }
        return imageData
    }
}

fileprivate extension UIImage {
    
    /// Returns a resized image that fits in rectSize, keeping its aspect ratio.
    ///
    /// - Parameter size: Resized image size will be within this size.
    /// - Returns: Resized image.
    func resized(within size: CGSize) -> UIImage {
        guard self.size.width > size.width || self.size.height > size.height else {
            return self
        }
        let widthFactor = self.size.width / size.width
        let heightFactor = self.size.height / size.height
        
        var resizeFactor = widthFactor
        if self.size.height > self.size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: self.size.width / resizeFactor,
                             height: self.size.height / resizeFactor)
        let resizedImage = resized(with: newSize)
        return resizedImage
    }
    
    /// Returns an image that fills in size.
    ///
    /// - Parameter size: The size for filling.
    /// - Returns: If size is not equal to original image, returns resized image. Otherwise, returns original image.
    private func resized(with size: CGSize) -> UIImage {
        guard self.size != size else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

fileprivate extension Data {
    
    /// Size in kilobytes.
    var kbSize: Int {
        return count / 1024
    }
}
