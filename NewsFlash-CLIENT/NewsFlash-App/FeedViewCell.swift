//
//  FeedViewCell.swift
//  NewsFlash-App
//
//  Created by Entei Suzuki-Minami on 12/4/17.
//  Copyright © 2017 CHROMADRIVE. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var headline: UILabel!
    @IBOutlet var date: UILabel!
    //@IBOutlet var location: UILabel!
    @IBOutlet var category: UILabel!
    var URI = ""
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnail.clipsToBounds = true;
        //thumbnail.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
