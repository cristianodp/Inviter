//
//  ViewController.swift
//  Inviter
//
//  Created by Cristiano Diniz Pinto on 23/10/16.
//  Copyright © 2016 Cristiano Diniz Pinto. All rights reserved.
//

import UIKit
import Firebase
import DigitsKit


class LoginViewController: UIViewController {

    @IBOutlet weak var nomeUsuario: UITextField!
    @IBOutlet weak var emailUsuario: UITextField!
    
    var usuario:Pessoa = Pessoa()
    
    var ref : FIRDatabaseReference!
    var refHandler : UInt!
    
    var fb: FirebaseData!
    
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
        
        if let value = usuario.email{
            emailUsuario.text = value
        }else{
            emailUsuario.text = ""
        }
        
    }
    

    
    
    
    
    @IBAction func salvaAction(_ sender: Any) {
 
        do
        {
            try gravarUsuario()
            
            voltaTelaAnterior()
        }catch exceptionErros.GENERIC_ERRO {
            
           AlertSimpleDialog.show(sender:self, title:"Ops!",message: "Erro informe todos os campos corretamente.")
            
        }catch _ {
        
        }
        
        
    }
    
    func gravarUsuario() throws{
        
        if let value = nomeUsuario.text {
            usuario.nome = value
        }else{
            throw exceptionErros.GENERIC_ERRO(Message: "Usuario não informado")
        }
        
        if let value = emailUsuario.text {
            if !value.isEmail(){
                throw exceptionErros.GENERIC_ERRO(Message: "Email informado é inválido")
            }
            usuario.email = value
        }else{
            throw exceptionErros.GENERIC_ERRO(Message: "Email não informado")
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

    @IBAction func touchEntrer(_ sender: Any) {
        self.hideKeyboard()
    }
    
    @IBAction func endEditEmail(_ sender: Any) {
        self.hideKeyboard()
    }
    
}

