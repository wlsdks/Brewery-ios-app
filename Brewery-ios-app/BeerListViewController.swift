//
//  BeerListViewController.swift
//  Brewery-ios-app
//
//  Created by 최진안 on 2023/05/17.
//

import UIKit

class BeerListViewController: UITableViewController {

    
    var beerList = [Beer]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar설정
        title = "브루어리 앱"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150 //높이설정
    }
    
    
    
}

// UITableView DataSource, Delegate
extension BeerListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        
        // 맥주값을 가져와서 configure에 넣어준다.
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    
    
}
