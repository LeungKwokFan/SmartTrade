//
//  DetailPositionDataViewController.swift
//  SmartTrade
//
//  Created by Frank Leung on 9/6/2024.
//

import Combine
import UIKit
import Firebase
import FirebaseFirestore
import Foundation

class DetailPositionDataViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    struct Position {
        let code: String
        var quantity: Double
        var profit: Double
    }
    
    private let db = Firestore.firestore()
    private var positions: [Position] = []
    private var stockKeys: [String] = []
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        calculateProfits()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "positionID", for: indexPath) as? PositionTableViewCell {
            let position = positions[indexPath.row]
            cell.codeLabel?.text = position.code
            cell.profitLabel?.text = "Profit: \(position.profit)"
            return cell
        } else {
            // 如果转换失败,返回一个默认的 UITableViewCell
            return UITableViewCell(style: .default, reuseIdentifier: "positionID")
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            let stock = holdings[indexPath.row]
        //            // 跳转到股票详情页面
        //            showStockDetails(for: stock)
    }
    
    private func getHoldingData(completion: @escaping ([String: (Double,Double)]) -> Void) {
        
        let db = Firestore.firestore()
        let email = Auth.auth().currentUser?.email
        var stockHoldings: [String: (Double,Double)] = [:] //the position
        
        db.collection("Holdings").document(email!).getDocument { (document, error) in
            if let document = document, document.exists {
                var holdings = document.data()?["holdings"] as? [[String: Any]] ?? []
                for holding in holdings {
                    if let stockCode = holding["stockCode"] as? String, let shares = holding["shares"] as? Double ,let avgCost = holding["avgCost"] as? Double{
                        stockHoldings[stockCode] = (shares,avgCost)
                        
                    }
                }
                completion(stockHoldings)
            } else {
                completion([:])
            }
        }
    }
    
    private func calculateProfits() {
        getHoldingData { holdingData in
            let apiService = APIService()
            let publishers = holdingData.keys.map { apiService.fetchSymbolsPublisher(symbol: $0) }
            //            var stockValues: [String: Double] = [:]
            self.stockKeys = Array(holdingData.keys)
            
            DispatchQueue.main.async {
                
                print(self.stockKeys)
                let publishers = self.stockKeys.map { apiService.fetchSymbolsPublisher(symbol: $0) }
                
                Publishers.MergeMany(publishers)
                    .map { data -> SearchResult? in
                        if let searchResults = try? JSONDecoder().decode(SearchResults.self, from: data) {
                            return searchResults.globalQuote
                        }
                        return nil
                    }
                    .collect()
                    .receive(on: RunLoop.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                    } receiveValue: { searchResults in
                        self.searchResults = searchResults.compactMap { $0 }
                        
                        for (symbol, (shares,avgCost)) in holdingData {
                            if let searchResult = self.searchResults.first(where: { $0.symbol == symbol }) {
                                let currentPrice = Double(searchResult.price ?? "0") ?? 0
                                let position = Position(code: symbol, quantity: shares, profit: (round(((currentPrice-avgCost)*shares)*100)/100))
                                self.positions.append(position)
                            }
                        }
                        print(self.positions)
                        self.tableView.reloadData()
                        
                    }
                .store(in: &self.subscribers)
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

