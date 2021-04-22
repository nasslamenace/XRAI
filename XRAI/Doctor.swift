//
//  Doctor.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit

class Doctor {
    var name: String
    var email: String
    var phone: String
    var profilePic: String
    var adress: String
    var uid: String
    
    
    init(name: String, email: String, phone: String, pic: String, uid: String, adress: String) {
        self.name = name;
        self.email = email;
        self.phone = phone
        self.profilePic = pic
        self.uid = uid
        self.adress = adress
    }
}
