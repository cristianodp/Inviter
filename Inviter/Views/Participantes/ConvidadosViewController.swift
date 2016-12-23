//
//  ConvidadosViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 10/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import SwiftyJSON

class ConvidadosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    var idEvento:String?
    var Resposta:String?
    var participantes = [Participante]()

    @IBOutlet weak var table: UITableView!


    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        fetchRows()
        //convidadosCell
    }
    
  
    func fetchRows(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let idEvento = idEvento{
            refHandler = ref.child("Eventos").child(idEvento).child("Participantes").observe(.childAdded, with:
                { (snapshot) in
                    
                    if let dic = snapshot.value as? [String:Any]
                    {
                       
                        let item = Participante()
                        item.loadValues(data: dic)
                       
                        
                        if (item.resposta?.isEqual(self.Resposta!))! {
                            if item.idParticipante != nil{
                                
                                self.carregaContato(participante: item)
                            }
                        }
                    }
            })
        }
    }
    
    func carregaContato(participante:Participante){
       
        self.refHandler = self.ref.child("Usuarios").child(participante.idContato!).child("Usuario").observe(.value, with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    let item = Contato(dataDic: dic)
                    participante.contato = item
                    self.participantes.append(participante)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convidadosCell", for: indexPath) as! ConvidadosTableViewCell
        
        let item = self.participantes[indexPath.row]
        
        cell.configureWithContactEntry(item)
      
        
        return cell
    }
    
    
   
}

