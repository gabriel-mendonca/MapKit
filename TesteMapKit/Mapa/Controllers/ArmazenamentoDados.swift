//
//  ArmazenamentoDados.swift
//  TesteMapKit
//
//  Created by Gabriel Mendonça on 04/04/20.
//  Copyright © 2020 Gabriel Mendonça. All rights reserved.
//

import UIKit

class ArmazenamentoDados {
    
    var chavesArmazenamento = "locaisViagem"
    var viagens: [Dictionary<String, String>] = []
    
    func getDefaults() -> UserDefaults {
        UserDefaults.standard
    }
    
    func salvarViagem(viagem: Dictionary<String, String> ){
        viagens = listarViagem()
        
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: chavesArmazenamento)
        getDefaults().synchronize()
        
    }
    
    func listarViagem() -> [Dictionary<String, String>] {
        let dados = getDefaults().object(forKey: chavesArmazenamento)
        if dados != nil {
            return dados as! Array
        } else {
            return []
            
        }
    }
    
    func removerViagem(indice: Int){
        viagens = listarViagem()
        viagens.remove(at: indice)
        getDefaults().set(viagens, forKey: chavesArmazenamento)
        getDefaults().synchronize()
        
        
    }
    
    
    
}
