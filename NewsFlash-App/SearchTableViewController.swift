//
//  SearchTableViewController.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet var searchTable: UITableView!
    var selectedIndexPath: IndexPath?
    let resultSearchController = UISearchController()

    
    var eventSearchResults = [FeedItem]()
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
            imageURL = json["image"] as? String ?? "https://via.placeholder.com/400x400"
            URI = json["URI"] as? String ?? "Error"
        }
    }
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.delegate = self
        searchTable.dataSource = self
        resultSearchController.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTable.dequeueReusableCell(withIdentifier: "keywordSearchCell", for: indexPath) as! FeedViewCell
        let i = indexPath.row
        cell.headline.text = eventSearchResults[i].title
        cell.date.text = eventSearchResults[i].date
        cell.category.text = eventSearchResults[i].category
        cell.thumbnail.sd_setImage(with: URL(string: eventSearchResults[i].imageURL), placeholderImage: nil)
        
        cell.URI = eventSearchResults[i].URI
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        //performSegue(withIdentifier: "ShowArticleSegue", sender: feedTable)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let dest = segue.destination as? ArticleViewController {
            dest.URI = feedItems[(selectedIndexPath?.row)!].URI
         }
     }
     */
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        if keywords != "" {
            eventSearchResults = [FeedItem]()
            performSearch(keywords!)
        }
        self.searchTable.reloadData()
        self.view.endEditing(true)
    }
    
    func performSearch(_ search: String) {
        guard let feedURL = URL(string: "https://newsapp-backend2.herokuapp.com/cache/search/keyword/" + search) else {return}
        print(feedURL)
        URLSession.shared.dataTask(with: feedURL) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                guard let jsonEvents = json["events"] else { return }
                self.parseJsonEvents(list: jsonEvents as! NSArray)
            } catch let jsonErr {
                print("Error serializing JSON:", jsonErr)
            }
            print(self.eventSearchResults.count)
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }.resume()
    }
    
    func parseJsonEvents(list: NSArray){
        for i in 0...(list.count - 1) {
            if let event = list[i] as? [String:Any] {
                let eventStruct = FeedItem(json: event)
                eventSearchResults.append(eventStruct)
            }
        }
    }


}
