//
//  FilterButton.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 07.01.21.
//

import UIKit

class FilterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, isSelected: Bool) {
        super.init(frame: .zero)
        setImage(UIImage.init(named: title), for: .normal)
        tintColor = .black
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.black, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -85, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 2, left: -30, bottom: 2, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25)
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = isSelected ? 0.1 : 0
        backgroundColor = isSelected ? .white : .clear
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc fileprivate func buttonTapped(){
        print(isSelected)
        isSelected = !isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

