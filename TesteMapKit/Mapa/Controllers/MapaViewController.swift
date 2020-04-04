//
//  ViewController.swift
//  TesteMapKit
//
//  Created by Gabriel Mendonça on 04/04/20.
//  Copyright © 2020 Gabriel Mendonça. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    
    var localUsuario = CLLocationManager()
    var mapaCentralizado = false
    var viagem: Dictionary< String, String> = [:]
    var indiceSelecionado: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indice = indiceSelecionado {
            if indice == -1 {
                gerenciaLocalizacaoUsuario()
            } else {
                exbirAnotacao(viagem: viagem)
            }
        }
        
        // Reconhecedor de gestos
        let reconhecerGesto = UILongPressGestureRecognizer(target: self, action: #selector(MapaViewController.marcar(gesture:)))
        reconhecerGesto.minimumPressDuration = 2
        mapa.addGestureRecognizer(reconhecerGesto)
    }
    
    func gerenciaLocalizacaoUsuario(){
        localUsuario.delegate = self
        localUsuario.desiredAccuracy = kCLLocationAccuracyBest
        localUsuario.requestWhenInUseAuthorization()
        localUsuario.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !mapaCentralizado {
            
            let localizacaoUsuario: CLLocation = locations.last!
            
            let deltaLatitude: CLLocationDegrees = 0.01
            let deltaLongitude: CLLocationDegrees = 0.01
            let coordenadas: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: localizacaoUsuario.coordinate.latitude, longitude: localizacaoUsuario.coordinate.longitude)
            let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
            let regiao: MKCoordinateRegion = MKCoordinateRegion(center: coordenadas, span: areaVisualizacao)
            mapa.setRegion(regiao, animated: true)
            mapa.showsUserLocation = true
            mapaCentralizado = true
        }
    }
    
    func exbirAnotacao(viagem: Dictionary < String, String> ){
        
        // Exibe anotacao com os dados de endereco
        if let localViagem = viagem["local"]{
            if let latitudeS = viagem["latitude"]{
                if let longitudeS = viagem["longitude"]{
                    if let latitude = Double(latitudeS){
                        if let longitude = Double(longitudeS){
                            
                            
                            let anotacao = MKPointAnnotation()
                            
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func marcar(gesture: UIGestureRecognizer){
        if gesture.state == UIGestureRecognizer.State.began {
            
            // Recupera as coordenadas do ponto selecionado
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            // recupera endereco do ponto selecionado
            var localCompleto = "Endereço não encontrado!!"
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, error) in
                if error == nil {
                    if let dadosLocal = local?.first {
                        if let nome  = dadosLocal.name {
                            localCompleto = nome
                        } else {
                            if let endereco = dadosLocal.thoroughfare{
                                localCompleto = endereco
                            }
                            
                        }
                    }
                    // salvar dados no dispositivo
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvarViagem(viagem: self.viagem)
                    
                    
                    // Exibe anotacao com os dados de endereco
                    
                    let anotacao = MKPointAnnotation()
                    
                    anotacao.coordinate.latitude = coordenadas.latitude
                    anotacao.coordinate.longitude = coordenadas.longitude
                    anotacao.title = localCompleto
                    
                    
                    self.mapa.addAnnotation(anotacao)
                    
                } else {
                    
                }
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            
            let alertController = UIAlertController(title: "Permissao Localização", message: "Necessario acesso a sua localização", preferredStyle: .alert)
            
            let actionConfigurate = UIAlertAction(title: "Abrir configurações", style: .default , handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            let actionCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(actionConfigurate)
            alertController.addAction(actionCancelar)
            
            present(alertController, animated: true , completion: nil)
        }
        
    }
    
}

