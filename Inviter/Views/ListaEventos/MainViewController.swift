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
    var refHandler : UInt!

    @IBOutlet weak var table: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if !verificaSeUsuarioJaLogado() {
            chamaTelaPrincipal(mySender: self)
        }
        
        ref = FIRDatabase.database().reference()
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

    func chamaTelaPrincipal(mySender:AnyObject)  {
        performSegue(withIdentifier: "segueLogin", sender: mySender)
    }
    
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueLogin" {
            _ = segue.destination as! LoginViewController
            
        }
        
    }
    func fetchRows(){
        if let userId = FIRAuth.auth()?.currentUser?.uid{
            refHandler = ref.child("Usuarios").child(userId).child("Eventos").observe(.childAdded, with:
                { (snapshot) in
                    
                    if let dic = snapshot.value as? [String:Any]
                    {
                        let item = Evento()
                        item.loadValues(data: dic)
                                                
                        self.evetos.append(item)
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                        
                    }
            })
        }
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
    
}
