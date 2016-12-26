//
//  ConvidadosViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 10/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit

import Contacts
import SwiftyJSON
import DigitsKit


class ConvidadosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ControllerDelegate{
   
    var evento:Evento?
    var Resposta:String?
    var convidados = [Convidado]()
    var fb:FirebaseData!
    
    @IBOutlet weak var table: UITableView!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        fb = FirebaseData()
        fetchRows()

    }
    
    func fetchRows(){
       
        if fb.getUsuarioLogado()?.uid == nil{
            dismiss(animated: true, completion: nil)
            return
        }
        
        
        if let idEvento = evento?.idEvento{
            fb.observeConvidados(idEvento: idEvento, with:
                { (snapshot) in
                    
                    if let dic = snapshot.value as? [String:Any]
                    {
                       
                        let item = Convidado(data: dic)
                        
                        if (item?.resposta?.isEqual(self.Resposta!))! {
                            
                            self.CarregaPessoa(convidado: item!)
                        }
                    }
            })
        }
    }
    
    func CarregaPessoa(convidado:Convidado){
    
        fb.observePessoa(idPessoa: convidado.idPessoa!) { (snapshot) in
            if let dic = snapshot.value as? [String:Any]
            {
                let item = Pessoa.init(dataDic: dic)
                convidado.pessoa = item
                self.convidados.append(convidado)
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convidados.count
    }
        
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convidadosCell", for: indexPath) as! ConvidadosTableViewCell
        
        let item = self.convidados[indexPath.row]
        
        cell.configureWithContactEntry(item)
      
        
        return cell
    }
    
    
    func contatoDidReturn(contato:Pessoa){
        let fone = FoneUtils.retornaNumeroCompleto(fone: contato.fone!)
        fb.observeIndex (fone: (fone), with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    
                    let idPessoa = dic["idPessoa"] as? String
                    
                    let convidado = Convidado.init(idEvento: (self.evento?.idEvento)!, idPessoa: idPessoa!, resposta: "CONVIDADO")
                    
                    self.fb.add(convidado: convidado!, evento: self.evento!)
                
                }else{
                
                    self.fb.addConvidadoSemUsuario(evento:self.evento!,contato:contato)
                    
                }
              
            })
    
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueContatos" {
            
            let vc = segue.destination as! ContatosViewController
            
            vc.delegate = self
            
        }
        
        
    }

    
}

