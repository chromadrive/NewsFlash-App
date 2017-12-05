//
//  FeedTableViewController.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/4/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit
import SDWebImage

class FeedTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var feedTable: UITableView!
    var feedItems = [FeedItem]()
    
    struct FeedItem {
        let title: String
        let date: String
        let location: String
        let imageURL: String
        let category: String
        let URI: String
        
        init(json: [String: Any]) {
            title = json["title"]  as? String ?? "Error"
            date = json["date"] as? String ?? "Error"
            location = json["location"] as? String ?? "Error"
            category = json["category"] as? String ?? "Error"
            imageURL = json["image"] as? String ?? ""
            URI = json["URI"] as? String ?? "Error"
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let feedURL = URL(string: "https://newsapp-backend2.herokuapp.com/cache/feed/") else {return}
        URLSession.shared.dataTask(with: feedURL) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:NSArray]
                guard let jsonEvents = json["events"] else { return }
                //print(jsonEvents![2])
                self.parseJsonEvents(list: jsonEvents)
            } catch let jsonErr {
                print("Error serializing JSON:", jsonErr)
            }
            DispatchQueue.main.async {
                self.feedTable.reloadData()
            }
        }.resume()
        
        feedTable.delegate = self
        feedTable.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedViewCell
        let i = indexPath.row
        cell.headline.text = feedItems[i].title
        //cell.location.text = feedItems[i].location
        cell.date.text = feedItems[i].date
        cell.category.text = feedItems[i].category
        //cell.thumbnail.image = feedImages[i]
        /*
        DispatchQueue.main.async {
            let url = URL(string: self.feedItems[i].imageURL)
            if url != nil {
                let imgData = try? Data(contentsOf: url!)
                if imgData != nil{
                    cell.thumbnail.image = UIImage(data: imgData!)
                }
                else{
                    cell.thumbnail.image = UIImage(data: self.imgDataPlaceholder!)
                }
            } else {
                cell.thumbnail.image = UIImage(data: self.imgDataPlaceholder!)
            }
        }*/
        
        //cell.thumbnail.sd_setImage(with: URL(string: feedItems[i].imageURL), placeholderImage: UIImage(named: "thumb_placeholder.png"))
        cell.thumbnail.sd_setImage(with: URL(string: feedItems[i].imageURL), placeholderImage: nil)

        cell.URI = feedItems[i].URI
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showArticleSegue", sender: feedTable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ArticleViewController {
            dest.URI = feedItems[(selectedIndexPath?.row)!].URI
        }
    }
    
    func parseJsonEvents(list: NSArray){
        for i in 0...(list.count - 1) {
            if let event = list[i] as? [String:Any] {
                let eventStruct = FeedItem(json: event)
                feedItems.append(eventStruct)
            }
        }
    }
    
//    func downloadImages() {
//        let urlPlaceholder = URL(string: "https://via.placeholder.com/200x200")
//        let imgDataPlaceholder = try? Data(contentsOf: urlPlaceholder!)
//        for i in 0...(feedItems.count - 1) {
//            print(feedItems[i].imageURL)
//            let url = URL(string: feedItems[i].imageURL)
//            if url != nil {
//                let imgData = try? Data(contentsOf: url!)
//                if imgData != nil{
//                    feedImages.append(UIImage(data: imgData!)!)
//                }
//                else{
//                    feedImages.append(UIImage(data: imgDataPlaceholder!)!)
//                }
//            } else {
//                feedImages.append(UIImage(data: imgDataPlaceholder!)!)
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
