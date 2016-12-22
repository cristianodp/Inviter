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

    @IBOutlet weak var table: UITableView!


    var participantes = [Participante]()
    var contatos = [Contato]()
    

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
                        if (item.resposta == self.Resposta!){
                            if let idParticipante = item.idParticipante{
                                self.addObserver(idParticipante:idParticipante)
                            }
                        }
                        
                      //  list.append(dic)
                        
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                        
                    }
            })
        }
    }
    
    func addObserver(idParticipante:String){
        refHandler = ref.child("Contatos").child(idParticipante).observe(.value, with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    let item = Contato(data: dic)
                    
                    
                    if let idx = self.participantes.index(where: { (valueFilter:Participante) -> Bool in
                        return (valueFilter.idParticipante?.isEqual(item?.idContato))! })
                    {
                        self.contatos.remove(at: idx)
                    }
                    
                    self.contatos.append(item!)
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "convidadosCell", for: indexPath)
        
        var item = participantes[indexPath.row]
        
        
        return cell
    }
    
    
   
}

