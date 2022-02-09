//
//  ExchangeViewController.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 24/01/22.
//

import Foundation
import UIKit




let user = User.shared


class ExchangeViewController : UIViewController, UITableViewDelegate, UITextFieldDelegate {
  
  
    @IBOutlet weak var lbBalance: UILabel?
    @IBOutlet weak var lbCurrencyBalance: UILabel?
    @IBOutlet weak var tfQuantity: UITextField?
    @IBOutlet weak var exchangeView: UIView?

    @IBOutlet weak var btnBuy: UIButton?
    @IBOutlet weak var btnSell: UIButton?
    
    
    @IBOutlet weak var lbCurrencyIdAndName: UILabel?
    @IBOutlet weak var lbVariation: UILabel?
    @IBOutlet weak var lbBuy: UILabel?
    
    @IBOutlet weak var lbSell: UILabel?
    

    
    var currencies: [Response.Currency] = []

   
    var currentWaletIdIndex: String = ""
    var currentWaletNameIndex: String = ""
    var currentValue: Float? = 0.0
    var isSelable: Bool = true
   
    
    override func viewDidLoad() {
    super.viewDidLoad()

        
        tfQuantity?.delegate = self
        btnBuy?.isUserInteractionEnabled = false
        btnBuy?.alpha = 0.5
        btnSell?.isUserInteractionEnabled = false
        btnSell?.alpha = 0.5
        
        
        let currency = currencies[0]
        guard let currencyVariation: Float = currency.variation, let currencySell: Float = currency.sell, let balance: Float = user.balance  else{return}
        user.convertedBalance = balance / currencySell
       
        
        prepare(with: currency)
        setColor(with: currencyVariation)
        
        let myColor = UIColor.white
        tfQuantity?.layer.borderColor = myColor.cgColor
        tfQuantity?.layer.borderWidth = 1.0
        tfQuantity?.layer.cornerRadius = 15
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
                DispatchQueue.main.async{
            }
      
  
        guard let userWalet: Float = user.walet?[currentWaletIdIndex], let balance: Float =  user.balance else{return}
        print(userWalet)
        lbCurrencyBalance?.text = String(format: "%.2f", userWalet) + " " + currentWaletNameIndex + " em caixa"
        lbBalance?.text = "Saldo disponível: R$" + String(format: "%.2f", balance)

    }
    
    
    // Valida entrada de dados no textfield e checa propriedades dos botoes
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else{return false}
        guard let userWalet: Float = user.walet?[currentWaletIdIndex] else {return text.isEmpty}
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

     
        if (!text.isEmpty){
            
            guard let formatedNumber: Float = numberFormatter.number(from: text)?.floatValue, let convertedBalance: Float = user.convertedBalance else{return  text.isEmpty}
   
            switch (userWalet >= formatedNumber && isSelable == true) && formatedNumber > 0 {

                case true :
                    btnSell?.isUserInteractionEnabled = true
                    btnSell?.alpha = 1.0
                case false:
                    btnSell?.isUserInteractionEnabled = false
                    btnSell?.alpha = 0.5
            }
            switch(convertedBalance >= formatedNumber && formatedNumber > 0){

                case true:
                    btnBuy?.isUserInteractionEnabled = true
                    btnBuy?.alpha = 1.0
                case false:
                    btnBuy?.isUserInteractionEnabled = false
                    btnBuy?.alpha = 0.5
            }
            
            currentValue = formatedNumber

        }else{
            btnBuy?.isUserInteractionEnabled = false
            btnBuy?.alpha = 0.5
            btnSell?.isUserInteractionEnabled = false
            btnSell?.alpha = 0.5
            
        }
           
                 return true
                
                    
                }

    @IBAction func didBuyAction(_ sender: UIButton) {
   
        let storyboard = UIStoryboard(name: String( describing: MessageViewController.self), bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "MessageViewController") as? MessageViewController{
            let currency = currencies[0]
            guard let currencyBuy: Float = currency.buy, let inputValue: Float = currentValue else{return}

            if let value: Float = currentValue, let id: String = currency.currencyId, let name: String = currency.name , let userWalet: Float =
                user.walet?[currentWaletIdIndex]{
                
               
                let totValue: Float =  inputValue * currencyBuy
                
                //Atualiza dados do usuario
                guard let convertedBalance: Float = user.convertedBalance else{return}
                let updateBalance = getTotalValueAfterBuy(balance: convertedBalance, currentValue: inputValue, currencyBuy: currencyBuy)
                let updatedWalet: Float = userWalet + inputValue
                user.balance = updateBalance
                user.walet?[id] = updatedWalet
                //Carrega mensagem na tela seguinte
                vc.message = sendMessage(operation: "Compra", value: value  , currencyId: id, currencyName: name, total: totValue)
                self.navigationController?.pushViewController(vc, animated: true)
              
            }
            
        }
    
    }
    
    @IBAction func didSellAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: String( describing: MessageViewController.self), bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "MessageViewController") as? MessageViewController{
            let currency = currencies[0]
            guard let currencySell: Float = currency.sell, let inputValue: Float = currentValue else{return}

            if let value: Float = currentValue, let id: String = currency.currencyId, let name: String = currency.name , let userWalet: Float = user.walet?[currentWaletIdIndex], let balance: Float = user.balance  {
               
                let totValue: Float =  inputValue * currencySell
                
                //Atualiza dados do usuario
                let updateBalance = getTotalValueAfterSell(balance: balance, currentValue: inputValue, currencySell: currencySell)
                let updatedWalet: Float = userWalet - inputValue
                user.balance = updateBalance
                user.walet?[id] = updatedWalet
                //Carrega mensagem na tela seguinte
                vc.message = sendMessage(operation: "Venda", value: value  , currencyId: id, currencyName: name, total: totValue)
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
            
        }
        
    }
    
    
    func getTotalValueAfterBuy(balance: Float, currentValue: Float, currencyBuy: Float) -> Float{
        let total: Float  = (balance - currentValue) * currencyBuy
        
        return total
    }
    
    func getTotalValueAfterSell(balance: Float, currentValue: Float, currencySell: Float) -> Float{
        let total: Float  = balance + (currentValue * currencySell)
        
        return total
    }
    
    //Prepare
    func prepare(with currency: Response.Currency){
  
        guard let currencyId: String = currency.currencyId, let name: String = currency.name, let buy: Float = currency.buy, let sell: Float = currency.sell, let variation: Float = currency.variation else{return}
        
        
        lbCurrencyIdAndName?.text = currencyId + " - " + name
        lbVariation?.text = String(format: "%.2f", variation) + "%"
        lbBuy?.text = "Compra: " + String(format: "%.2f", buy)
        
        if currency.sell == nil {
            lbSell?.text = "Venda: " + String(format: "%.2f", buy)

            
        }
        else{
        lbSell?.text = "Venda: " + String(format: "%.2f", sell)
        }
        
    }
    
 
    //Gera a mensagem de operação
    func sendMessage(operation: String, value: Float, currencyId: String, currencyName: String, total: Float) ->  String {
        var message = " "
        
        if operation == "Compra"{
            message = String(format: "Parabéns!\nVocê acabou de comprar %.2f %@ - %@, totalizando R$%.2f",  value, currencyId, currencyName, total)
                   
            }
        if operation == "Venda"{
            message = String(format: "Parabéns!\nVocê acabou de vender %.2f %@ - %@, totalizando R$%.2f",  value, currencyId, currencyName, total)
                   
            }
        
        return message
    }

    
    func setColor(with variation: Float){
        if variation < 0 {
            lbVariation?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if variation > 0{
            lbVariation?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
 
}



@IBDesignable extension UIButton {

    @IBInspectable override var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable override var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable override var borderColor: UIColor? {
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











