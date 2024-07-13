//
//  NewsDetailedViewController.swift
//  SmartTrade
//
//  Created by Frank Leung on 13/7/2024.
//

import UIKit
import WebKit
import Foundation


class NewsDetailedViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var testButton: UIButton!
    var articleURL: URL?
    var articleTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webview.layer.cornerRadius = 15
        guard let url = articleURL else {
            return
        }
        let request = URLRequest(url: url)
        webview.load(request)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {

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
