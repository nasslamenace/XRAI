//
//  User.swift
//  XRAI
//
//  Created by Nassim Guettat on 23/12/2020.
//

import Foundation
import UIKit


class User {
    var name: String
    var email: String
    var phone: String
    var profilePic: String
    var uid: String
    
    
    init(name: String, email: String, phone: String, pic: String, uid: String) {
        self.name = name;
        self.email = email;
        self.phone = phone
        self.profilePic = pic
        self.uid = uid
    }
}
