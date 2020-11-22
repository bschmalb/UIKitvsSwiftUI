//
//  UserData.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 28.06.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct User: Encodable, Decodable {
    var _id: String
    var phoneId: String
    var name: String?
    var gender: String?
    var age: String?
    var hideInfo: Bool?
    var level: Int16?
    var checkedTipps: [String]
    var savedTipps: [String]
    var savedFacts: [String]?
    var log: [Log]
    var __v: Int?
    var reports: Int?
}

struct Log: Encodable, Decodable {
    var _id: String?
    var kilometer: Int
    var meat: Int
    var cooked: Int
    var foodWaste: Int
    var drinks: Int
    var shower: Int
    var binWaste: Int
    var date: String
}

class UserApi {
    
    @State var id = UserDefaults.standard.string(forKey: "id")
    
    func fetchUser(completion: @escaping (User) -> ()) {
        
        guard let url = URL(string: "https://sustainablelife.herokuapp.com/users/" + (id ?? "")) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        completion(user)
                    }
                    
                    // everything is good, so we can exit
                    return
                }
            }
        }
        .resume()
    }
}

struct UserData_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
    }
}
