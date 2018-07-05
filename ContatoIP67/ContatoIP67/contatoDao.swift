//
//  contatoDao.swift
//  ContatoIP67
//
//  Created by ios6750 on 04/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import Foundation

class contatoDao: CoreDataUtil {

    static private var defaultDAO: contatoDao!
    var contatos: Array<Contato>!
    
    static func sharedInstance() -> contatoDao{
        if defaultDAO == nil{
            defaultDAO = contatoDao()
        }
        return defaultDAO
    }
    
    //sobresquere o metodo init para private
    override private init(){
        self.contatos = Array()
        super.init()
        self.inserirDadosIniciais()
        self.carregaContatos()
    }
    func adiciona(_ contato:Contato){
    
        contatos.append(contato)
        //print(contato)
    
    }
    
    func listaTodos() -> [Contato]{
        return contatos
    }
    
    func novoContato() -> Contato{
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
        
    }
    
    func buscaContatoNaPosicao(_ posicao: Int) -> Contato {
        return contatos[posicao]
    }
    
    func removeContatoNaPosicao(_ posicao: Int){
        persistentContainer.viewContext.delete(contatos[posicao])
        contatos.remove(at: posicao)
    }
    
    func buscaPosicaoDoContato(_ contato:Contato) -> Int{
        return contatos.index(of: contato)!
    }
    
    func inserirDadosIniciais(){
        let configuracoes = UserDefaults.standard
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos {
            let caelumSP = NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
            
            caelumSP.nome="Caelum SP"
            caelumSP.endereco = "Sao Paulo"
            caelumSP.telefone = "12345678"
            caelumSP.site = "www.com.br"
            caelumSP.latitude = -23.123456
            caelumSP.longitude = -46.123456
            
            self.saveContext()
            
            configuracoes.set(true,forKey: "dados_inseridos")
            
            configuracoes.synchronize()
            
        }
    }
    
    func carregaContatos(){
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        do {
            self.contatos = try self.persistentContainer.viewContext.fetch(busca)
        }catch let error as NSError {
            print(error.description)
        }
    }
    
}
