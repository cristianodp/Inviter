//
//  MainViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 25/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var evetos = [Evento]()
    var ref : FIRDatabaseReference!
    var ref2 : FIRDatabaseReference!
    var refHandler : UInt!


    @IBOutlet weak var table: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if !verificaSeUsuarioJaLogado() {
            chamaTelaLogin(mySender: self)
        }
        self.hideKeyboard()
        ref = FIRDatabase.database().reference()
        ref2 = FIRDatabase.database().reference()
        fetchRows()

    }
   
    func verificaSeUsuarioJaLogado() ->Bool
    {
        if retornUsuarioLogado() != nil {
            return true;
        }else{
            return false;
        }
    }
    
    func retornUsuarioLogado() -> AnyObject?
    {
        if let user = FIRAuth.auth()?.currentUser{
            return user
        }else{
            return nil
        }
    }

    func chamaTelaLogin(mySender:AnyObject)  {
        performSegue(withIdentifier: "segueLogin", sender: mySender)
    }
    
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueLogin" {
            _ = segue.destination as! LoginViewController
            
        }
        if segue.identifier == "segueEventoEdite" {
           
            let eventoController = segue.destination as! EventoTableViewController
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.table.indexPath(for: cell) {
                let item = evetos[indexPath.row]
                eventoController.keyEvento = item.idEvento
            }
            
        }
        
        
    }
    func fetchRows(){
        if let userId = FIRAuth.auth()?.currentUser?.uid{
            refHandler = ref.child("Usuarios").child(userId).child("EventosUsuario").observe(.childAdded, with:
                { (snapshot) in
                    
                    if let eventoId = snapshot.value as? String
                    {
                        
                        self.addObserverEvento(eventoId: eventoId)
                        
                        
                    }
            })
        }
    }
    
    func addObserverEvento(eventoId:String){
        refHandler = ref2.child("Eventos").child(eventoId).observe(.value, with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    let item = Evento()
                    item.loadValues(data: dic)
                    
                    if let idx = self.evetos.index(where: { (eventoFilter:Evento) -> Bool in
                        return (eventoFilter.idEvento?.isEqual(item.idEvento))! })
                    {
                        self.evetos.remove(at: idx)
                    }
                                        
                    self.evetos.append(item)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    
                }
        })

    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return evetos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventoCell", for: indexPath) as! EventoCollectionViewCell
        
        let item:Evento = evetos[indexPath.row]
        cell.loadRow(evento: item)
        
        return cell
        
    }

    @IBAction func usuarioAction(_ sender: Any) {
        chamaTelaLogin(mySender: self)
    }
    
}
