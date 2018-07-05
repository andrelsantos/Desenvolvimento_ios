//
//  ContatosNoMapaViewController.swift
//  ContatoIP67
//
//  Created by ios6750 on 10/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit
import MapKit

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    
    var contatos:[Contato] = Array()
    let dao:contatoDao = contatoDao.sharedInstance()
    
    override func viewWillAppear(_ animated: Bool) {
        self.contatos = dao.listaTodos()
        self.mapa.addAnnotations(self.contatos as! [MKAnnotation])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapa.removeAnnotations(self.contatos as! [MKAnnotation])
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapa.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        
        self.navigationItem.rightBarButtonItem = botaoLocalizacao

        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier:String = "pino"
        
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
                
            }else{
                pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        
        if let contato = annotation as? Contato {
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            
            let frame = CGRect(x: 0.0, y: 0.0, width: 32.0, height: 32.0)
            let imagemContato = UIImageView(frame: frame)
            
            imagemContato.image = contato.foto
            
            pino.leftCalloutAccessoryView = imagemContato
            
        }
        
        return pino
        
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //centralizar no mapa
        /*
        var r:MKMapRect = self.mapa.visibleMapRect;
        
        
        let pt: MKMapPoint = MKMapPointForCoordinate((view.annotation?.coordinate)!);
        r.origin.x = pt.x - r.size.width * 0.55;
        r.origin.y = pt.y - r.size.height * 0.55;
        
        self.mapa.setVisibleMapRect(r, animated: true)
        */
        //zoom no mapa
        // get the particular pin that was tapped
        let pinToZoomOn = view.annotation
     
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(0.01, 0.01)
     
        // or use the current map zoom and just center the map
        //let span = mapView.region.span
     
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
