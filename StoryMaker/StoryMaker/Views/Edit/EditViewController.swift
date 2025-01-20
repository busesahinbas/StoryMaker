//
//  EditViewController.swift
//  StoryMaker
//
//  Created by Buse Şahinbaş on 17.01.2025.
//  Copyright © 2025 Buse Şahinbaş. All rights reserved.
//

import UIKit

class EditViewController: UIViewController{
    
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var toolbarStack: UIStackView!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private(set) weak var checkButton: UIButton!
    @IBOutlet private(set)weak var tableView: UITableView!
    
    var selectedImage: UIImage?
    private var filters: [FilterType] = FilterType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupTableView()
        setupToolbar()
    }
    
    private func setupUI() {
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        toolbarStack.isHidden = false
        collectionView.isHidden = true
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }
    
    private func setupToolbar() {
        ToolType.allCases.forEach { tool in
            let button = UIButton(type: .system)
            button.setTitle(tool.title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12)
            button.setImage(UIImage(systemName: tool.iconName), for: .normal)
            button.tintColor = .black
            button.centerImageAndButton(spacing: 5)
            button.addTarget(self, action: #selector(toolButtonTapped(_:)), for: .touchUpInside)
            
            toolbarStack.addArrangedSubview(button)
        }
    }
    
    @objc private func checkButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func toolButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.toolbarStack.isHidden = false
            
            switch title {
            case "Filters":
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
            case "Effect":
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
            default:
                self.collectionView.isHidden = true
                self.tableView.isHidden = true
            }
        }
    }
    
    private func applyFilter(_ filter: CIFilter, to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return nil }
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - UICollectionViewDataSource
extension EditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCollectionViewCell.identifier,
            for: indexPath) as? FilterCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let filterType = filters[indexPath.item]
        if let image = selectedImage {
            if let filter = filterType.filter {
                let filteredImage = applyFilter(filter, to: image)
                cell.configure(with: filteredImage ?? image)
            } else {
                cell.configure(with: image)
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EditViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterType = filters[indexPath.item]
        if let image = selectedImage {
            if let filter = filterType.filter {
                imageView.image = applyFilter(filter, to: image)
            } else {
                imageView.image = image
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  // Since we only have one settings cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        // Configure the sliders
        cell.didChangeBrightness = { [weak self] value in
            self?.adjustImageBrightness(value)
        }
        
        cell.didChangeContrast = { [weak self] value in
            self?.adjustImageContrast(value)
        }
        
        cell.didChangeShadow = { [weak self] value in
            self?.adjustImageShadow(value)
        }
        
        return cell
    }
    
    private func adjustImageBrightness(_ value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2 - 1, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
    
    private func adjustImageContrast(_ value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2, forKey: kCIInputContrastKey)
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
    
    private func adjustImageShadow(_ value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2 - 1, forKey: "inputShadowAmount")
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
}
