//
//  UserModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation
struct User: Codable {
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var weight: Int
    var height: Int
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
}
