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
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var btnHome: UIButton!
        
    var message: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare(with: message)
        //viewBackground.layer.borderColor = UIColor.white.cgColor

  
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func prepare(with message: String){
        
        tvMessage.text = message
        
    }
    
    
    @IBAction func backTohome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name:"MainViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController{
            
            self.navigationController?.pushViewController(vc, animated: true)
      
            
        }
    }
    
}
