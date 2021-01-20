//
//  UserData.swift
//  UIKitTest
//
//  Created by Bastian Schmalbach on 16.01.21.
//

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
