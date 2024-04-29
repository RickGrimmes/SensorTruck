    //
//  ViewController.swift
//  Integradora
//
//  Created by Mac03 on 12/03/24.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imvSplash: UIImageView!
    
    @IBOutlet weak var btnmenu: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let w = 1.0 * view.frame.width
        let h = 1.0 * w
        let x = (view.frame.width - w)/2
        let y = -h
        
        imvSplash.frame = CGRect(x: x, y: y, width: w, height: h)
        imvSplash.alpha = 0
        btnmenu.isEnabled = false
        
       
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        UIView.animate(withDuration: 2) {
            self.imvSplash.frame.origin.y = (self.view.frame.height - self.imvSplash.frame.height)/2
            self.imvSplash.alpha = 1
        } completion: { res in
            if let token = UserDefaults.standard.string(forKey: "token") {
                self.verificarCodigoAPI(token: token)
            } else {
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
            
        }
    }
    
    func verificarCodigoAPI(token: String) {
            // URL de la API
            let url = URL(string: "https://apt-namely-buffalo.ngrok-free.app/api/auth/me")!
            
            // Crear la solicitud
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Crear el cuerpo de la solicitud con el código de verificación
            let parametros: [String: Any] = [
                "verificacion": "xd"
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parametros)
            
            // Establecer el encabezado para indicar que el cuerpo de la solicitud es JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Crear la tarea de sesión para enviar la solicitud
            let tarea = URLSession.shared.dataTask(with: request) { datos, respuesta, error in
                // Manejar la respuesta de la API
                if let datos = datos {
                    if let respuestaHTTP = respuesta as? HTTPURLResponse {
                        if respuestaHTTP.statusCode == 200 {
                            // La solicitud fue exitosa
                            print("Código verificado correctamente")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "sgmenu", sender: nil)
                            }
                        } else {
                            // La solicitud falló
                            print("Error en la solicitud: \(respuestaHTTP.statusCode)")
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "sgSplash", sender: nil)
                            }
                        }
                    }
                } else {
                    // Hubo un error en la solicitud
                    print("Error en la solicitud: \(error?.localizedDescription ?? "Error desconocido")")
                }
            }
            
            // Ejecutar la tarea de sesión
            tarea.resume()
        }


}

