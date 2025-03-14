//
//  FLCellSectionRouter.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.8.24..
//

final class FLCellSectionRouter: FLCellSectionRouterProtocol {
    
    private weak var navigation: FLNavigationProtocol?
    
    init(navigation: FLNavigationProtocol) {
        self.navigation = navigation
    }
    
    func showMessageView(text: String?, sender: UIView) {
        let controller = LabelViewController()
        controller.messageText = text
        navigation?.presentInPopover(controller,
                                     sender: sender,
                                     size: controller.getPreferredSize(fixedWidth: 300))
    }
}

private final class LabelViewController: NiblessViewController {
    
    private let label = UILabel()
    var messageText: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInfoLabel()
    }
    
    //MARK: - Private Methods
    
    private func setupInfoLabel() {
        label.textColor = .black
        label.numberOfLines = 0
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func getPreferredSize(fixedWidth: CGFloat) -> CGSize {
        guard let textSize = label.attributedText?.size() else {
            return .zero
        }
        return CGSize(width: fixedWidth, height: ((textSize.width * textSize.height) / fixedWidth) + 50)
    }
}
