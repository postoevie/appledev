//
//  FLTitledValueContentView.swift
//  FlexLayout
//
//  Created by Igor Postoev on 20.3.24..
//

import SnapKit

class FLTitledValueContentView<Delegate: FLSingleValueViewDelegate>: NiblessView,
                                                                     UIContentView {
    
    private let paddingGuide = UILayoutGuide()
    private let titleGuide = UILayoutGuide()
    private let titleLabel = createTitleView()
    
    private let valueView = FLSingleValueView<Delegate>()
    private let accessoryView = FLValueAccessoryView<Delegate>()
    
    var appliedConfiguration: FLTitledValueContentConfiguration<Delegate> = FLTitledValueContentConfiguration(uid: Delegate.ItemId(),
                                                                                                              data: FLSingleValueCellData(value: .empty, layout: .empty),
                                                                                                              style: FLCellStyle(),
                                                                                                              title: "",
                                                                                                              validationErrorText: "")
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? FLTitledValueContentConfiguration<Delegate> else { return }
            apply(configuration: newConfig)
        }
    }
    
    var style: FLCellStyle {
        appliedConfiguration.style
    }
    
    var data: FLSingleValueCellData {
        appliedConfiguration.data
    }
    
    init(configuration: UIContentConfiguration) {
        super.init()
        addLayoutGuide(paddingGuide)
        addLayoutGuide(titleGuide)
        addSubview(titleLabel)
        addSubview(accessoryView)
        addSubview(valueView)
        setupConstraints()
        self.configuration = configuration
    }
    
    func setupConstraints() {
        paddingGuide.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        let paddingGuide = paddingGuide
        titleGuide.snp.makeConstraints {
            $0.top.equalTo(paddingGuide)
            $0.leading.equalTo(paddingGuide)
            $0.height.equalTo(paddingGuide).multipliedBy(0.5)
        }
        accessoryView.snp.makeConstraints {
            $0.trailing.equalTo(paddingGuide)
            $0.height.equalTo(24)
            $0.leading.equalTo(titleGuide.snp.trailing)
            $0.centerY.equalTo(titleGuide.snp.centerY)
        }
        titleLabel.snp.remakeConstraints {
            $0.leading.equalTo(titleGuide.snp.leading)
            $0.trailing.equalTo(titleGuide.snp.trailing)
            $0.centerY.equalTo(titleGuide.snp.centerY)
            $0.height.lessThanOrEqualTo(titleGuide.snp.height)
        }
        valueView.snp.makeConstraints {
            $0.top.equalTo(titleGuide.snp.bottom)
            $0.bottom.equalTo(paddingGuide)
            $0.leading.trailing.equalTo(paddingGuide)
        }
    }
    
    static func createTitleView() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
    
    private func apply(configuration: FLTitledValueContentConfiguration<Delegate>) {
        appliedConfiguration = configuration
        accessibilityIdentifier = "\(configuration.data.accessKey).titledValueCell"
        updateAccessoryViews()
        updateTitleView()
        updateValueView()
    }
    
    func updateAccessoryViews() {
        accessoryView.appliedConfiguration = FLValueAccessoryConfiguration(delegate: appliedConfiguration.delegate,
                                                                           itemId: appliedConfiguration.uid,
                                                                           validationText: appliedConfiguration.validationErrorText,
                                                                           validationIconColor: style.validationColor)
    }
    
    func updateTitleView() {
        guard let title = appliedConfiguration.title else {
            titleLabel.text = nil
            return
        }
        titleLabel.font = style.titleTextAttributes.font
        titleLabel.textColor = style.titleTextAttributes.color
        titleLabel.text = title
    }
    
    func updateValueView() {
        valueView.appliedConfiguration = FLSingleValueConfiguration(delegate: appliedConfiguration.delegate,
                                                                    uid: appliedConfiguration.uid,
                                                                    data: data,
                                                                    style: appliedConfiguration.style)
    }
}

extension ConstraintPriority {
    
    static var prerequired: ConstraintPriority {
        999.0
    }
}
