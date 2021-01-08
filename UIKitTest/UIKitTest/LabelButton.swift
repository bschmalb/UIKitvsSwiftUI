//
//  LabelButton.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 05.01.21.
//

import UIKit

class LabelButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(icon: String, title: String) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)), for: .normal)
        tintColor = .black
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.black, for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0);
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -10);
        contentHorizontalAlignment = .left
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
