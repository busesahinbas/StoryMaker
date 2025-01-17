//
//  ViewController.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 17.01.2025.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var selectImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
        } else {
            view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
        }
        
        welcomeLabel.text = "StoryMaker'a Hoşgeldiniz"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.textColor = .label
        
        selectImageButton.setTitle("Fotoğraf Seç", for: .normal)
        selectImageButton.backgroundColor = .systemIndigo
        selectImageButton.setTitleColor(.white, for: .normal)
        selectImageButton.layer.cornerRadius = 10
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let editVC = EditViewController(nibName: "EditViewController", bundle: nil)
            editVC.selectedImage = selectedImage
            editVC.modalPresentationStyle = .fullScreen
            picker.dismiss(animated: true) {
                self.present(editVC, animated: true)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
            } else {
                view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
            }
        }
    }
}

