//
//  CurrenciesServices.swift
//  DesafioItau
//
//  Created by Andre Vitorino on 17/01/22.
//

import Foundation

// Tratamento de exceções
enum currencyError{
    case url
    case taskError( error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
    
}

class CurrenciesServices{

    
    private static let basePath  = "https://api.hgbrasil.com/finance?array_limit=0&fields=only_results,USD,BTC,EUR,&key=021d0a89"
        
    private static let configuration:  URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
       // config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return config
        }()
    
    private static let session = URLSession(configuration: configuration)

    
    class func getCurrencies(onComplete: @escaping ([Response.Currency]) -> Void, onError: @escaping (currencyError) -> Void){
        guard let url = URL(string: basePath) else {
            onError(.url)
            return}
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else{
                    onError(.noResponse)
                    return}
                if response.statusCode == 200{
                    
                 
                 guard let data = data else{return}
                    do{
                        let currencies = try! JSONDecoder().decode(Response.self, from: data)
                        onComplete(currencies.currencies)
                        

                    }catch{
                            print(error)
                        onError(.invalidJSON)
                        }
                }else{
                    print("Invalid status")
                    onError(.responseStatusCode(code: response.statusCode))
                }
                
            }else{
             
                onError(.taskError(error: error!))
            }
            
        }
        dataTask.resume()
        
    }
    

            
        }

        
        
    
    
    
   

