//
//  Currency.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 17/01/22.
//



import Foundation


// Tratamento de chave genérica
struct GenericCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
}

struct Response: Decodable {

    // Define the inner model as usual
    struct Currency: Codable {
        var currencyId: String?
        var name: String?
        var buy: Float?
        var sell: Float?
        var variation: Float?
      
      
    
        
        private enum CodingKeys: String, CodingKey {
            case name
            case buy          = "buy"
            case sell          = "sell"
            case variation     = "variation"
           
          
        }
        init(from decoder: Decoder) throws {
        
               let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
               name = try container.decode(String?.self, forKey: CodingKeys.name)
               buy = try container.decode(Float?.self, forKey: CodingKeys.buy)
               sell = try container.decode(Float?.self, forKey: CodingKeys.sell)
               variation = try container.decode(Float?.self, forKey: CodingKeys.variation)
        
               currencyId = container.codingPath.first!.stringValue
            }
        
        
    }

    var currencies: [Currency]
    private enum CodingKeys: String, CodingKey {
        case  currencies
    }

    // You must decode the JSON manually
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    

        self.currencies = [Currency]()
        let subContainer = try container.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: .currencies)
        for key in subContainer.allKeys {
            let currency = try subContainer.decode(Currency.self, forKey: key)
            self.currencies.append(currency)
        }
    }
}




