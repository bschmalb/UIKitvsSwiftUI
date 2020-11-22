//
//  TippData.swift
//  SwiftUITest
//
//  Created by Bastian Schmalbach on 22.11.20.
//

import Foundation
import SwiftUI

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
    func fetchTipps(completion: @escaping ([Tipp]) -> ()) {
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/tipps?minscore=20") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
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

struct TippData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
