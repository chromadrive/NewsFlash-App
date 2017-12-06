//
//  StarredTableViewController.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit

class StarredTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var articles: [Article] = []
    var selectedIndexPath: IndexPath?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FeedViewCell
            
        // Configure the cell...
        let i = indexPath.row
        cell.headline.text = articles[i].title
        cell.date.text = articles[i].date
        cell.category.text = articles[i].category
        cell.thumbnail.sd_setImage(with: URL(string: articles[i].image!), placeholderImage: nil)
        cell.URI = articles[i].uri!
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do {
            articles = try context.fetch(Article.fetchRequest())
            print(articles.count)
        }
        catch {
            print("Fetch failed")
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do {
            articles = try context.fetch(Article.fetchRequest())
            
        }
        catch {
            print("Fetch failed")
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showArticleSegue", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ArticleViewController {
            dest.URI = articles[(selectedIndexPath?.row)!].uri
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
