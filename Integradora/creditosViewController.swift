//
//  creditosViewController.swift
//  Integradora
//
//  Created by imac on 03/04/24.
//

import UIKit

class creditosViewController: UIViewController {

    @IBOutlet weak var fotogrupo: UIImageView!
    @IBOutlet weak var fotogrupal: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupview()
    }
    

    func setupview()
    {
        fotogrupal.layer.cornerRadius = 30
        fotogrupo.layer.cornerRadius = 30
    }

}
