//
//  verificarcodigoViewController.swift
//  Integradora
//
//  Created by imac on 05/04/24.
//

import UIKit

class verificarcodigoViewController: UIViewController {

    @IBOutlet weak var botontab: UIButton!
    @IBOutlet weak var txfcodigo: UITextField!
    @IBOutlet weak var btnverificar: UIButton!
    @IBOutlet weak var viewcodigo: UIView!
    @IBOutlet weak var btnregresar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()

       
    }
    
    
    func setupview()
    {
        viewcodigo.layer.cornerRadius = 30
        btnverificar.layer.cornerRadius = 15
        btnregresar.layer.cornerRadius = 15
        botontab.isEnabled = false
        
    }
    
    func verificarCodigoAPI() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("No se encontró el token en UserDefaults")
            return
        }

        // URL de la API
        let url = URL(string: "https://apt-namely-buffalo.ngrok-free.app/api/auth/verificar")!

        // Crear la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Crear el cuerpo de la solicitud con el código de verificación
        let parametros: [String: Any] = [
            "verificacion": txfcodigo.text!
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
                            self.performSegue(withIdentifier: "sgTab", sender: nil)
                            self.txfcodigo.text! = ""
                        }
                    } else {
                        // La solicitud falló
                        print("Error en la solicitud: \(respuestaHTTP.statusCode)")
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(title: "ERROR", message: "Codigo invalido", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "ACEPTAR", style: .default)
                            alerta.addAction(ok)
                            self.present(alerta, animated: true)
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


    
    
    @IBAction func enviarcodigo(_ sender: Any) {
        if txfcodigo.text!.count == 6{
            verificarCodigoAPI()
        }
        else {
            let alerta = UIAlertController(title: "ERROR", message: "Proporciona un codigo valido y de 6 caracteres", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "ACEPTAR", style: .default)
            alerta.addAction(ok)
            present(alerta, animated: true)
        }
    }
    


}
