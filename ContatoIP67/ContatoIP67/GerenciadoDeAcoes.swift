//
//  GerenciadoDeAcoes.swift
//  ContatoIP67
//
//  Created by ios6750 on 07/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class GerenciadoDeAcoes: NSObject {
    
    let contato:Contato
    var controller:UIViewController!
    
    init(do contato: Contato){
        self.contato = contato
    }
    
    func exibirAcoes(em controller: UIViewController){
        
        self.controller = controller
        
        let alertView = UIAlertController(title: self.contato.nome, message: nil, preferredStyle: .actionSheet)
        
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default){ action in
            self.ligar()
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        let exibirContatoNoMapa = UIAlertAction(title: "Visualizar no Mapa", style: .default){ action in
            self.abrirMapa()
        }
        
        let exibirSiteDoContato = UIAlertAction(title: "Visualizar Site", style: .default){ action in
            self.abrirNavegador()
        }
        
        let exibirTemperatura = UIAlertAction(title: "Visualizar Clima", style:.default){ action in
            self.exibirTemperatura()
        }
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatoNoMapa)
        alertView.addAction(exibirSiteDoContato)
        alertView.addAction(exibirTemperatura)
        
        self.controller.present(alertView,animated: true, completion: nil)
    
    }
    
    private func abrirAplicativo(com url:String){
        UIApplication
            .shared
            .open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    private func ligar(){
        let device = UIDevice.current
        
        if device.model == "iPhone"{
            abrirAplicativo(com: "tel:" + self.contato.telefone!)
        }else{
            let alert = UIAlertController(title: "Impossivel fazer Ligações",message: "Seu dispositivo não é um iPhone",preferredStyle: . alert)
            
            self.controller.present(alert,animated: true,completion: nil)
        }
    }
    
    private func abrirNavegador(){
        var url = self.contato.site!
        if !url.hasPrefix("http://"){
                url = "http://" + url
        }
        
        abrirAplicativo(com: url)
        
    }
    
    private func abrirMapa(){
        let url = ("http://maps.apple.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        abrirAplicativo(com: url)
        
    }
    
    private func exibirTemperatura(){
        let temperaturaViewController = controller.storyboard?.instantiateViewController(withIdentifier: "Form-Temperatura") as! TemperaturaViewController
        
        temperaturaViewController.contato = self.contato
        
        controller.navigationController?.pushViewController(temperaturaViewController, animated: true)
    }
    
}
