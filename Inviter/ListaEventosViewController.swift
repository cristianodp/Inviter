//
//  ListaEventosViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 29/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
class ListaEventosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    var list = [Evento]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        if !verificaSeUsuarioJaLogado() {
            chamaTelaPrincipal(mySender: self)
        }

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
    
    
    func fetchRows(){
        if let userId = FIRAuth.auth()?.currentUser?.uid{
            refHandler = ref.child("Usuarios").child(userId).child("Eventos").observe(.childAdded, with:
                { (snapshot) in
                
                    if let dic = snapshot.value as? [String:Any]
                    {
                    
                        let item = Evento()
                    
                        item.idEvento = dic["idEvento"] as! String?
                        item.nome = dic["nome"] as! String?
                        item.local = dic["local"] as! String?
                        item.setDataString(dataString: dic["data"] as! String)
                    
                        //item.setValuesForKeys(dic)
                        self.list.append(item)
                    
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    
                    
                    }
            })
        }
        /*
         refHandler = ref.child("eventos").child(userId!).observe(.childAdded, with:
         { (snapshot) in
         
         if let dictionary = snapshot.value as? [String:AnyObject]
         {
         
         let item = Aparelho()
         
         item.setValuesForKeysWithDictionary(dictionary)
         
         var aux = [Aparelho]()
         aux = self.list
         
         self.list = [Aparelho]()
         for it in aux {
         
         if( it.idAparelho == item.idAparelho ){
         
         self.list.append(item)
         
         }else{
         self.list.append(it)
         }
         }
         
         dispatch_async(dispatch_get_main_queue(), {
         self.tableView.reloadData()
         })
         }
         })
         
         */
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventoCell", for: indexPath) as! EventosTableViewCell
        
        
        let item = self.list[indexPath.row]
        
        cell.loadCell(evento: item)
        
        
        /*
         //let url = URL(string:thumbnail!)
         
         URLSession.shared.dataTask(with: url!) {(dados, _, _)in
         DispatchQueue.main.async {
         cell.imageView?.image = UIImage(data: dados!)
         cell.layoutSubviews()
         
         }
         }.resume()
         */
        /*cell.textLabel?.text = nome
         */
        
        
        return cell
        
        
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueLogin" {
            _ = segue.destination as! LoginViewController
            
        }
        
    }


}
