//
//  TemperaturaViewController.swift
//  ContatoIP67
//
//  Created by ios6750 on 14/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class TemperaturaViewController: UIViewController {

    @IBOutlet weak var labelCondicaoAtual: UILabel!
    @IBOutlet weak var labelTemperaturaMaxima: UILabel!
    @IBOutlet weak var labelTemperaturaMinima: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var contato:Contato?
    
    let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?appid=bf6fce607ac5b599f6de4c598439c3fe&units=metric"
    let URL_BASE_IMAGE = "http://openweathermap.org/img/w"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contato = self.contato {
            if let endpoint = URL(string: URL_BASE + "&lat=\(contato.latitude ?? 0)&lon=\(contato.longitude ?? 0)") {
            let session = URLSession(configuration: .default)
            print(endpoint)
                let task = session.dataTask(with: endpoint) { (data,response,error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            do{
                                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] {
                                    let main = json["main"] as! [String:AnyObject]
                                    let weather = json["weather"] as! [String:AnyObject]
                                    let temp_min = main["temp_min"] as! Double
                                    let temp_max = main["temp_max"] as! Double
                                    let icon = json["icon"] as! String
                                    let condicao = json["condicao"] as! String
                                    
                                    DispatchQueue.main.async {
                                        print(condicao)
                                        print(temp_max)
                                        print(temp_max)
                                        print(icon)
                                        
                                        self.labelCondicaoAtual.text = condicao
                                        self.labelTemperaturaMaxima.text = temp_max.description + "º"
                                        self.labelTemperaturaMinima.text = temp_min.description + "º"
                                        self.pegaImagem(icon)
                                        
                                        self.labelCondicaoAtual.isHidden = false
                                        self.labelTemperaturaMaxima.isHidden = false
                                        self.labelTemperaturaMinima.isHidden = false
                                    }
                                    
                                }
                                    
                                }catch let erro as NSError {
                                    print(erro.localizedDescription)
                                }
                            
                        }
                    }
                        
                
                }
                task.resume()
            }
        }
    }
    
    private func pegaImagem (_ icon: String){
        if let endpoint = URL(string: URL_BASE + "&lat=\(contato?.latitude ?? 0)&lon=\(contato?.longitude ?? 0)") {
            let session = URLSession(configuration: .default)
            print(endpoint)
            let task = session.dataTask(with: endpoint) { (data,response,error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            print("Exibindo Imagem")
                            self.imageView.image = UIImage (data: data!)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
