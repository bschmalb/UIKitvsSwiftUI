//
//  MenuIcon.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 05.01.21.
//

import UIKit

class MenuIcon: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(icon: String, isSelected: Bool) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)), for: .normal)
        tintColor = isSelected ? .black : .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
