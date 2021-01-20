//
//  ViewController.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 30.12.20.
//

import UIKit

func impact (style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

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
    
    var filterString: [String] = ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Community", "Offiziell"]
    
    var filterArray: [FilterButton] = []
    
    lazy var filterScrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        return view
    }()
    
    var navStackView = UIStackView()
    
    var stackView = UIStackView()
    
    var menuView = UIStackView()
    var menu = UIStackView()
    
    let tippCollectionVC = TippCollectionViewController(filter: ["Ernährung", "Transport", "Haushalt", "Ressourcen", "Leicht", "Mittel", "Schwer", "Community", "Offiziell"])
    
    let addTippButton = LabelButton(icon: "plus.circle", title: "Eigenen Tipp hinzufügen")
    
    let rateTippButton = LabelButton(icon: "hand.thumbsup", title: "Tipps von Nutzern bewerten")

    let menuTipps = MenuIcon(icon: "lightbulb", isSelected: true)
    let menuFacts = MenuIcon(icon: "doc.plaintext", isSelected: false)
    let menuLog = MenuIcon(icon: "book", isSelected: false)
    let menuProfile = MenuIcon(icon: "person", isSelected: false)
    
    lazy var sliderContainer: UIView = {
        let sliderContainer = UIView()
        sliderContainer.backgroundColor = .clear
        return sliderContainer
    }()
    
    lazy var slider: UIView = {
        let slider = UIView()
        slider.backgroundColor = .black
        slider.frame = CGRect(x: -50, y: 0, width: 30, height: 2)
        return slider
    }()
    
    let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.8)
    
    func configureNavStack() {
        view.addSubview(navStackView)
        navStackView.axis = .horizontal
        navStackView.distribution = .equalSpacing
        navStackView.translatesAutoresizingMaskIntoConstraints = false
        
        navStackView.addArrangedSubview(navText)
        navStackView.addArrangedSubview(UIView())
        navStackView.addArrangedSubview(navButton)
        
        NSLayoutConstraint.activate([
            navStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25),
            navStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 4),
            navStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func configureFilterScrollView() {
        
        for item in filterString {
            filterArray.append(FilterButton(filter: Filter(name: item, isSelected: true)))
        }
        
        filterScrollView.addSubview(filterLabel)
        firstPinEdges(of: filterLabel, to: filterScrollView, spacingTop: 5, spacingLeading: 20)
        

        for (index, element) in filterArray.enumerated() {
            element.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            filterScrollView.addSubview(element)
            if index > 0 {
                pinEdges(of: element, to: filterArray[index-1], spacingLeading: 10)
                if (index == filterArray.count - 1) {
                    pinEnd(of: element, to: filterScrollView, spacingEnd: -15)
                }
            } else {
                pinEdges(of: element, to: filterLabel, spacingLeading: 20)
            }
        }
    }
    
    @objc fileprivate func buttonTapped(_ sender: FilterButton){
        impact(style: .medium)
        sender.filter.isSelected.toggle()
        sender.backgroundColor = sender.filter.isSelected ? .white : .clear
        sender.filter.isSelected ? filterString.append(sender.filter.name) : filterString.removeAll(where: { $0 == sender.filter.name })
        Api().fetchFiltered(filter: filterString) { tipps in
            self.tippCollectionVC.tipps = tipps
            self.tippCollectionVC.collectionView.reloadData()
        }
        
    }
    
    func addTippCollVC() {
        addChild(tippCollectionVC)
        view.addSubview(tippCollectionVC.view)
        
        tippCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tippCollectionVC.view.topAnchor.constraint(equalTo: filterScrollView.layoutMarginsGuide.bottomAnchor, constant: 0),
            tippCollectionVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tippCollectionVC.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.1 + 30),
            tippCollectionVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tippCollectionVC.didMove(toParent: self)
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
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: tippCollectionVC.view.bottomAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func configureMenu(){
        view.addSubview(menuView)
        menuView.addSubview(menu)
//        menuView.addSubview(sliderContainer)
        
        menuView.axis = .vertical
        menuView.distribution = .fill
        menuView.spacing = 10
        
        menuView.addArrangedSubview(UIView())
        menuView.addArrangedSubview(menu)
        menuView.addArrangedSubview(sliderContainer)
        menuView.addArrangedSubview(UIView())
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.axis = .horizontal
        menu.distribution = .fillEqually
        menu.spacing = 10
        
        menu.addArrangedSubview(menuTipps)
        menu.addArrangedSubview(menuFacts)
        menu.addArrangedSubview(menuLog)
        menu.addArrangedSubview(menuProfile)
        
        menuTipps.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuFacts.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuLog.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuProfile.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        sliderContainer.addSubview(slider)
        sliderContainer.translatesAutoresizingMaskIntoConstraints = false
        
        //Add BackgroundColor to StackView
        menuView.insertCustomizedViewIntoStack(background: .white, cornerRadius: 20, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.1, shadowRadius: 10)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        stackView.addArrangedSubview(menuView)
    }
    
    @objc fileprivate func menuButtonTapped(_ sender: UIButton){
        impact(style: .medium)
        if let myIndex = menu.arrangedSubviews.firstIndex(of: sender) {
            animator.addAnimations {
                self.slider.center = CGPoint(x: self.menu.arrangedSubviews[myIndex].frame.midX, y: 0)
                for (index, element) in self.menu.subviews.enumerated() {
                    element.tintColor = index != myIndex ? .gray : .black
                }
            }
            animator.startAnimation()
        }
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
        
        
        //Add TippCollectionView
        addTippCollVC()
        
        //Add and Configure Buttons and MenuBar
        view.addSubview(stackView)
        configureBottomStackView()
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: navStackView.layoutMarginsGuide.bottomAnchor, constant: 10),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 55),
            filterScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animator.startAnimation()
            self.animator.addAnimations {
                self.slider.center = CGPoint(x: self.menu.arrangedSubviews[0].frame.midX, y: 0)
            }
        }
        
    }
    
    //Functions for UIScrollView pinning
    
    func pinEdges(of viewB: UIView, to viewA: UIView, spacingLeading: CGFloat) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.topAnchor.constraint(equalTo: viewA.topAnchor),
            viewB.leadingAnchor.constraint(equalTo: viewA.trailingAnchor, constant: spacingLeading),
            viewB.bottomAnchor.constraint(equalTo: viewA.bottomAnchor),
        ])
    }
    
    func firstPinEdges(of viewB: UIView, to viewA: UIView, spacingTop: CGFloat, spacingLeading: CGFloat) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.topAnchor.constraint(equalTo: viewA.topAnchor, constant: spacingTop),
            viewB.leadingAnchor.constraint(equalTo: viewA.leadingAnchor, constant: spacingLeading),
            viewB.bottomAnchor.constraint(equalTo: viewA.bottomAnchor),
        ])
    }
    
    func pinEnd(of viewB: UIView, to viewA: UIView, spacingEnd: CGFloat) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewB.trailingAnchor.constraint(equalTo: viewA.trailingAnchor, constant: spacingEnd)
        ])
    }
}

//Function for Adding Background

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
