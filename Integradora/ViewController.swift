//
//  ViewController.swift
//  Integradora
//
//  Created by Mac03 on 12/03/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var BTNLOGIN: UIButton!
    
    @IBOutlet weak var txfcorreo: UITextField!
    @IBOutlet weak var txfNombre: UITextField!
    @IBOutlet weak var txfcontra: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        txfNombre.delegate = self
        txfcorreo.delegate = self
        txfcontra.delegate = self
        
      
    }
    
    func setupView()
    {
        BTNLOGIN.layer.cornerRadius = 29
        BTNLOGIN.isEnabled = false
        btn2.isEnabled = false
        btn2.layer.cornerRadius = 10
        txfcontra.isSecureTextEntry = true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txfNombre.text!.count > 1 && txfcorreo.text!.count > 1 && txfcontra.text!.count > 1 {
            btn2.isEnabled = true
            
        } else {
            btn2.isEnabled = false
        }
    }
    
    func enviarDatosAPI() {
        // URL de la API
        let url = URL(string: "https://apt-namely-buffalo.ngrok-free.app/api/auth/register")!
        
        // Crear la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Crear el cuerpo de la solicitud con los datos del usuario
        let parametros: [String: Any] = [
            "name": txfNombre.text!,
            "email": txfcorreo.text!,
            "password": txfcontra.text!
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parametros)
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let tarea = URLSession.shared.dataTask(with: request) { datos, respuesta, error in
         
            if let datos = datos {
                if let respuestaHTTP = respuesta as? HTTPURLResponse {
                    if respuestaHTTP.statusCode  == 201 {
                        // La solicitud fue exitosa
                        print("Solicitud exitosa")
                        DispatchQueue.main.async {
                        let alerta = UIAlertController(title: "Registro Exitoso", message: "Tu cuenta se ha registrado exitosamente", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                self.txfNombre.text = ""
                                self.txfcorreo.text = ""
                                self.txfcontra.text = ""
                                self.performSegue(withIdentifier: "sgHome", sender: nil)
                                }
                                
                                alerta.addAction(okAction)
                                                
                                                self.present(alerta, animated: true, completion: nil)
                                            }
                        
                    } else {
                       
                        print("Error en la solicitud: \(respuestaHTTP.statusCode)")
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(title: "ERROR", message: "Comprueba tus datos ", preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "ACEPTAR", style: .default)
                            alerta.addAction(ok)
                            self.present(alerta, animated: true)
                        }
                    }
                }
            } else {
                
                print("Error en la solicitud: \(error?.localizedDescription ?? "Error desconocido")")
            }
        }
        
        
        tarea.resume()
    }



    
    @IBAction func enviardatos(_ sender: Any) {
        if evaluaCorreo(txfcorreo.text!) && txfcontra.text!.count >= 8
        {
            enviarDatosAPI()
        }
        else
        {
            let alerta = UIAlertController(title: "ERROR", message: "Debes proporcionar un correo valido y contraseña mayor a 8 caracteres", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "ACEPTAR", style: .default)
            alerta.addAction(ok)
            present(alerta, animated: true)
        }
    }
    
    func evaluaCorreo(_ correo:String) -> Bool
    {
        let expReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", expReg)
        return emailPred.evaluate(with: correo)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfNombre {
            txfcorreo.becomeFirstResponder()
        } else if textField == txfcorreo {
            txfcontra.becomeFirstResponder()
        } else {
            txfcontra.resignFirstResponder()
        }
        return true
    }
    
    
    
    
   

}

