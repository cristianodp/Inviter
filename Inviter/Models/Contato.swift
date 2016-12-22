//
//  Contato.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 04/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import Foundation

import UIKit
import AddressBook
import Contacts
import SwiftyJSON

class Contato: NSObject {
    var idUsuario:String?
    var idContato:String?
    var name: String!
    var email: String?
    var phone: String?
    var image: UIImage?
    var imageUrl: String?
  
    
    
    init(name: String, email: String?, phone: String?, image: UIImage?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.image = image
      
    }
    
    init?(addressBookEntry: ABRecord) {
        super.init()
        
        // get AddressBook references (old-style)
        guard let nameRef = ABRecordCopyCompositeName(addressBookEntry)?.takeRetainedValue() else { return nil }
        
        // name
        self.name = nameRef as String
        
        // emails
        if let emailsMultivalueRef = ABRecordCopyValue(addressBookEntry, kABPersonEmailProperty)?.takeRetainedValue(), let emailsRef = ABMultiValueCopyArrayOfAllValues(emailsMultivalueRef)?.takeRetainedValue() {
            let emailsArray = emailsRef as NSArray
            for possibleEmail in emailsArray { if let properEmail = possibleEmail as? String , properEmail.isEmail() { self.email = properEmail; break } }
        }
        
        
        // image
        var image: UIImage?
        if ABPersonHasImageData(addressBookEntry) {
            image = UIImage(data: ABPersonCopyImageData(addressBookEntry).takeRetainedValue() as Data)
        }
        self.image = image ?? UIImage(named: "defaultUser")
        
        // phone
        if let phonesMultivalueRef = ABRecordCopyValue(addressBookEntry, kABPersonPhoneProperty)?.takeRetainedValue(), let phonesRef = ABMultiValueCopyArrayOfAllValues(phonesMultivalueRef)?.takeRetainedValue() {
            let phonesArray = phonesRef as NSArray
            if phonesArray.count > 0 { self.phone = phonesArray[0] as? String }
        }
        
    }
    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.name = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
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
                self.phone = phone?.stringValue
            }
        }
    }
    
    
    init?(data:[String:Any]){
        
        
        if let value = data["idUsuario"] {
            self.idUsuario = value as? String
        }
        
        
        if let value = data["idContato"] {
            self.idContato = value as? String
        }
        
        if let value = data["name"] {
            self.name = value as? String
        }
        
        if let value = data["email"] {
            self.email = value as? String
        }
        
        
        if let value = data["phone"] {
            self.phone = value as? String
        }
        
        if let value = data["image"] {
            self.imageUrl = value as? String
            self.image = self.image?.loadImage(fromUrl: (value as? String)!)
        }
        
        
        
    }
    
    init?(data:JSON){
        
        if let value = data["idUsuario"].string {
            self.idUsuario = value
        }
        
        
        if let value = data["idContato"].string {
            self.idContato = value
        }
        
        if let value = data["name"].string {
            self.name = value
        }
        
        if let value = data["email"].string {
            self.email = value
        }
        
        
        if let value = data["phone"].string {
            self.phone = value
        }
        
        if let value = data["image"].string {
            self.imageUrl = value
            self.image = self.image?.loadImage(fromUrl: value)
        }
        
    }
    
    func toDictionary()->  [String : Any]{
        
        
        let dic = [ "idUsuario": idUsuario!
            ,"idContato": idContato!
            ,"name": name
            ,"email": email!
            ,"email": imageUrl!
            ] as [String : Any]
        
        
        return dic as  [String : Any]
    }
}
