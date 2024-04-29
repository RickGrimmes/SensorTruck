//
//  CuentaViewController.swift
//  Integradora
//
//  Created by imac on 05/04/24.
//

import UIKit

class CuentaViewController: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        verificarCodigoAPI()

        // Do any additional setup after loading the view.
    }
    
    func clearToken() {
        UserDefaults.standard.set("", forKey: "token")
    }

    
    @IBAction func btnlogout(_ sender: Any) {
        clearToken()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "sgLogout", sender: nil)
        }
    }
    
    func verificarCodigoAPI() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("No se encontró el token en UserDefaults")
            return
        }

        let url = URL(string: "https://apt-namely-buffalo.ngrok-free.app/api/auth/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Cambiado a GET
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let tarea = URLSession.shared.dataTask(with: request) { datos, respuesta, error in
            if let datos = datos {
                if let respuestaHTTP = respuesta as? HTTPURLResponse {
                    if respuestaHTTP.statusCode == 200 {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any]
                            {
                                print(json)
                                if let usuario = json["user"] as? [String: Any],
                                   let nombre = usuario["name"] as? String,
                                   let email = usuario["email"] as? String {
                                    DispatchQueue.main.async {
                                        self.lblInfo.text = "Nombre: \(nombre)\n\nEmail: \(email)"
                                    }
                                }

                            }
                        } catch {
                            print("Error al serializar JSON: \(error.localizedDescription)")
                        }
                    } else {
                        print("Error en la solicitud: \(respuestaHTTP.statusCode)")
                        DispatchQueue.main.async {
                            self.lblInfo.text = "Error al obtener la información del usuario"
                        }
                    }
                }
            } else {
                print("Error en la solicitud: \(error?.localizedDescription ?? "Error desconocido")")
                DispatchQueue.main.async {
                    self.lblInfo.text = "Error al obtener la información del usuario"
                }
            }
        }

        tarea.resume()
    }
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
