//
//  Api.swift
//  listFromJson
//
//  Created by Soufian Jghalef on 23/06/23.
//

import Foundation

struct CitiesApiResponse: Codable {
    var cities: [City]
}

class ApiClient {
    let url = URL(string:"https://dev-69151fz3iy9d189.api.raw-labs.com/mock?endpoint=cities");
    
    var cities : [City] = [];
    
    func fetchCities(completion: @escaping () -> ()) {
        guard let url = url else {return};
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Sorry, we got this error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                print("Invalid response")
                return
            }
            
            if let data = data,
               let citiesResponse = try? JSONDecoder().decode(CitiesApiResponse.self, from: data) {
                self.cities = citiesResponse.cities
                completion()
            }
            
        }
        task.resume()
    }
}

