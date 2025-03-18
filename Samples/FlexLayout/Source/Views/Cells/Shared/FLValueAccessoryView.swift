//
//  FLValueAccessoryView.swift
//  FlexLayout
//
//  Created by Igor Postoev on 20.3.24..
//

import SnapKit

final class FLValueAccessoryView<Delegate: FLSingleValueViewDelegate>: NiblessView {
    
    weak var delegate: Delegate?
    
    var appliedConfiguration: FLValueAccessoryConfiguration<Delegate> = FLValueAccessoryConfiguration(delegate: nil,
                                                                                                      itemId: Delegate.ItemId(),
                                                                                                      validationText: nil,
                                                                                                      validationIconColor: .clear) {
        didSet {
            updateAccessoryViews()
        }
    }
    
    private var validationShownConstraint: Constraint?
    private var validationHiddenConstraint: Constraint?
    
    private lazy var validationIndicator = createValidationView()
    
    override init() {
        super.init()
        addSubview(validationIndicator)
        validationIndicator.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            validationShownConstraint = $0.width.equalTo(24).priority(.prerequired).constraint
            validationHiddenConstraint = $0.width.equalTo(0).priority(.low).constraint
        }
    }
    
    func createValidationView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = appliedConfiguration.validationIconColor
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tappedValidation))
        imageView.addGestureRecognizer(recognizer)
        return imageView
    }
    
    @objc func tappedValidation(_ sender: UITapGestureRecognizer) {
        if let text = appliedConfiguration.validationText {
            delegate?.tappedValidationView(message: text, in: validationIndicator)
        }
    }
 
    func updateAccessoryViews() {
        delegate = appliedConfiguration.delegate
        
        validationIndicator.tintColor = appliedConfiguration.validationIconColor
        
        let validationHidden = appliedConfiguration.validationText == nil
        validationShownConstraint?.update(priority: validationHidden ? .low : .prerequired)
        validationHiddenConstraint?.update(priority: validationHidden ? .prerequired : .low)
    }
}
