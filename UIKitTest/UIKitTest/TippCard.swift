//
//  TippCard.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 08.01.21.
//

import UIKit

class TippCard: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var tipp: Tipp = Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: "")
    
    var options: Bool = false
    let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.8)
    var main: TippCardMain = TippCardMain(tipp: Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: ""), cardColor: "cardgreen")
    var backCard: TippCardBack = TippCardBack(tipp: Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: ""), cardColor: "cardgreen")
    
    init(tipp: Tipp, cardColor: String) {
        super.init(frame: .zero)
        
        self.tipp = tipp
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.1).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        
        backCard = TippCardBack(tipp: tipp, cardColor: cardColor)
        addSubview(backCard)
        backCard.translatesAutoresizingMaskIntoConstraints = false
        backCard.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        backCard.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        main = TippCardMain(tipp: tipp, cardColor: cardColor)
        addSubview(main)
        main.translatesAutoresizingMaskIntoConstraints = false
        main.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        main.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        main.optionsButton.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
        backCard.closeOptions.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
    }
    
    @objc fileprivate func optionsTapped(_ sender: UIButton){
        impact(style: .medium)
        animator.addAnimations { [self] in
            main.transform = CGAffineTransform(translationX: options ? 0 : -frame.size.width / 1.3, y: 0)
            options.toggle()
        }
        
        self.animator.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TippCardMain: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var tipp: Tipp = Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: "")
    
    var mainStackView = UIStackView()
    
    var topRowStack = UIStackView()
    
    var liked: Bool = false
    var saved: Bool = false
    let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.8)
    
    lazy var optionsButton: UIButton = {
        let optionsButton: UIButton = UIButton()
        optionsButton.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default)), for: .normal)
        optionsButton.tintColor = .black
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        return optionsButton
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)), for: .normal)
        likeButton.tintColor = .black
        likeButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return likeButton
    }()
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setImage(UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)), for: .normal)
        saveButton.tintColor = .black
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return saveButton
    }()
    
    @objc fileprivate func likeTapped(_ sender: UIButton){
        impact(style: .medium)
        animator.addAnimations { [self] in
            sender.transform = CGAffineTransform(rotationAngle: liked ? CGFloat(Double.pi) : 0)
            sender.tintColor = liked ? .black : .white
            sender.setImage(UIImage(systemName: liked ? "plus" : "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)), for: .normal)
            liked.toggle()
        }
        self.animator.startAnimation()
    }
    
    @objc fileprivate func saveTapped(_ sender: UIButton){
        impact(style: .medium)
        animator.addAnimations { [self] in
            sender.transform = CGAffineTransform(scaleX: saved ? 1 : 1.1, y: saved ? 1 : 1.1)
            sender.tintColor = saved ? .black : .white
            saved.toggle()
        }
        self.animator.startAnimation()
    }
    
    func addTopStack() {
        let categoryIcon: UIImageView = UIImageView()
        categoryIcon.image = UIImage(named: tipp.category)
        categoryIcon.contentMode = .scaleAspectFit
        categoryIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        categoryIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let levelIcon: UIImageView = UIImageView()
        levelIcon.image = UIImage(named: tipp.level)
        levelIcon.contentMode = .scaleAspectFit
        levelIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        levelIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let posterIcon: UIImageView = UIImageView()
        posterIcon.image = UIImage(named: tipp.official)
        posterIcon.contentMode = .scaleAspectFit
        posterIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        posterIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(topRowStack)
        topRowStack.axis = .horizontal
        topRowStack.distribution = .fill
        topRowStack.spacing = -5
        topRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        topRowStack.addArrangedSubview(categoryIcon)
        topRowStack.addArrangedSubview(levelIcon)
        topRowStack.addArrangedSubview(posterIcon)
        topRowStack.addArrangedSubview(UIView())
        topRowStack.addArrangedSubview(optionsButton)
        
        topRowStack.alpha = 0.1
        
        NSLayoutConstraint.activate([
            topRowStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topRowStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 15),
            topRowStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30)
        ])
    }
    
    func addTipp() {
        let tippImage: UIImageView = UIImageView()
        tippImage.image = UIImage(named: "I" + tipp.category)?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
        tippImage.contentMode = .scaleAspectFill
        tippImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5.2).isActive = true
        
        let tippTitle = UITextView()
        tippTitle.text = tipp.title
        tippTitle.font = UIFont.systemFont(ofSize: 24 - CGFloat(tipp.title.count / 25), weight: UIFont.Weight.medium)
        tippTitle.textAlignment = .center
        tippTitle.textColor = .black
        tippTitle.backgroundColor = .clear
        tippTitle.isScrollEnabled = false
        tippTitle.isEditable = false
        tippTitle.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let quelleLabel = UILabel()
        quelleLabel.text = "Quelle"
        quelleLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        quelleLabel.textColor = .gray
        quelleLabel.textAlignment = .center
        
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(likeButton)
        buttonStack.addArrangedSubview(saveButton)
        
        mainStackView.addArrangedSubview(UIView())
        addSubview(tippImage)
        mainStackView.addArrangedSubview(UIView())
        addSubview(tippTitle)
        addSubview(quelleLabel)
        addSubview(buttonStack)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(tippImage)
        mainStackView.addArrangedSubview(tippTitle)
        if tipp.source.count > 2 {
            mainStackView.addArrangedSubview(quelleLabel)
        }
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(buttonStack)
    }
    
    init(tipp: Tipp, cardColor: String) {
        super.init(frame: .zero)
        
        if tipp.title.count > 0 {
            self.tipp = tipp
            
            backgroundColor = UIColor(named: cardColor)
            layer.cornerRadius = 15
            
            addSubview(mainStackView)
            mainStackView.axis = .vertical
            mainStackView.distribution = .fill
            mainStackView.spacing = 10
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
            ])
            
            addTopStack()
            
            addTipp()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TippCardBack: UIStackView {
    
    var tipp: Tipp = Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: "")
    
    var backStackView = UIStackView()
    
    var topRowStack = UIStackView()
    
    var posterInfoStack = UIStackView()
    
    var buttonStack = UIStackView()
    
    lazy var closeOptions: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.alpha = 0.1
        return button
    }()
    
    lazy var gepostedText: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        textLabel.text = "Gepostet von:"
        textLabel.textColor = .gray
        return textLabel
    }()
    
    lazy var posterName: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        textLabel.text = ""
        textLabel.textColor = .black
        return textLabel
    }()
    
    lazy var posterAgeGender: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        textLabel.text = ""
        textLabel.textColor = .black
        return textLabel
    }()
    
    let ratePositive = TippCardLabelButton(icon: "hand.thumbsup", title: "Positiv bewerten", color: UIColor.black)
    
    let rateNegative = TippCardLabelButton(icon: "hand.thumbsdown", title: "Negativ bewerten", color: UIColor.black)
    
    let rateReport = TippCardLabelButton(icon: "flag", title: "Diesen Tipp melden", color: UIColor.red)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(tipp: Tipp, cardColor: String) {
        super.init(frame: .zero)
        
        self.tipp = tipp
        
        getPoster()
        
        backgroundColor = UIColor(named: cardColor)?.darker(by: 5)
        layer.cornerRadius = 15
        
        addSubview(backStackView)
        backStackView.axis = .vertical
        backStackView.distribution = .equalSpacing
        backStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            backStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.3),
            backStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35)
        ])
        
        addTopRowStack()
    
        addPosterStack()
        
        addButtonStack()
    }
    
    func addTopRowStack(){
        topRowStack.axis = .horizontal
        topRowStack.distribution = .fill
        topRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        topRowStack.addArrangedSubview(UIView())
        topRowStack.addArrangedSubview(closeOptions)
        
        backStackView.addArrangedSubview(topRowStack)
    }
    
    func addPosterStack(){
        posterInfoStack.axis = .vertical
        posterInfoStack.spacing = 5
        posterInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        posterInfoStack.addArrangedSubview(gepostedText)
        posterInfoStack.addArrangedSubview(posterName)
        posterInfoStack.addArrangedSubview(posterAgeGender)
        
        backStackView.addArrangedSubview(posterInfoStack)
    }
    
    func addButtonStack() {
        buttonStack.axis = .vertical
        buttonStack.spacing = 3
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(ratePositive)
        buttonStack.addArrangedSubview(rateNegative)
        buttonStack.addArrangedSubview(rateReport)
        
        ratePositive.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rateNegative.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rateReport.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        backStackView.addArrangedSubview(buttonStack)
    }
    
    @objc fileprivate func buttonTapped(_ sender: TippCardLabelButton){
        impact(style: .medium)
        sender.icon = sender.icon.contains(".fill") ? String(sender.icon.prefix(sender.icon.count - 5)) : sender.icon + ".fill"
        sender.setImage(UIImage(systemName: sender.icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)), for: .normal)
    }
    
    func getPoster() {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + tipp.postedBy) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        self.posterName.text = user.name
                        self.posterAgeGender.text = "\(user.gender ?? "") \(user.age ?? "")"
                    }
                    return
                }
            }
        }
        .resume()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

class TippCardLabelButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var icon: String = ""
    
    init(icon: String, title: String, color: UIColor) {
        self.icon = icon
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)), for: .normal)
        tintColor = color
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        setTitleColor(color, for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0);
        contentHorizontalAlignment = .center
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
