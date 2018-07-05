//
//  ViewController.swift
//  ContatoIP67
//
//  Created by ios6750 on 04/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    var delegate:FormularioContatoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if contato != nil{
            self.nome.text = contato.nome
            self.email.text = contato.email
            self.telefone.text = contato.telefone
            self.endereco.text = contato.endereco
            self.site.text = contato.site
            self.latitude.text = contato.latitude?.description
            self.longitude.text = contato.longitude?.description
            
            if let foto = contato.foto{
                self.imageView.image = self.contato.foto
            }
            
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
            
            self.navigationItem.rightBarButtonItem = botaoAlterar
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionaFoto(sender:)))
        
       // self.imageView.isUserInteractionEnabled = true
        
        
        self.imageView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var dao:contatoDao
    var contato: Contato!
    
    //utilizado para a instancia de ContatoDao utilizando padrão de projeto singleton
    required init?(coder aDecoder: NSCoder) {
        self.dao = contatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    //pega informações da textfield
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var site: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    @IBAction func buscarCoordenadas(sender: UIButton) {
    
        self.loading.startAnimating()
        sender.isHidden = true
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.endereco.text!) { (resultado, error) in
        
            if error == nil && (resultado?.count)! > 0 {
                let placemark = resultado![0]
                let coordenada = placemark.location!.coordinate
                
                self.latitude.text = coordenada.latitude.description
                self.longitude.text = coordenada.longitude.description
                
            }
            
        self.loading.stopAnimating()
        sender.isHidden = false
            
        }
        

    }
    
    @IBAction func criaContato(){
        self.pegaDadosDoFormulario()
        dao.adiciona(contato)
        
        self.delegate?.contatoAdicionado(contato)
        
        _=self.navigationController?.popViewController(animated: true)
    }
    
    func pegaDadosDoFormulario (){
        
        //verifica se já existe contato para o caso de edição
        if contato == nil {
            self.contato = dao.novoContato()
        }
        self.contato.nome = self.nome.text!
        self.contato.email = self.email.text!
        self.contato.telefone = self.telefone.text!
        self.contato.endereco = self.endereco.text!
        self.contato.site = self.site.text!
        self.contato.foto = self.imageView.image
        
        if let latitude = Double(self.latitude.text!){
            self.contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!){
            self.contato.longitude = longitude as NSNumber
        }
        
    
    }
    
    func atualizaContato(){
        pegaDadosDoFormulario()
        
        self.delegate?.contatoAtualizado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func selecionaFoto(sender: AnyObject){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker,animated: true,completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let imageSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imageSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

