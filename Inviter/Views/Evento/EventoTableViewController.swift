//
//  EventoTableViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 07/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit


class EventoTableViewController: UITableViewController,ControllerDelegate {

    var keyEvento:String?
    var evento:Evento?
    
    var convidados:[Convidado]?
    
    var hideDadaPicker:Bool = true
    
    var fb:FirebaseData!

    @IBOutlet weak var descricaoField: UITextField!
    @IBOutlet weak var dataField: UITextField!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var localField: UITextField!
    @IBOutlet weak var dataPikerCell: UITableViewCell!

    @IBOutlet weak var simField: UILabel!
    @IBOutlet weak var talvesField: UILabel!
    @IBOutlet weak var naoField: UILabel!
    @IBOutlet weak var convidadosField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataPikerCell.isHidden = true

        fb = FirebaseData()
        
        iniciaObservador()
        
        
    }

    func iniciaObservador(){
        
        
        if (fb.getUsuarioLogado()?.uid) != nil{
            if let keyEvento = keyEvento{
            
                fb.observe(idEvento: keyEvento, with:
                    { (snapshot) in
                        
                        if let dic = snapshot.value as? [String:Any]
                        {
                            let item = Evento(data: dic)
                            
                            self.evento = item
                            
                            self.carregaDadosEvento()
                            
                            
                        }
                })
                
                
                fb.observeConvidados(idEvento: keyEvento, with:
                    { (snapshot) in
                        
                        if let dic = snapshot.value as? [String:Any]
                        {
                            if let item = Convidado(data: dic){
                                
                                if let idx = self.convidados?.index(where: { (convidado:Convidado) -> Bool in
                                    
                                    if (convidado.idPessoa?.isEqual(item.idPessoa))!{
                                        return true
                                    }else{
                                        return false
                                    }
                                    
                                }){
                                    self.convidados?.remove(at: idx)
                                }
                                
                                if self.convidados == nil{
                                    self.convidados = [Convidado]()
                                }
                                self.convidados?.append(item)
                                
                                self.carregaConvidadosEvento()
                            
                            }
                            
                        }
                })

            
            }else{
                self.evento = Evento()
                
                self.evento?.idEvento = fb.getNewId()
                
                self.convidados = [Convidado]()
                convidados?.append(Convidado.init(idEvento: (self.evento?.idEvento)!, idPessoa: (fb.getUsuarioLogado()?.uid)!, resposta: "CONVIDADO")!)
                
                self.carregaConvidadosEvento()
            }
            
            
            
            
        }
    }
    
    func carregaDadosEvento(){
        
        
        if let evento = evento{
           
            if let nome = evento.nome{
                descricaoField.text = nome
            }
            if let data = evento.getDataString(){
                dataField.text = data
            }
            
            if let local = evento.local {
                localField.text = local
            }
        
        }else{
            self.evento = Evento()
            self.evento?.idEvento = fb.getNewId()
            
            self.convidados?.append(Convidado.init(idEvento: (self.evento?.idEvento)! , idPessoa: (fb.getUsuarioLogado()?.uid)!, resposta: "CONVIDADO")!)
        }
    
    }
    
    
    
    func carregaConvidadosEvento(){
        
        let sim:[Convidado]? = self.convidados?.filter({ (convidado:Convidado) -> Bool in
            if (convidado.resposta?.isEqual("SIM"))!{
                return true
            }else{
                return false
            }
        })
        
        let nao:[Convidado]? = self.convidados?.filter({ (convidado:Convidado) -> Bool in
            if (convidado.resposta?.isEqual("NAO"))!{
                return true
            }else{
                return false
            }
        })
        
        
        let talvez:[Convidado]? = self.convidados?.filter({ (convidado:Convidado) -> Bool in
            if (convidado.resposta?.isEqual("TALVEZ"))!{
                return true
            }else{
                return false
            }
        })
        
        let convidado:[Convidado]? = self.convidados?.filter({ (convidado:Convidado) -> Bool in
            if (convidado.resposta?.isEqual("CONVIDADO"))!{
                return true
            }else{
                return false
            }
        })
        
        if let count = sim?.count {
            simField.text = String(count)
        }else{
            simField.text = "0"
        }
        if let count = talvez?.count {
            talvesField.text = String(count)
        }else{
            talvesField.text = "0"
        }
        if let count = nao?.count {
            naoField.text = String(count)
        }else{
            naoField.text = "0"
        }
        if let count = convidado?.count {
            convidadosField.text = String(count)
        }else{
            convidadosField.text = "0"
        }
    }
    @IBAction func horarioDidEndAction(_ sender: Any) {
        horarioDataPicker(show: false)
    }
    @IBAction func horarioDidBeginAction(_ sender: Any) {
        horarioDataPicker(show: true)
    }
 
    @IBAction func dataPickerCancelar(_ sender: Any) {
        horarioDataPicker(show: false)
    }
    
    @IBAction func dataPickerEscolher(_ sender: Any) {
        
        evento?.data = dataPicker.date
        carregaDadosEvento()
        horarioDataPicker(show: false)
        
    }
    func horarioDataPicker(show:Bool){
    
        hideDadaPicker = !show
        dataPikerCell.isHidden = !show
        if let dataEvento = evento?.data
        {
            dataPicker.date = dataEvento
        }
        tableView.reloadData()
        
    }
   

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            if hideDadaPicker {
                return 1
            } else{
                return 2
            }
        }
        
        if section == 3 {
            return 5
        }
        return 1
    }

    @IBAction func salvarAction(_ sender: Any) {
        
        if salvarEvento() {
             AlertSimpleDialog.show(sender:self, title:"Inviter",message: "Atualizado com sucesso!")
        }
        
    }
    
    func salvarEvento() -> Bool {
        if let value = descricaoField.text{
            evento?.nome = value
        }else{
            AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Informe a descriçao")
            return false
        }
        
        if let value = localField.text{
            evento?.local = value
            
            do {
                
                try CompletaDadosEvento()
                
                fb.add(evento: evento!, convidados: convidados!)
                
                self.dismiss(animated: true, completion: nil)
                
           
                return true
                
            }catch exceptionErros.INVALID_EVENTO_ID {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao gera id do evento")
                return false
            }catch exceptionErros.INVALID_ORGANIZADOR_ID {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao buscar id do organizador")
                return false
            }
            catch _ {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao valvar evento")
                return false
            }
            
        }else{
            AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Informe o local")
            return false
            
        }
        
        
        
        
        
        
    }
    
    
    func CompletaDadosEvento() throws{
        
        try geraIdEvento()
        
        try carregaIdOrganizador()
        
        
        
    }
    func geraIdEvento() throws{
        
        if (evento?.idEvento) == nil{
            let key = fb.getNewId()
            evento?.idEvento = key
        }
    }
    
    func carregaIdOrganizador() throws {
        
        if (evento?.organizadorId) == nil {
            if let key:String = fb.getUsuarioLogado()?.uid {
                evento?.organizadorId = key
            }else{
                print("Erro ao buscar id do organizador")
                throw exceptionErros.INVALID_ORGANIZADOR_ID
            }
            
            
        }
    }
    
    


    @IBAction func adicParticipantesAction(_ sender: Any) {
        
        //chamaTelaContato(mySender: self)
        
    }
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if salvarEvento() {
            
        }
        
        if segue.identifier == "segueParticipantesSim" {
            let vc = segue.destination as! ConvidadosViewController
            vc.Resposta = "SIM"
            vc.evento = evento
            
        }
        if segue.identifier == "segueParticipantesNao" {
            
            let vc = segue.destination as! ConvidadosViewController
            vc.Resposta = "NAO"
            vc.evento = evento
            
        }
        if segue.identifier == "segueParticipantesTalvez" {
            
            let vc = segue.destination as! ConvidadosViewController
            vc.Resposta = "TALVEZ"
            vc.evento = evento
            
        }
        if segue.identifier == "segueParticipantesConvidado" {
            
            let vc = segue.destination as! ConvidadosViewController
            vc.Resposta = "CONVIDADO"
            vc.evento = evento            
        }
        if segue.identifier == "segueContatos" {
            
            let vc = segue.destination as! ContatosViewController
            
            vc.delegate = self
            
        }

        
    }
 
    func contatoDidReturn(contato:Pessoa){
        
        fb.observeIndex (fone: (contato.fone!), with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    
                    let idPessoa = dic["idPessoa"] as? String
                    
                    self.addConvidado(idPessoa:idPessoa!)
                    
                }else{
                    
                    self.fb.addConvidadoSemUsuario(evento:self.evento!,contato:contato)
                    
                }
                
        })
        
        
    }
    
    func addConvidado(idPessoa:String)
    {
        
        fb.observePessoa(idPessoa: idPessoa, with:
            { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]
                {
                    
                    let item = Pessoa.init(dataDic: dic)
                    
                    let convidado = Convidado.init(idEvento: (self.evento?.idEvento!)!, idPessoa: (item?.id!)!, resposta: "CONVIDADO")
                    
                    self.fb.add(convidado: convidado!, evento: self.evento!)
                    
                    
                }
                
        })
        
    }
    
    
   

}
