import UIKit

class ToolButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        titleLabel?.font = .systemFont(ofSize: 12)
        titleLabel?.textAlignment = .center
        tintColor = Constants.Colors.unselectedTool
        setTitleColor(Constants.Colors.unselectedTool, for: .normal)
        
        titleEdgeInsets = UIEdgeInsets(top: 30, left: -25, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
    }
    
    func setSelected(_ isSelected: Bool) {
        tintColor = isSelected ? Constants.Colors.selectedTool : Constants.Colors.unselectedTool
        setTitleColor(isSelected ? Constants.Colors.selectedTool : Constants.Colors.unselectedTool, for: .normal)
    }
} 