//
//  TradeHistoryViewController.swift
//  SmartTrade
//
//  Created by Frank Leung on 25/6/2024.
//


import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import DGCharts

class TradeHistoryViewController: UIViewController {
    
    
    var stockSymbol: String?
    var stockData: [TradeOrder] = []
    private var barChartView: BarChartView!

    
    
    struct TradeOrder: Codable {
        let symbol: String
        let quantity: Double
        let timestamp: Timestamp
        let email: String
        let type: String
    }
    
    let segmentedControl = UISegmentedControl(items: ["Buy", "Sell"])
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentedControl()
        
        
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    //setting the segmented controller
    private func setupSegmentedControl() {
            segmentedControl.selectedSegmentIndex = 0
            view.addSubview(segmentedControl)
            
            // add constraint
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            
            // set style
            segmentedControl.backgroundColor = .black
            segmentedControl.selectedSegmentTintColor = .systemGreen
            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            segmentedControl.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.white], for: .normal)
            segmentedControl.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.white], for: .selected)
            
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            // 处理选中选项变化的逻辑
            switch sender.selectedSegmentIndex {
            case 0:
                setBarChartBuy()
            case 1:
                setBarChartSell()
                print("1")
            default:
                break
            }
        }
    
    
    //----------------------------------- sell ----------------------------------
    private func setBarChartSell(){
        
    }
    
    
    //----------------------------------- buy ----------------------------------
    private func setBarChartBuy(){
        
    }
    
    
    
    private func setDefault(){
        print(stockSymbol)
        let db = Firestore.firestore()
        let email = Auth.auth().currentUser?.email
        
        
        
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
