//
//  WelcomeViewController.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 17.01.2025.
//

import UIKit
import Photos

final class WelcomeViewController: UIViewController, UINavigationControllerDelegate {
    //MARK: - IBOutlets
    @IBOutlet private(set) weak var backgroundImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var subtitleLabel: UILabel!
    @IBOutlet private(set) weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.text = "Welcome to StoryMaker"
        startButton.setTitle("Get Started", for: .normal)
        startButton.layer.cornerRadius = 10
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
}

//MARK: - ImagePicker Extension
extension WelcomeViewController: UIImagePickerControllerDelegate {
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

    //TODO: busee do i need dark mode check??
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            if traitCollection.userInterfaceStyle == .dark {
//                view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
//            } else {
//                view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
//            }
//        }
//    }
}
