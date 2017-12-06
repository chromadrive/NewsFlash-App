//
//  ArticleViewController.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import ParallaxHeader
import CoreData

class ArticleViewController: UIViewController {
    
    var URI: String?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var header: UILabel!
    @IBOutlet var details: UILabel!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var summary: UILabel!
    
    //@IBOutlet var categoryButton: UIButton!
    
    var urievent : String?
    
    var date: String?
    var category: String?
    var loc: String?
    var socialScore: String?
    var image: String?
    var articles: [String]?
    var keywords: [String]?
    
    
    
    @IBAction func sourceButtonPressed(_ sender: UIButton) {
        let title: String = (sender.titleLabel?.text)!
        let start = title.index(title.startIndex, offsetBy: 1)
        let end = title.index(title.endIndex, offsetBy: -1)
        let range = start..<end
        let mySubstring = title[range]  // play
        let index = String(mySubstring)
        let url = articles![Int(index)! - 1]
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBOutlet var favButton: UIButton!
    
    @IBAction func favButton(_ sender: Any) {
        
        
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "uri == %@", URI!)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest) as! [Article]
            if let entityToDelete = fetchedEntities.first {
                context.delete(entityToDelete)
                self.favButton.setImage(UIImage(named: "favorite_gold_sel.png"), for: .normal)
            }
            else {
                
                let article = Article(context: context)
                article.uri = URI
                article.title = header.text
                article.summary = summary.text
                article.category = category
                article.location = loc
                article.date = date
                article.socialScore = socialScore
                article.image = image
                article.articles = articles as NSObject?
                article.keywords = keywords as NSObject?
                appDel.saveContext()
                print("saved")
                self.favButton.setImage(UIImage(named: "favorite_gold.png"), for: .normal)
            }
        } catch {
            print("deleteFav error: couldn't delete")
            // Do something in response to error condition
        }
        
        do {
            try context.save()
        } catch {
            print("deleteFav error: couldn't save")
            // Do something in response to error condition
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*do {
            self.title = URI!
        } catch let loadErr {
            print("Error loading article:", loadErr)
        }*/
        favButton.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        scrollView.parallaxHeader.view = imageView
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.minimumHeight = 0
        scrollView.parallaxHeader.mode = .topFill
        
        var link : String
        var headertext : String?
        var summarytext : String?
        if let urievent = URI {
            link = "https://newsapp-backend2.herokuapp.com/event/" + urievent
        } else {
            link = "https://newsapp-backend2.herokuapp.com/event/"
        }
        
        let url = URL(string: link)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let usableData = data else { return }
            do {
                var detailstext: String = ""
                
                let json = JSON(data: usableData)
                headertext = json["event"]["title"].stringValue
                self.date = json["event"]["date"].stringValue
                self.category = json["event"]["category"].stringValue
                self.socialScore = json["event"]["socialScore"].stringValue
                self.articles =  json["event"]["articles"].arrayValue.map({$0.stringValue})
                self.keywords =  json["event"]["keywords"].arrayValue.map({$0.stringValue})
                
                if let datetext = self.date {
                    let format :String = "EEEE, MMM d yyyy"
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = format
                    
                    let Date: NSDate? = dateFormatterGet.date(from: datetext) as NSDate?
                    detailstext = dateFormatterPrint.string(from: Date! as Date)
                }
                self.loc = json["event"]["location"].stringValue
                
                summarytext = json["event"]["summary"].stringValue
                self.image = json["event"]["image"].stringValue
                let imageurl = URL(string: self.image!)
                DispatchQueue.main.async() {
                    if self.loc == "N/A" {
                        self.loc = ""
                        
                        
                        let verticalSpace = NSLayoutConstraint(item: self.details, attribute: .bottom, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1, constant: 50)
                        
                        // activate the constraints
                        NSLayoutConstraint.activate([verticalSpace])
                    }
                    self.header.text = headertext
                    self.details.text = detailstext
                    self.location.text = self.loc
                    self.summary.text = summarytext
                    self.summary.sizeToFit()
                    let screenHeight = self.view.frame.size.height + self.summary.bounds.size.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: screenHeight)
                    
                    
                    let appDel = UIApplication.shared.delegate
                        as! AppDelegate
                    let context = appDel.persistentContainer.viewContext
                    let predicate = NSPredicate(format: "uri == %@", self.URI!)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchedEntities = try context.fetch(fetchRequest) as! [Article]
                        if fetchedEntities.first != nil {
                            self.favButton.setImage(UIImage(named: "favorite_gold.png"), for: .normal)
                        }
                        
                    } catch {
                        print("couldn't find article")
                        // Do something in response to error condition
                    }
                    
                    
                    
                    
                    
                    
                    //                    var src_count : Int = 1
                    //                    var buttonX: CGFloat = 20  // our Starting Offset, could be 0
                    //                    let buttonY : Int = Int(self.summary.bounds.size.height) + 30
                    //                    for _ in self.articles! {
                    //                        let sourceButton = UIButton(frame: CGRect(x: Int(buttonX), y: buttonY, width: 30, height: 30))
                    //                        buttonX = buttonX + 30
                    //
                    //                        sourceButton.setTitle("[\(src_count)]", for: .normal)
                    //                        sourceButton.setTitleColor(.blue, for: .normal)
                    //                        sourceButton.addTarget(self, action: sourceButtonPressed(_:)), for: UIControlEvents.touchUpInside)
                    //
                    //                        self.view.addSubview(sourceButton)
                    //                        src_count += 1
                    //                    }
                    
                }
                
                DispatchQueue.global().async {
                    if imageurl != nil {
                        let imagedata = try? Data(contentsOf: imageurl!)
                        if imagedata != nil {
                            DispatchQueue.main.async {
                                self.imageView.image = UIImage(data: imagedata!)
                            }
                        }
                    }
                    
                    
                }
            }
        }
        
        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
