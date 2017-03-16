//
//  SnapsureSDK.swift
//  SnapsureSDK
//
//  Created by Nikita Ermolenko on 11/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

public final class SnapsureSDK {
    
    public static func configure(withApiKey apiKey: String) {
//        testLocalization()
        let networkService = NetworkService.shared
        networkService.token = apiKey
    }
    
    static func testLocalization() {
        let path = Bundle(for: SnapsureSDK.self).path(forResource: "SSLocalizations", ofType: "bundle")
        let bundle = Bundle(path: path!)!
        print(bundle.localizedString(forKey: "test", value: nil, table: nil))
    }
    
    public static func uploadPhoto(_ image: UIImage, completionHandler completion: @escaping Completion) {
        DispatchQueue.global().async {
            do {
                let data = try ImageService.convert(image)
                let imageBodyPart = BodyPart(data: data, name: "upload", fileName: "saw.jpg", mimeType: "image/jpeg")
                NetworkService.shared.uploadData(for: .upload(imageBodyPart)) { result in
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public static func checkImageTest() {
        NetworkService.shared.checkImage(for: LookupEndpoint.lookup(21)) { (result: Result<JSON>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let json):
                print(json)
            }
        }
    }
}
