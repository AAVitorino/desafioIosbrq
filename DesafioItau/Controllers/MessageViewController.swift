//
//  MessageViewController.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 16/01/22.
//

import Foundation

import UIKit

class MessageViewController: UIViewController {
    
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var HomeStackView: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewBackground.layer.borderColor = UIColor.white.cgColor

        
        // Arredonda os cantos das views
        // self.viewBackground?.roundCorners(cornerRadiuns: 50.0, typeCorners:
                                           // [.inferiorDireito,
                                             //.superiorDireito,
                                             //.inferiorDireito,
                                             //.inferiorEsquerdo])
        
    }


}
