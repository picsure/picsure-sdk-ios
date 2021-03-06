//
//  ViewController.swift
//  Picsure-Example-iOS
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import UIKit
import Picsure
import Photos

class ViewController: UIViewController {
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Take a photo", for: .normal)
        button.addTarget(self, action: #selector(takePhotoButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
        view.addSubview(takePhotoButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        takePhotoButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        takePhotoButton.center = view.center
    }
    
    //MARK: - Picsure SDK
    
    private func upload(_ photo: UIImage) {
        print("Processing...")
        Picsure.upload(photo) { result in
            debugPrint(result)
        }
    }
    
    //MARK: - Actions
    
    @objc private func takePhotoButtonAction() {
        let pickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
        }
        else {
            pickerController.sourceType = .photoLibrary
        }
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        upload(image)
    }
}
