//
//  ArticleViewController.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var URI: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            self.title = URI!
        } catch let loadErr {
            print("Error loading article:", loadErr)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
