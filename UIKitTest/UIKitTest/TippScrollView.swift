//
//  TippScrollView.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 08.01.21.
//

import Foundation
import UIKit

class TippCollectionViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cardColors: [String]  = [
        "cardgreen", "cardblue", "cardyellow", "cardpurple", "cardorange", "cardred", "cardturqouise", "cardyelgre", "cardpink"
    ]
    
    var tipps: [Tipp] = [Tipp]()
    var filter: [String] = []
    
    var collectionView: UICollectionView!
    
    convenience init(filter: [String]) {
        self.init(nibName:nil, bundle:nil)
        Api().fetchFiltered(filter: filter) { tipps in
            self.tipps = tipps
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tipps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! TippCell
        collectionCell.configure(tipp: tipps[indexPath.row], cardColor: cardColors[indexPath.row % cardColors.count])
        collectionCell.prepareForReuse()
        return collectionCell
    }
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.height/2.1 + 20)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: -25, right: -15)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(TippCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2.1 + 20)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

class TippCell: UICollectionViewCell {
    
    var tipp: Tipp = Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: "")
    var cardColor: String = "cardred"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(tipp: Tipp, cardColor: String) {
        self.tipp = tipp
        self.cardColor = cardColor
        
        let card = TippCard(tipp: tipp, cardColor: cardColor)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(card)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tipp = Tipp(_id: "", title: "", source: "", level: "", category: "", score: 12, postedBy: "", official: "")
        self.cardColor = ""
    }
}
