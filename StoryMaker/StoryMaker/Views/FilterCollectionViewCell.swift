import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterCollectionViewCell"
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.contentMode = .scaleAspectFill
        filterImageView.clipsToBounds = true
        filterImageView.layer.cornerRadius = 8
    }
    
    func configure(with image: UIImage) {
        filterImageView.image = image
    }
} 