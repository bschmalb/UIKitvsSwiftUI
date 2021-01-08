//
//  ViewController.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 30.12.20.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var navText: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        textLabel.text = "Tipps für Dich"
        textLabel.textColor = .black
        return textLabel
    }()
    
    lazy var navButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .black
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        return button
    }()
    
    lazy var filterLabel: UILabel = {
        let textLabel2 = UILabel()
        textLabel2.translatesAutoresizingMaskIntoConstraints = false
        textLabel2.textAlignment = .left
        textLabel2.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        textLabel2.text = "Filter:"
        textLabel2.textColor = .black
        return textLabel2
    }()
    
    lazy var textLabel3: UILabel = {
        let textLabel2 = UILabel()
        textLabel2.translatesAutoresizingMaskIntoConstraints = false
        textLabel2.textAlignment = .left
        textLabel2.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        textLabel2.text = "Tipps"
        textLabel2.textColor = .black
        return textLabel2
    }()
    
    var isSelectedArray: [Bool] = [true, true, true, true]
    
    lazy var testText: UILabel = {
        let textLabel2 = UILabel()
        textLabel2.translatesAutoresizingMaskIntoConstraints = false
        textLabel2.textAlignment = .left
        textLabel2.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        textLabel2.text = "TESTsadömlaw söldk ölaskd ölakds ölaksdölakds öalksdl öadk"
        textLabel2.textColor = .black
        return textLabel2
    }()
    
    
    lazy var filterViewSize = CGSize(width: self.view.frame.width + 400, height: 50)
    
    lazy var tippViewSize = CGSize(width: self.view.frame.width + 400, height: UIScreen.main.bounds.height / 2.1)
    
    lazy var filterScrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        view.contentSize = filterViewSize
        return view
    }()
    
    lazy var filterContainerView: UIView = {
        let view = UIView()
        view.frame.size = filterViewSize
        return view
    }()
    
    lazy var tippScrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height / 2.1)
        view.contentSize = tippViewSize
        return view
    }()
    
    lazy var tippContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")
        view.frame.size = tippViewSize
        return view
    }()
    
    var navStackView = UIStackView()
    
    var stackView = UIStackView()
    
    var menu = UIStackView()
    
    lazy var addTippButton: UIButton = {
        let button = LabelButton(icon: "plus.circle", title: "Eigene Tipps hinzufügen")
        return button
    }()
    
    lazy var rateTippButton: UIButton = {
        let button = LabelButton(icon: "hand.thumbsup", title: "Tipps von Nutzern bewerten")
        return button
    }()
    
    
    lazy var menuTipps: UIButton = {
        let button = MenuIcon(icon: "lightbulb", isSelected: true)
        return button
    }()
    
    lazy var menuFacts: UIButton = {
        let button = MenuIcon(icon: "doc.plaintext", isSelected: false)
        return button
    }()
    
    lazy var menuLog: UIButton = {
        let button = MenuIcon(icon: "book", isSelected: false)
        return button
    }()
    
    lazy var menuProfile: UIButton = {
        let button = MenuIcon(icon: "person", isSelected: false)
        return button
    }()
    
    
    func configureNavStack() {
        view.addSubview(navStackView)
        navStackView.axis = .horizontal
        navStackView.distribution = .equalSpacing
        navStackView.translatesAutoresizingMaskIntoConstraints = false
        
        navStackView.addArrangedSubview(navText)
        navStackView.addArrangedSubview(UIView())
        navStackView.addArrangedSubview(navButton)
        
        NSLayoutConstraint.activate([
            navStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            navStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            navStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func configureFilterScrollView() {
        
        let button = FilterButton(title: "Ernährung", isSelected: isSelectedArray[0])
        let button2 = FilterButton(title: "Transport", isSelected: isSelectedArray[1])
        let button3 = FilterButton(title: "Haushalt", isSelected: isSelectedArray[2])
        let button4 = FilterButton(title: "Ressourcen", isSelected: isSelectedArray[3])
        
        let array: [UIButton] = [button, button2, button3, button4]
        
        filterScrollView.addSubview(filterLabel)
        firstPinEdges(of: filterLabel, to: filterScrollView)
        
        for (index, element) in array.enumerated() {
            filterScrollView.addSubview(element)
            if index > 0 {
                pinEdges(of: array[index], to: array[index-1])
                if (index == array.count - 1) {
                    pinEnd(of: element, to: filterScrollView)
                }
            } else {
                pinEdges(of: array[index], to: filterLabel)
            }
            
//            if index > 0 {
//                pinEdges(of: array[index], to: array[index-1])
//                if (index == array.count - 1) {
//                    pinEnd(of: element, to: filterScrollView)
//                }
//            } else {
//                firstPinEdges(of: element, to: filterScrollView)
//            }
        }
    }

    
    func configureBottomStackView(){
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add Bottom Buttons
        stackView.addArrangedSubview(addTippButton)
        stackView.addArrangedSubview(rateTippButton)
        
        //Add Spacer
        stackView.addArrangedSubview(UIView())
        
        //Add and Setup TabBar Menu
        configureMenu()
        
        //Set Constraints
        stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: tippScrollView.bottomAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func configureMenu(){
        view.addSubview(menu)
        menu.axis = .horizontal
        menu.distribution = .fillEqually
        menu.spacing = 10
        
        //Add BackgroundColor to StackView
        menu.insertCustomizedViewIntoStack(background: .white, cornerRadius: 20, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 10)
        
        menu.addArrangedSubview(menuTipps)
        menu.addArrangedSubview(menuFacts)
        menu.addArrangedSubview(menuLog)
        menu.addArrangedSubview(menuProfile)
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stackView.addArrangedSubview(menu)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        
        //Add NavBar
        view.addSubview(navStackView)
        configureNavStack()
        
        //Add FilterScroll
        view.addSubview(filterScrollView)
        configureFilterScrollView()
        
        //Add TippScroll
        view.addSubview(tippScrollView)
        tippScrollView.addSubview(tippContainerView)
        tippContainerView.addSubview(textLabel3)
        
        //Add and Configure Buttons and MenuBar
        view.addSubview(stackView)
        configureBottomStackView()
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: navStackView.layoutMarginsGuide.bottomAnchor, constant: 10),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 60),
            filterScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            textLabel3.topAnchor.constraint(equalTo: tippContainerView.layoutMarginsGuide.topAnchor),
            textLabel3.leadingAnchor.constraint(equalTo: tippContainerView.layoutMarginsGuide.leadingAnchor),
            tippScrollView.topAnchor.constraint(equalTo: filterScrollView.layoutMarginsGuide.bottomAnchor, constant: 10),
            tippScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tippScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.1),
            tippScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    
    //Functions for UIScrollView pinning
    
    func pinEdges(of viewB: UIView, to viewA: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.topAnchor.constraint(equalTo: viewA.topAnchor),
            viewB.leadingAnchor.constraint(equalTo: viewA.trailingAnchor, constant: 10),
            viewB.bottomAnchor.constraint(equalTo: viewA.bottomAnchor),
        ])
    }
    
    func firstPinEdges(of viewB: UIView, to viewA: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.topAnchor.constraint(equalTo: viewA.topAnchor, constant: 10),
            viewB.leadingAnchor.constraint(equalTo: viewA.leadingAnchor, constant: 20),
            viewB.bottomAnchor.constraint(equalTo: viewA.bottomAnchor),
        ])
    }
    
    func pinEnd(of viewB: UIView, to viewA: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.trailingAnchor.constraint(equalTo: viewA.trailingAnchor, constant: -30)
        ])
    }
}

extension UIStackView {
func insertCustomizedViewIntoStack(background: UIColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = cornerRadius
        subView.backgroundColor = background
        subView.layer.shadowColor = shadowColor
        subView.layer.shadowOpacity = shadowOpacity
        subView.layer.shadowOffset = .zero
        subView.layer.shadowRadius = shadowRadius
        insertSubview(subView, at: 0)
    }
}
