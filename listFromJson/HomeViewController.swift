//
//  ViewController.swift
//  listFromJson
//
//  Created by Soufian Jghalef on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: TableController!
    var cities : [City] = [];
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableCell", for: indexPath) as! CitiesTableViewCell
        let city = cities[indexPath.row]
        
        // set name
        cell.nameLabel.text = city.name
        
        // set image
        let url = URL(string: city.image)
        
        if let unwrappedUrl = url {
            cell.cityImage.load(url: unwrappedUrl, onFinish: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        } else {
            print("No image for", city.name)
        }
        
        return cell
    }
}

class CitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
}

extension UIImageView {
    func load(url: URL, onFinish: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        onFinish()
                    }
                }
            }
        }
    }
}


