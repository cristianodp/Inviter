//
//  EventoTableViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 07/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase

class EventoTableViewController: UITableViewController {

    
    var keyEvento:String?
    var evento:Evento?
    var participante:Participante?
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    var hideDadaPicker:Bool = true

    

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
        
        ref = FIRDatabase.database().reference()
        dataPikerCell.isHidden = true

        iniciaObservador()
        
        
    }

    func iniciaObservador(){
        
        if (FIRAuth.auth()?.currentUser?.uid) != nil{
            if let keyEvento = keyEvento{
                refHandler = ref.child("Eventos").child(keyEvento).observe(.value , with:
                    { (snapshot) in
                        
                        if let dic = snapshot.value as? [String:Any]
                        {
                            let item = Evento()
                            item.loadValues(data: dic)
                            
                            self.evento = item
                            
                            self.carregaTela()
                            
                            
                        }
                })
    
            
            }else{
                self.evento = Evento()

            }
            
        }
    }
    func carregaTela(){
        
        
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
        carregaTela()
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
        
        if let value = descricaoField.text{
            evento?.nome = value
        }else{
            AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Informe a descriçao")
            return
            
        }
        
        if let value = localField.text{
            evento?.local = value
            
            do {
                
                try salvarEvento()
            }catch exceptionErros.INVALID_EVENTO_ID {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao gera id do evento")
            }catch exceptionErros.INVALID_ORGANIZADOR_ID {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao buscar id do organizador")
            }
            catch _ {
                AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro ao valvar evento")
            }
            
        }else{
            AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Informe o local")
            
        }

        
    }
    
    func salvarEvento() throws{
        
        
        try CompletaDadosEvento()
        
        AddParticipante()
        
        evento?.addConvidado(idConvidado: (participante?.idParticipante)!)
        
        salvandoEventoNoFiferabse()
        
    }
    
    func AddParticipante(){
        let Usrkey = FIRAuth.auth()?.currentUser?.uid
        self.participante = Participante()
        self.participante?.idEvento = evento?.idEvento
        self.participante?.idContato = Usrkey
        self.participante?.idParticipante = Usrkey//ref.childByAutoId().key
        self.participante?.resposta = "COVIDADO"
    }
    
    
    func salvandoEventoNoFiferabse(){
        
        
        let eventoId = evento?.idEvento
        self.ref.child("Eventos").child(eventoId!).setValue(evento?.toDictionary())
        
        let Usrkey = FIRAuth.auth()?.currentUser?.uid
        self.ref.child("Usuarios").child(Usrkey!).child("EventosUsuario").child(eventoId!).setValue(eventoId!)

        let participanteKey = participante?.idParticipante
        self.ref.child("Eventos").child(eventoId!).child("Participantes").child(participanteKey!).setValue(participante?.toDictionary())
        
    
    //self.ref.child("Participantes").child(userId).child("Eventos").child(keyEvento).

    }
    func CompletaDadosEvento() throws{
        
        try geraIdEvento()
        
        try carregaIdOrganizador()
        
    }
    func geraIdEvento() throws{
        
        if (evento?.idEvento) == nil{
            if let key:String = ref.childByAutoId().key {
                evento?.idEvento = key
            }else{
                print("Erro ao gera id do evento")
                throw exceptionErros.INVALID_EVENTO_ID            }
            
            
        }
    }
    
    func carregaIdOrganizador() throws {
        
        if (evento?.organizadorId) == nil {
            if let key:String = FIRAuth.auth()?.currentUser?.uid {
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
    
    
  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
