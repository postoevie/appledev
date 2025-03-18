//
//  FLSectionView.swift
//  FlexLayout
//
//  Created by Igor Postoev on 29.2.24..
//

import SnapKit

final class FLSectionView: NiblessView {
    
    private var body = UIView()
    
    init(accessKey: String) {
        super.init()
        accessibilityIdentifier = accessKey
    }
    
    func set(body: UIView) {
        self.body = body
        subviews.forEach {
            $0.removeFromSuperview()
        }
        addSubview(body)
        body.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
