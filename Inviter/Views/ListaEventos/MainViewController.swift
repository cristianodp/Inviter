//
//  MainViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 25/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

import HideKeyboard

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var evetos = [Evento]()
    var fb:FirebaseData!
    var colums:CGFloat = 1.0
    
    @IBOutlet weak var table: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        fb = FirebaseData()
                
        self.hideKeyboard()

        fetchRows()
        
        if !verificaSeUsuarioJaLogado() {
            chamaTelaLogin(mySender: self)
        }

    }
   
    func verificaSeUsuarioJaLogado() ->Bool
    {
        if fb.getUsuarioLogado() != nil {
            return true;
        }else{
            return false;
        }
    }
    
   

    func chamaTelaLogin(mySender:AnyObject)  {
        performSegue(withIdentifier: "segueLogin", sender: mySender)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueLogin" {
            _ = segue.destination as! LoginTableViewController
            
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
        if let userId = fb.getUsuarioLogado()?.uid{
            
            fb.observeEventos(idPessoa: userId, with:
                { (snapshot) in
                    
                    if let dic = snapshot.value as? [String:Any]
                    {
                        
                        let item = Evento(data: dic["Evento"] as! [String : Any])
                        
                        self.evetos.append(item!)
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }                        
                    }
            })
            
            fb.observeEventosChanged(idPessoa: userId, with:
                { (snapshot) in
                    
                    if let dic = snapshot.value as? [String:Any]
                    {
                        
                        let item = Evento(data: dic["Evento"] as! [String : Any])
                        //if !item?.isOldest()
                        if self.evetos.count > 0 {
                            if let idx = self.evetos.index(where: { (eventoFilter:Evento) -> Bool in
                                return (eventoFilter.idEvento?.isEqual(item?.idEvento))! })
                            {
                                self.evetos[ idx]  = item!
                            }
                        }
                        //self.evetos.append(item!)
                        
                        DispatchQueue.main.async {
                            self.evetos.sort(by: { $0.data! > $1.data! })
                            self.table.reloadData()
                        }
                    }
            })

        }
    }
    
    func addObserverEvento(eventoId:String){

        fb.observe(idEvento: eventoId, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    let item = Evento(data: dic)
                    
                    if let idx = self.evetos.index(where: { (eventoFilter:Evento) -> Bool in
                        return (eventoFilter.idEvento?.isEqual(item?.idEvento))! })
                    {
                        self.evetos.remove(at: idx)
                    }
                                        
                    self.evetos.append(item!)
                    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = collectionView.bounds.size.width-16.0
        let height:CGFloat = 171.0
        
        let dimension = width / colums
        
        return CGSize(width: dimension, height: height)
    }
    
    @IBAction func usuarioAction(_ sender: Any) {
        chamaTelaLogin(mySender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
      
        
        
    }
  /*
    func teste(){
    
        
            fb.add(idEvento: (self.evento?.idEvento)!, idPessoa: (fb.getUsuarioLogado()?.uid)!, resposta: "SIM")
        
            fb.add(idEvento: (self.evento?.idEvento)!, idPessoa: (fb.getUsuarioLogado()?.uid)!, resposta: "TALVEZ")
       
        fb.add(idEvento: (self.evento?.idEvento)!, idPessoa: (fb.getUsuarioLogado()?.uid)!, resposta: "NAO")
    }
      */
}
