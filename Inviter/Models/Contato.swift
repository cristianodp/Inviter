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

class Contato: Person {
    
    var image: UIImage?
    var selected:Bool = false
    
    override init() {
        super.init()
        
    }
   
    init?(name: String, email: String?, phone: String?, image: UIImage?) {
        super.init()
        super.name = name
        super.email = email
        super.phone = phone
        self.image = image
      
    }
    
    override init?(dataDic:[String:Any]) {
        super.init(dataDic: dataDic)
    }
    
    override init?(dataJson:JSON) {
        super.init(dataJson: dataJson)
    }
   /*
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
    */
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        super.init()
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
    
    
}
