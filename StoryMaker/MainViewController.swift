import UIKit
import CoreImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var editingControlsView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    
    private var originalImage: UIImage?
    private var context: CIContext!
    private var currentFilter: CIFilter?
    private var isPreviewingOriginal = false
    private var editButtons: [UIButton] = []
    private let editOptions = ["Filtreler", "Parlaklık", "Kontrast", "Doygunluk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTabBar()
        context = CIContext()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0)
        editingControlsView.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 0.9)
        
        brightnessSlider.minimumValue = 0.0
        brightnessSlider.maximumValue = 2.0
        brightnessSlider.value = 1.0
        
        contrastSlider.minimumValue = 0.0
        contrastSlider.maximumValue = 2.0
        contrastSlider.value = 1.0
        
        // Preview button setup
        previewButton.layer.cornerRadius = 20
        previewButton.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 0.9)
        previewButton.setTitle("Önizle", for: .normal)
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
    }
    
    private func setupTabBar() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.addSubview(stackView)
        
        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -10)
        ])
        
        // Create edit buttons
        for (index, option) in editOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 0.9)
            button.layer.cornerRadius = 15
            button.tag = index
            button.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
            
            editButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func editButtonTapped(_ sender: UIButton) {
        // Reset all buttons appearance
        editButtons.forEach { button in
            button.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 0.9)
        }
        
        // Highlight selected button
        sender.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
        
        // Show/hide controls based on selection
        switch sender.tag {
        case 0: // Filters
            editingControlsView.isHidden = true
            filterCollectionView.isHidden = false
        case 1: // Brightness
            editingControlsView.isHidden = false
            filterCollectionView.isHidden = true
            // Show brightness controls
        case 2: // Contrast
            editingControlsView.isHidden = false
            filterCollectionView.isHidden = true
            // Show contrast controls
        case 3: // Saturation
            editingControlsView.isHidden = false
            filterCollectionView.isHidden = true
            // Show saturation controls
        default:
            break
        }
    }
    
    @objc private func previewButtonTapped() {
        guard let originalImage = originalImage else { return }
        
        isPreviewingOriginal.toggle()
        
        if isPreviewingOriginal {
            imageView.image = originalImage
            previewButton.setTitle("Düzenlenmiş", for: .normal)
        } else {
            applyFilter()
            previewButton.setTitle("Orijinal", for: .normal)
        }
        
        // Add animation
        UIView.transition(with: imageView,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: nil,
                         completion: nil)
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        applyFilter()
    }
    
    @IBAction func contrastChanged(_ sender: UISlider) {
        applyFilter()
    }
    
    private func applyFilter() {
        guard let originalImage = originalImage,
              let ciImage = CIImage(image: originalImage) else { return }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
        filter?.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
        
        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        imageView.image = UIImage(cgImage: cgImage)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
} 