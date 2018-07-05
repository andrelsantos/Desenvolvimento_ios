//
//  ListaContatosViewControler.swift
//  ContatoIP67
//
//  Created by ios6750 on 05/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class ListaContatosViewControler: UITableViewController,FormularioContatoViewControllerDelegate {
    
    var dao: contatoDao
    static let cellIdentifier = "cell"
    var linhaDestaque: IndexPath?
    
    //utilizado para a instancia de ContatoDao utilizando padrão de projeto singleton
    required init?(coder aDecoder: NSCoder) {
        self.dao = contatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    func exibeFormulario(_ contato:Contato){
        //exibe no fomr contato o contato clicado
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        
        let formulario = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as! FormularioContatoViewController
        
        formulario.delegate = self
        formulario.contato = contato
        
        self.navigationController?.pushViewController(formulario, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //exibe o botão edit
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exibirMaisAcoes(gesture:)))
        
        self.tableView.addGestureRecognizer(longPress)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return dao.listaTodos().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //carrega o contato na tableview
        let contato:Contato = self.dao.buscaContatoNaPosicao(indexPath.row)
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewControler.cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ListaContatosViewControler.cellIdentifier)
        }
        
        cell!.textLabel?.text = contato.nome
        
        return cell!
        
    }
    
    func exibirMaisAcoes(gesture:  UIGestureRecognizer){
        if gesture.state == .began{
            let ponto = gesture.location(in: self.tableView)
            if let indexPath:IndexPath? = self.tableView.indexPathForRow(at: ponto){
                let contato = self.dao.buscaContatoNaPosicao((indexPath?.row)!)
                let acoes = GerenciadoDeAcoes(do: contato)
                acoes.exibirAcoes(em: self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //exibe o contato na tableview
        self.tableView.reloadData()
        //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.linhaDestaque != nil{
            self.tableView.selectRow(at: self.linhaDestaque, animated: true , scrollPosition: .middle)
            self.linhaDestaque = Optional.none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contatoSelecionado = dao.buscaContatoNaPosicao(indexPath.row)
        
        self.exibeFormulario(contatoSelecionado)
    }

    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.dao.removeContatoNaPosicao(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        //} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func contatoAtualizado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
    }
    
    func contatoAdicionado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FormSegue"{
            if let formulario = segue.destination as? FormularioContatoViewController{
                formulario.delegate = self
            }
        }
    }
    
       
}
