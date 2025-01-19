import UIKit

class EditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbarStack: UIStackView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var sliderStack: UIStackView!
    @IBOutlet weak var checkButton: UIButton!
    
    var selectedImage: UIImage?
    
    // Filtreler için array'i tekrar ekleyelim
    private var filters: [(String, CIFilter?)] = [
        ("Original", nil),
        ("Mono", CIFilter(name: "CIPhotoEffectMono")),
        ("Noir", CIFilter(name: "CIPhotoEffectNoir")),
        ("Fade", CIFilter(name: "CIPhotoEffectFade")),
        ("Chrome", CIFilter(name: "CIPhotoEffectChrome")),
        ("Instant", CIFilter(name: "CIPhotoEffectInstant")),
        ("Tonal", CIFilter(name: "CIPhotoEffectTonal")),
        ("Transfer", CIFilter(name: "CIPhotoEffectTransfer"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupSliders()
        setupToolbar()
    }
    
    private func setupUI() {
        // Koyu arka plan
        view.backgroundColor = .black
        
        // ImageView ayarları
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Check button ayarları
        checkButton.tintColor = .systemBlue
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        // Toolbar'ı başlangıçta göster
        toolbarStack.isHidden = false
        filterCollectionView.isHidden = true
        sliderStack.isHidden = true
        
        // Yarı saydam arka planlar
        toolbarStack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        filterCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sliderStack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func setupToolbar() {
        let tools = ["Crop", "Canvas", "Filters", "Effect", "Text", "Frame"]
        
        tools.forEach { tool in
            let button = UIButton(type: .system)
            button.setTitle(tool, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12)
            
            let iconName: String
            switch tool {
            case "Crop": iconName = "crop"
            case "Canvas": iconName = "square.and.pencil"
            case "Filters": iconName = "wand.and.stars"
            case "Effect": iconName = "sparkles"
            case "Text": iconName = "textformat"
            case "Frame": iconName = "square.on.square"
            default: iconName = ""
            }
            
            button.setImage(UIImage(systemName: iconName), for: .normal)
            button.tintColor = .white
            button.centerImageAndButton(spacing: 5)
            button.addTarget(self, action: #selector(toolButtonTapped(_:)), for: .touchUpInside)
            
            toolbarStack.addArrangedSubview(button)
        }
    }
    
    @objc private func checkButtonTapped() {
        // Düzenlemeyi tamamla ve geri dön
        dismiss(animated: true)
    }
    
    @objc private func toolButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        // Tüm view'ları göster
        UIView.animate(withDuration: 0.3) {
            self.toolbarStack.isHidden = false
            
            switch title {
            case "Filters":
                self.filterCollectionView.isHidden = false
                self.sliderStack.isHidden = true
            case "Effect":
                self.filterCollectionView.isHidden = true
                self.sliderStack.isHidden = false
            default:
                self.filterCollectionView.isHidden = true
                self.sliderStack.isHidden = true
            }
        }
    }
    
    private func setupCollectionView() {
        filterCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), 
                                    forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.isHidden = true
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, 
                                                          for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = selectedImage {
            if let filter = filters[indexPath.item].1 {
                let filteredImage = applyFilter(filter, to: image)
                cell.configure(with: filteredImage ?? image)
            } else {
                cell.configure(with: image)
            }
        }
        
        return cell
    }
    
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = selectedImage {
            if let filter = filters[indexPath.item].1 {
                imageView.image = applyFilter(filter, to: image)
            } else {
                imageView.image = image
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
    
    private func setupSliders() {
        let sliders = [
            ("Contrast", createSlider()),
            ("Shadow", createSlider()),
            ("Brightness", createSlider())
        ]
        
        sliders.forEach { title, slider in
            let containerStack = UIStackView()
            containerStack.axis = .horizontal
            containerStack.spacing = 10
            
            let label = UILabel()
            label.text = title
            label.textColor = .label
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            containerStack.addArrangedSubview(label)
            containerStack.addArrangedSubview(slider)
            
            sliderStack.addArrangedSubview(containerStack)
        }
        
        sliderStack.isHidden = true // Başlangıçta gizli olsun
    }
    
    private func createSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        guard let image = selectedImage else { return }
        
        // Slider'ın parent stack view'ını bul
        if let stackView = slider.superview as? UIStackView,
           let label = stackView.arrangedSubviews.first as? UILabel {
            
            switch label.text {
            case "Contrast":
                adjustContrast(value: slider.value)
            case "Shadow":
                adjustShadow(value: slider.value)
            case "Brightness":
                adjustBrightness(value: slider.value)
            default:
                break
            }
        }
    }
    
    private func adjustContrast(value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2, forKey: kCIInputContrastKey) // 0-2 aralığı için
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
    
    private func adjustShadow(value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2 - 1, forKey: "inputShadowAmount") // -1 to 1 aralığı için
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
    
    private func adjustBrightness(value: Float) {
        guard let image = selectedImage else { return }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(value * 2 - 1, forKey: kCIInputBrightnessKey) // -1 to 1 aralığı için
        
        if let outputImage = filter?.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
}

// UIButton extension - icon ve text'i dikey hizalamak için
extension UIButton {
    func centerImageAndButton(spacing: CGFloat = 6.0) {
        guard let imageView = self.imageView,
              let titleLabel = self.titleLabel else { return }
        
        if let imageSize = imageView.image?.size,
           let font = titleLabel.font {
            let titleSize = titleLabel.text?.size(withAttributes: [.font: font]) ?? .zero
            
            let totalHeight = imageSize.height + spacing + titleSize.height
            
            self.imageEdgeInsets = UIEdgeInsets(
                top: -(totalHeight - imageSize.height),
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )
            
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageSize.width,
                bottom: -(totalHeight - titleSize.height),
                right: 0
            )
        }
    }
} 
