//
//  LoginViewController.swift
//  Integradora
//
//  Created by imac on 03/04/24.
//

import UIKit
class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var btnfondo: UILabel!
    @IBOutlet weak var btnlogin: UIButton!
    
    @IBOutlet weak var btnfondito: UIButton!
    @IBOutlet weak var txfCorreo: UITextField!
    
    @IBOutlet weak var txfContraseña: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView()
    {
        btnlogin.layer.cornerRadius = 10
        btnfondito.layer.cornerRadius = 30
        btnfondito.isEnabled = false
        btnfondo.isEnabled = false
        
        txfContraseña.isSecureTextEntry = true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txfCorreo.text!.count > 1 && txfContraseña.text!.count > 1 {
            btnlogin.isEnabled = true
            
        } else {
            btnlogin.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfCorreo {
            txfContraseña.becomeFirstResponder()
        } else if textField == txfContraseña {
            txfContraseña.becomeFirstResponder()
        } 
        return true
    }
    
    func enviardatosApi() {
            let url = URL(string: "https://apt-namely-buffalo.ngrok-free.app/api/auth/login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parametros: [String: Any] = [
                "email": txfCorreo.text!,
                "password": txfContraseña.text!
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parametros)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let tarea = URLSession.shared.dataTask(with: request) { datos, respuesta, error in
                if let datos = datos {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: datos) as? [String: Any] {
                            print("Aver si jala")
                            if let token = json["access_token"] as? String {
                                self.saveTokenToUserDefaults(token: token)
                                
                            }
                            if let respuestaHTTP = respuesta as? HTTPURLResponse {
                                if respuestaHTTP.statusCode == 200 {
                                    DispatchQueue.main.async {
                                        let alerta = UIAlertController(title: "Inicio Exitoso", message: "Verifica tu correo para la autenticacion en dos pasos", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                            self.txfCorreo.text = ""
                                            self.txfContraseña.text = ""
                                            self.performSegue(withIdentifier: "sgTabBar", sender: nil)
                                        }
                                        alerta.addAction(okAction)
                                        self.present(alerta, animated: true, completion: nil)
                                    }
                                } else {
                                    print("Error en la solicitud: \(respuestaHTTP.statusCode)")
                                    DispatchQueue.main.async {
                                        let alerta = UIAlertController(title: "ERROR", message: "Error al hacer login", preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "ACEPTAR", style: .default)
                                        alerta.addAction(ok)
                                        self.present(alerta, animated: true)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error al analizar los datos JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("No se recibieron datos de la respuesta")
                }
            }
            tarea.resume()
        }
    

    @IBAction func enviardatos(_ sender: Any) {
        if evaluaCorreo(txfCorreo.text!) && txfContraseña.text!.count >= 8
        {
            enviardatosApi()
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
    
    func saveTokenToUserDefaults(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        print("Token guardado en UserDefaults: \(token)")
    }
    
    

}
