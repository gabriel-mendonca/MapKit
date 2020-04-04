//
//  ListaLocalViewController.swift
//  TesteMapKit
//
//  Created by Gabriel Mendonça on 04/04/20.
//  Copyright © 2020 Gabriel Mendonça. All rights reserved.
//

import UIKit

class ListaLocalViewController: UITableViewController {
    
    var locais: [Dictionary < String, String >] = []
    var controleNavegacao = "Adicionar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        atualizarViagens()
        controleNavegacao = "Adicionar"
        
    }
    
    func setUpView(){
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locais.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viagem = locais[indexPath.row]["local"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viagem
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            ArmazenamentoDados().removerViagem(indice: indexPath.row)
            atualizarViagens()
        }
    }
    
    func atualizarViagens(){
        
        locais = ArmazenamentoDados().listarViagem()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleNavegacao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verLocal" {
            let viewControllerDestintion = segue.destination as! MapaViewController
            
            if self.controleNavegacao == "listar"{
                if let indiceRecuperado = sender {
                    
                    let indice = indiceRecuperado as! Int
                    viewControllerDestintion.viagem = locais[indice]
                    viewControllerDestintion.indiceSelecionado = indice
                    
                } else {
                    viewControllerDestintion.viagem = [:]
                    viewControllerDestintion.indiceSelecionado = -1
                    
                }
            }
        }
        
    }
    
    
    
    
}
