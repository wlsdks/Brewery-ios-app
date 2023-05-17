//
//  BeerListViewController.swift
//  Brewery-ios-app
//
//  Created by 최진안 on 2023/05/17.
//

import UIKit

class BeerListViewController: UITableViewController {

    
    var beerList = [Beer]()
    var currentPage = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar설정
        title = "브루어리 앱"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150 //높이설정
        
        fetchBeer(of: currentPage)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
}

//Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode {
            case (200...299): //성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): //클라이언트 에러
                print("""
                      ERROR: Client ERROR \(response.statusCode)
                      Response: \(response)
                      """)
            case (500...599): //서버 에러
                print("""
                      ERROR: Server ERROR \(response.statusCode)
                      Response: \(response)
                      """)
            default:
                print("""
                      ERROR: \(response.statusCode)
                      Response: \(response)
                      """)
                
            }
        }
        dataTask.resume() //반드시 resume을 해줘야 한다.
    }
}
