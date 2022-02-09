//
//  User.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 24/01/22.
//

import Foundation



 class User{
    
    var balance: Float? = 1000.0
    var walet: [String: Float]? = ["USD": 100, "CAD" : 10, "BTC" : 0, "GBP": 0, "ARS" : 0 , "AUD" : 0 , "JPY" : 0, "CNY" : 0, "EUR" : 0]
    var convertedBalance: Float? = 0.0

    
    static let shared: User = {
        
        let instance = User()
        
        return instance
    }()
      
    private init(){}

  

}


extension User: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}



