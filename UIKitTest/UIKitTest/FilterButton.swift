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
    
    var filter: Filter = Filter(name: "Test", isSelected: false)
    
    init(filter: Filter) {
        super.init(frame: .zero)
        self.filter = filter
        setImage(UIImage.init(named: filter.name), for: .normal)
        tintColor = .black
        setTitle(filter.name, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.black, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -110, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 5, left: -55, bottom: 5, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -45)
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.1
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Filter {
    var name: String
    var isSelected: Bool
}
