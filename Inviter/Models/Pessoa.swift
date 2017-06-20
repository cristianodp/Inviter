//
//  Person.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation
import SwiftyJSON
import AddressBook
import Contacts

class Pessoa: NSObject {
    
    var id:String?
    var nome:String?
    var avatarUrl:String?
    var email:String?
    var fone:String?
    var image:UIImage?
    
    public override init() {
        
    }
    
    public init?(dataDic:[String:Any]){
        
        
        if let value = dataDic["id"] {
            self.id = value as? String
        }
        
        
        if let value = dataDic["nome"] {
            self.nome = value as? String
        }
        
        if let value = dataDic["avatarUrl"] {
            self.avatarUrl = value as? String
        }
        
        if let value = dataDic["email"] {
            self.email = value as? String
        }
        
        
        if let value = dataDic["fone"] {
            self.fone = value as? String
        }
    }
    
    public init?(dataJson:JSON){
        
        if let value = dataJson["id"].string {
            self.id = value
        }
        
        
        if let value = dataJson["nome"].string {
            self.nome = value
        }
        
        if let value = dataJson["avatarUrl"].string {
            self.avatarUrl = value
        }
        
        if let value = dataJson["email"].string {
            self.email = value
        }
        
        
        if let value = dataJson["fone"].string {
            self.fone = value
        }
    }
    
    public func toDictionary()->  [String : Any]{
        
        var dic = [String : Any]()
        
        if let value = self.id{
            dic["id"] = value
        }
        
        if let value = self.nome{
            dic["nome"] = value
        }
        
        if let value = self.avatarUrl{
            dic["avatarUrl"] = value
        }
        
        if let value = self.email{
            dic["email"] = value
        }
        
        if let value = self.fone{
            dic["fone"] = value
        }
        
        
        return dic as  [String : Any]
    }

    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        super.init()
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.nome = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
        // image
        self.image = (cnContact.isKeyAvailable(CNContactImageDataKey) && cnContact.imageDataAvailable) ? UIImage(data: cnContact.imageData!) : nil
        // email
        if cnContact.isKeyAvailable(CNContactEmailAddressesKey) {
            for possibleEmail in cnContact.emailAddresses {
                let properEmail = possibleEmail.value as String
                if properEmail.isEmail() { self.email = properEmail; break }
            }
        }
        // phone
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                self.fone = phone?.stringValue
            }
        }
    }
    

}
