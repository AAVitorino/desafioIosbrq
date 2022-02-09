
//
//  ViewController.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 13/01/22.
//

import UIKit
import Foundation


class MainViewController: UIViewController {
    
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var HomeStackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var currencies: [Response.Currency] = []


        override func viewDidLoad() {
        super.viewDidLoad()
          
        self.tableView.delegate = self
        self.tableView.dataSource = self

    
         
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
            navigationController?.setNavigationBarHidden(false, animated: animated)
            self.navigationItem.hidesBackButton = true
        
        CurrenciesServices.getCurrencies { (currencies) in

            self.currencies = currencies
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        } onError: { (error) in
            
        }

    }
    
  
    
}


class TableViewCell : UITableViewCell{

    @IBOutlet weak var lbCurrencyId: UILabel?
    @IBOutlet weak var lbVariation: UILabel?
    


    func setColor(with variation: Float){
        if variation < 0.0 {
            lbVariation?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if variation > 0.0{
            lbVariation?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    // Prepara celula
    func prepare(with currency: Response.Currency){
        guard let currencyId: String = currency.currencyId, let variation: Float = currency.variation else{return}
        
        lbCurrencyId?.text = currencyId
        lbVariation?.text = String(format: "%.2f", variation)
        
    }
}


extension MainViewController: UITableViewDataSource{
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1 //return currencies.count

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return self.currencies.count
       }
       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
      
        guard let cell = tableView.dequeueReusableCell( withIdentifier: "cell", for: indexPath) as? TableViewCell else{return UITableViewCell()}
        let currency = currencies[indexPath.section]
        if let currencyVariation = currency.variation {
            
            
            
          
            cell.setColor(with: currencyVariation )
            cell.prepare(with: currency)
        } 
      
        return cell
     }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }

}

extension MainViewController: UITableViewDelegate{
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: String( describing: ExchangeViewController.self), bundle: nil)
        //let vc = storyboard.instantiateInitialViewController()!
        if let vc = storyboard.instantiateViewController(identifier: "ExchangeViewController") as? ExchangeViewController{
      
            let currency = currencies[tableView.indexPathForSelectedRow!.section]
            guard let currencyId: String = currency.currencyId, let name: String = currency.name else{return}
            vc.currencies = [currency]
            vc.currentWaletIdIndex = currencyId
            vc.currentWaletNameIndex = name
   
    
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
}


@IBDesignable extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


