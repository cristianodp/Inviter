//
//  LoginTableViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 25/12/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import DigitsKit
import Firebase

class LoginTableViewController: UITableViewController {
    var usuario:Pessoa = Pessoa()
    
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    var fb: FirebaseData!
    
    @IBOutlet weak var nomeUsuario: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.hideKeyboard()
        
        fb = FirebaseData()
        
        ref = FIRDatabase.database().reference()
        // autenticacaoUsuario()
        if FIRAuth.auth()?.currentUser?.uid != nil{
            carregaDadosLoginUsuario()
            
        }else{
            
            loginDigits()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loginDigits() {
        
        let digits = Digits.sharedInstance()
        digits.authenticate { (session, error) in
            
            if (session != nil) {
                
                let email:String = session!.phoneNumber+"@inviter.com.br"
                let chave:String = session!.phoneNumber
                
                self.loginUserFirebase(email: email, passwd: chave)
                
            } else {
                AlertSimpleDialog.show(sender: self, title: "Opps!", message: (error?.localizedDescription)! )
            }
            
        }
        
    }
    
    
    func loginUserFirebase(email:String,passwd:String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: passwd , completion: { (user, error) in
            
            if error == nil {
                self.AtualizaUsuario()
                self.carregaDadosLoginUsuario()
                self.completarCadastro()
            }else{
                
                self.createUserFirebase(email: email, passwd: passwd)
                
            }
        })
    }
    
    
    func carregaDadosLoginUsuario()
    {
        if let user = fb.getUsuarioLogado() {
            
            fb.observePessoa(idPessoa: user.uid, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:Any]{
                    
                    self.usuario = Pessoa.init(dataDic: dic)!
                    
                }else{
                    self.usuario.id = user.uid
                    self.usuario.nome = user.displayName
                    self.usuario.fone = user.email?.replacingOccurrences(of: "@inviter.com.br", with: "")
                    
                }
                
                self.carregaCamposUsuario()
                
            })
            
        }
        
    }
    
    func createUserFirebase(email:String,passwd:String) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: passwd, completion: {(user, error) in
            
            if error == nil {
                self.AtualizaUsuario()
                self.carregaDadosLoginUsuario()
                self.completarCadastro()
                //self.voltaTelaAnterior()
                
            }else{
                
                AlertSimpleDialog.show(sender: self,title: "Opps!", message: (error?.localizedDescription)! )
                
            }
            
        })
        
    }
    
    
    func AtualizaUsuario(){
        if let user = fb.getUsuarioLogado(){
            
            self.usuario.id = user.uid
            // self.usuario.nome = user.displayName
            self.usuario.fone = user.email?.replacingOccurrences(of: "@inviter.com.br", with: "")
            //self.usuario.image =
            fb.add(pessoa: self.usuario)
            
        }
    }
    
    func completarCadastro(){
        
        carregaCamposUsuario()
    }
    
    func carregaCamposUsuario() {
        if let value = usuario.nome{
            nomeUsuario.text = value
        }else{
            nomeUsuario.text = ""
        }
        
    }
        
    @IBAction func salvarUsuarioAction(_ sender: Any) {
   
        do
        {
            try gravarUsuario()
            
            voltaTelaAnterior()
        }catch exceptionErros.GENERIC_ERRO {
            
            AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro informe todos os campos corretamente.")
            
        }catch _ {
            
        }
        
        
    }
    
    @IBAction func voltarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Digits.sharedInstance().logOut()
        fb.logOutFirebase()
        loginDigits()
        
    }
    func gravarUsuario() throws{
        
        if let value = nomeUsuario.text {
            usuario.nome = value
        }else{
            throw exceptionErros.GENERIC_ERRO(Message: "Usuario não informado")
        }
        
        if usuario.id == nil{
            throw exceptionErros.GENERIC_ERRO(Message: "Login por celular não realizado")
        }
        
        gravaUsuarioNoFirebase(usr:usuario)
    }
    
    func gravaUsuarioNoFirebase(usr:Pessoa){
        
        let fb = FirebaseData()
        
        fb.add(pessoa: usr)
        
    }
    
    func voltaTelaAnterior(){
        AlertSimpleDialog.show(sender: self,title: "Sucess!", message: "Cadastro realizado com sucesso.", handler:{(action) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
