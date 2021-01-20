//
//  TippData.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 08.01.21.
//

import Foundation

struct Tipp: Codable, Hashable, Identifiable{
    var id = UUID()
    let _id: String
    let title: String
    let source: String
    let level: String
    let category: String
    var score: Int16
    var postedBy: String
    var isChecked: Bool = false
    var isBookmarked: Bool = false
    var official: String
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case _id, title, source, level, category, score, postedBy, official
    }
}

class Api {
    var tippUrl: String = "https://sustainablelife.herokuapp.com/tipps?"
    
    func fetchFiltered(filter: [String], completion: @escaping ([Tipp]) -> ()) {
        for i in filter {
            if (i == "Ernährung" || i == "Haushalt" || i == "Transport" || i == "Ressourcen") {
                tippUrl.append("category=")
            } else if (i == "Leicht" || i == "Mittel" || i == "Schwer") {
                tippUrl.append("level=")
            } else if (i == "Community" || i == "Offiziell") {
                tippUrl.append("official=")
            }
            tippUrl.append(i)
            if (i != filter[filter.count-1]){
                tippUrl.append("&")
            } else{
                tippUrl.append("&minscore=20")
            }
        }
        if !tippUrl.contains("category") {
            tippUrl.append("&")
            tippUrl.append("category=none")
        }
        if !tippUrl.contains("level") {
            tippUrl.append("&")
            tippUrl.append("level=none")
        }
        if !tippUrl.contains("official") {
            tippUrl.append("&")
            tippUrl.append("official=none")
        }
        guard let url = URL(string: tippUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) else {
            print("can not convert String to URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            if let tipps = try? JSONDecoder().decode([Tipp].self, from: data) {
                DispatchQueue.main.async {
                    completion(tipps)
                }
                return
            }
        }
        .resume()
    }
}
