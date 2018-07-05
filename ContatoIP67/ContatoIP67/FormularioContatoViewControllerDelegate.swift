//
//  FormularioContatoViewControllerDelegate.swift
//  ContatoIP67
//
//  Created by ios6750 on 07/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {
    func contatoAtualizado(_ contato:Contato)
    func contatoAdicionado(_ contato:Contato)
}
