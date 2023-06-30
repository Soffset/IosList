//
//  ViewController.swift
//  listFromJson
//
//  Created by Soufian Jghalef on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: TableController!
    var cities = ["Loading"];
    let apiClient = ApiClient();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        apiClient.fetchCities {
            print("Completed Fetch:", self.apiClient.cities)
            self.cities = self.apiClient.cities
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
}



