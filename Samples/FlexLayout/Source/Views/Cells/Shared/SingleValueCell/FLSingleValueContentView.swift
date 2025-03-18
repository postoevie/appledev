//
//  FLPlainContentView.swift
//  FlexLayout
//
//  Created by Igor Postoev on 8.2.24..
//

import SnapKit

final class FLSingleValueView<Delegate: FLSingleValueViewDelegate>: NiblessView, UITextFieldDelegate {
    
    typealias ItemId = Delegate.ItemId
    
    weak var delegate: Delegate?
    
    private var valueView = UIView()
    
    var appliedConfiguration: FLSingleValueConfiguration<Delegate> = FLSingleValueConfiguration(delegate: nil,
                                                                                                uid: Delegate.ItemId(),
                                                                                                data: FLSingleValueCellData(value: .empty, layout: .empty),
                                                                                                style: FLCellStyle()) {
        didSet {
            delegate = appliedConfiguration.delegate
            let oldDataValue = oldValue.data.value
            let newDataValue = appliedConfiguration.data.value
            if !oldDataValue.isSameType(value: newDataValue) {
                createAndSetValueView(appliedConfiguration)
            }
            isUserInteractionEnabled = !appliedConfiguration.data.readonly
            accessibilityIdentifier = appliedConfiguration.data.accessKey
            updateValueView()
        }
    }
    
    private var style: FLCellStyle {
        appliedConfiguration.style
    }
    
    private var accessKey: String {
        appliedConfiguration.data.accessKey
    }
    
    override init() {
        super.init()
        addSubview(valueView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewAreaTapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func viewAreaTapped(_ recognizer: UITapGestureRecognizer) {
        switch valueView {
        case let textField as UITextField:
            textField.becomeFirstResponder()
        case let numeric as FLNumericValueView<ItemId>:
            numeric.textField.becomeFirstResponder()
        default:
            break
        }
    }
    
    private func updateValueView() {
        let value = appliedConfiguration.data.value
        switch (valueView, value) {
        case (let view as FLNumericValueView<ItemId>, .text(let string)):
            updateNumericView(view, text: string)
        case (let textField as UITextField, .text(let string)):
            updateTextField(textField, text: string)
        case (let switcher as UISwitch, .boolean(let boolean)):
            updateSwitch(switcher, value: boolean)
        case (_, .empty):
            break
        default:
            assertionFailure("Non-valid uiview-value pair")
        }
    }
    
    private func updateNumericView(_ view: FLNumericValueView<ItemId>, text: String?) {
        view.uid = appliedConfiguration.uid
        updateTextField(view.textField, text: text)
        view.setAccessKey(accessKey)
    }
    
    private func createNumericView() -> FLNumericValueView<ItemId> {
        FLNumericValueView(textField: createTextField())
    }
    
    func createAndSetValueView(_ configuration: FLSingleValueConfiguration<Delegate>) {
        let newValueView: UIView = {
            let value = configuration.data.value
            let layout = configuration.data.layout
            switch (value, layout) {
            case (.text, .number):
                return createNumericView()
            case (.text, _):
                return createTextField()
            case (.boolean, _):
                return createSwitch()
            default:
                return UIView()
            }
        }()
        valueView.removeFromSuperview()
        valueView = newValueView
        addSubview(newValueView)
        setupConstraints(configuration.data.layout)
    }
    
    private func setupConstraints(_ layout: FLValueLayoutType) {
        valueView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Subviews setup
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", primaryAction: UIAction(handler: { [weak textField] _ in
            textField?.resignFirstResponder()
        }))
        toolbar.setItems([spacer, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        return textField
    }
    
    private func updateTextField(_ textField: UITextField, text: String?) {
        textField.text = text
        textField.backgroundColor = style.backgroundColor
        textField.font = style.valueTextAttributes.font
        textField.textColor = style.valueTextAttributes.color
        textField.isEnabled = !appliedConfiguration.data.readonly
        textField.accessibilityIdentifier = "\(accessKey).textField"
    }
    
    private func createSwitch() -> UISwitch {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switcher
    }
    
    private func updateSwitch(_ switcher: UISwitch, value: Bool) {
        switcher.isOn = value
        switcher.isEnabled = !appliedConfiguration.data.readonly
        switcher.accessibilityIdentifier = "\(accessKey).switch"
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        delegate?.valueChanged(itemId: appliedConfiguration.uid, value: .boolean(sender.isOn))
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.valueChanged(itemId: appliedConfiguration.uid, value: .text(textField.text))
    }
}

private final class FLNumericValueView<Id>: NiblessView {
    
    var uid: Id?
    
    let textField: UITextField
    let stackView = UIStackView()
    
    init(textField: UITextField) {
        self.textField = textField
        super.init()
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(UIView())
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        accessibilityIdentifier = "numeric_value_view"
    }
    
    func setAccessKey(_ key: String) {
        accessibilityIdentifier = "\(key).numberview"
        
        stackView.accessibilityIdentifier = "\(key).stack"
        
        textField.accessibilityIdentifier = "\(key).numberview.textfield"
    }
}
