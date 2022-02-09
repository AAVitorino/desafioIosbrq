import UIKit
import Foundation






let jsonString = """
{
    "currencies": {
        "USD": {
            "name": "Dollar",
            "buy": 5.4455,
            "sell": 5.4461,
            "variation": -2.232
        },
        "CAD": {
            "name": "Canadian Dollar",
            "buy": 4.356,
            "sell": null,
            "variation": -2.101
        },
        "BTC": {
            "name": "Bitcoin",
            "buy": 241981.406,
            "sell": 241981.406,
            "variation": -0.414
        }
    }
}
"""


// A struct that conforms to the CodingKey protocol
// It defines no key by itself, hence the name "Generic"
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




//Session
func getDicFunc(){
 //let basePath  = "https://api.hgbrasil.com/finance?array_limit=1&fields=only_result,USD,&key=021d0a89"
    
    let url = URL(string:"https://api.hgbrasil.com/finance?array_limit=0&fields=only_results,USD,CAD,BTC,&key=021d0a89" )!
    
    let _: Void = URLSession.shared.dataTask(with: url){
        (data, response, error) in
        
        guard let data = data else{return}
        
        do{
            
            
            let currencies = try JSONDecoder().decode(Response.self, from: data)
            
            
            print(currencies)
           

        }catch{
                print(error)

            }
   
    }.resume()

}

//
//        }
//    }
//
// let configuration:  URLSessionConfiguration = {
//
//let config = URLSessionConfiguration.default
//   // config.httpAdditionalHeaders = ["Content-Type": "application/json"]
//    return config
//    }()
//
// let session = URLSession(configuration: configuration)
//
//
//guard let url = URL(string: basePath) else {return}
//
//let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//
//
//
//    if error == nil {
//
//        guard let response = response as? HTTPURLResponse else{
//
//            return}
//        if response.statusCode == 200{
//
//
//            guard let data = data else{return}
//            do{
//
//
                //let currencies = try JSONDecoder().decode([String:Currency.results.currencies.ISO].self, from: data)

                //let jsonData = Data(jsonString.utf8)

              
                //let jsonData = Data(jsonString.utf8)
                
        
               
//dataTask.resume()

//}


getDicFunc()

var dict: Response

let jsonData = Data(jsonString.utf8)

//let JSONDecoder to decode the JSON data as DecodedArray



let decodedResult = try! JSONDecoder().decode(Response.self, from: jsonData)
print("Pela String: ")
print(  decodedResult)
print("Teste ID")
//print(decodedResult.currencies[0].currencyId as Any)





//dict =
//dump(decodedResult.array)

