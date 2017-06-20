//
//  ContatosViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 20/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Contacts


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@available(iOS 9.0, *)
class ContatosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!
    @IBOutlet weak var searchControll: UISearchBar!
    
    var delegate:ControllerDelegate!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [Pessoa]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.register(UINib(nibName: "ContatoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        noContactsLabel.isHidden = false
        noContactsLabel.text = "Retrieving contacts..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getContacts(term: nil)
    }
    
    func getContacts(term:String?){
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    self.tableView.isHidden = !success
                    self.noContactsLabel.isHidden = success
                    if success && contacts?.count > 0 {
                        if let term = term{
                            
                            if let filter = contacts?.filter({ (cnt:Pessoa) -> Bool in
                                
                                    if (cnt.nome?.contains(term))! {
                                        return true
                                    }else{
                                        return false
                                    }
                                }){
                                self.contacts = filter
                            }else
                            {
                                self.contacts.removeAll()
                                self.noContactsLabel.text = "Unable to get contacts..."

                            }
                            
                            
                        }else{
                            self.contacts = contacts!
                        }
                        
                        self.tableView.reloadData()
                    } else {
                        self.noContactsLabel.text = "Unable to get contacts..."
                    }
                })
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchControll.showsCancelButton = true
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchControll.endEditing(true)
        getContacts(term: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let value = self.searchControll.text{
            getContacts(term:value)
        }else{
            getContacts(term: nil)
        }
        
        self.searchControll.endEditing(true)
    }
    
   
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [Pessoa]?) -> Void) {
        var contacts = [Pessoa]()
        do {
            
            let contactsFetchRequest = CNContactFetchRequest ( keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor] )
            
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = Pessoa(cnContact: cnContact) { contacts.append(contact) }
            })
            
            completion(true, contacts)
        } catch {
            
            completion(false, nil)
        
        }
    }
    

    
    
    // UITableViewDataSource && Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContatoTableViewCell", for: indexPath) as! ContatoTableViewCell
        let entry = contacts[(indexPath as NSIndexPath).row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = contacts[indexPath.row]
        
        AlertSimpleDialog.showChoce(sender: self, title: "Adicionar", message: "Deseja adicionar o contato selecionado ao evento?") { (UIAlertAction) in
            if !FoneUtils.isValid(fone: item.fone!){
                AlertSimpleDialog.show(sender: self, title: "Ops!", message: "O formato do numéro não atende os requisitos. Exemplo +55(51)00000-0000")
                return
            }
            
            self.delegate.contatoDidReturn(contato: item)
            
            self.dismiss(animated: true, completion: nil)

        }
        
        
        
    }
    
    
    
}
