//
//  NewsViewController.swift
//  SmartTrade
//
//  Created by Frank Leung on 13/7/2024.
//

import UIKit
import Foundation

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tipsButton: UIButton!
    var articles: [Article] = []
    
    struct NewsResponse: Codable {
        let articles: [Article]
    }

    struct Article: Codable {
        let title: String
        let author: String?
        let description: String?
        let url: URL
        let publishedAt: String?
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.layer.cornerRadius = 15
        tableview.layer.masksToBounds = true// 隐藏超出圆角范围的内容
        
        updateNews()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsID", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let article = articles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.timeLabel.text = formatTimeInterval(from: article.publishedAt ?? "Unknown")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 处理用户选择单元格的逻辑

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;//Choose your custom row height
    }
    
    func updateNews() {
        // NewsAPI configuration
        let apiKey = "b3727b93d1274168b1db19412d1d550d"
        let type = "top-headlines"
        let category = "business"
        let country = "us"
        let pageSize = "40"

        // 构建 NewsAPI 的 URL
        let url = URL(string: "https://newsapi.org/v2/\(type)?country=\(country)&category=\(category)&pageSize=\(pageSize)&apiKey=\(apiKey)")!

        // create URLSession
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server responded with an error")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                for article in newsResponse.articles {
                    // remove the record about "https://removed.com"
                    if article.url.absoluteString != "https://removed.com" {
                        self.articles.append(article)
                    }
                }
//                showArticles for testing only
//                self.showArticles(self.articles)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        //start
        task.resume()
    }

//    func showArticles(_ articles: [Article]) {
//        for article in articles {
//            print("Title: \(article.title)")
//            print("Author: \(article.author ?? "Unknown")")
//            print("Description: \(article.description ?? "No description")")
//            print("URL: \(article.url)")
//            print("Published: \(article.publishedAt ?? "Unknown")")
//            print("---")
//        }
//        print("Total articles: \(articles.count)")
//    }

    @IBAction func tipButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Tips",
                                      message: "News comes from NewsAPI and does not represent our position. The sentiment analysis of news headlines is for reference only and does not constitute any investment advice.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I Accpet.", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //to transfrom the data format
    func formatTimeInterval(from dateString: String) -> String {
        // 創建 DateFormatter 用於解析日期字符串
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // 解析日期字符串
        guard let date = dateFormatter.date(from: dateString) else {
            return "Unknown"
        }

        // 計算現在與指定日期之間的時間差
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)

        // 根據時間差格式化輸出
        var timeString: String
        if timeInterval < 60 {
            timeString = "just now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            timeString = "\(minutes)mins ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            timeString = "\(hours)hrs ago"
        } else if timeInterval < 604800 { // 1 week = 604800 seconds
            let days = Int(timeInterval / 86400)
            timeString = "\(days)days ago"
        } else if timeInterval < 2629746 { // 1 month = 2629746 seconds (average)
            let weeks = Int(timeInterval / 604800)
            timeString = "\(weeks)wks ago"
        } else {
            let months = Int(timeInterval / 2629746)
            timeString = "\(months)mths ago"
        }

        return timeString
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
