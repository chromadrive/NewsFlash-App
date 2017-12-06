//
//  CategorySelectorViewController.swift
//  
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//

import UIKit

class CategorySelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var categorySelectorTable: UITableView!
    let categoriesList = ["Arts", "Business", "Computers", "Games", "Health", "Home", "Recreation", "Reference", "Science", "Shopping", "Society", "Sports"]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorySelectorTable.delegate = self
        categorySelectorTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorySelectorCell", for: indexPath) as! CategorySelectorViewCell
        let i = indexPath.row
        cell.category.text = categoriesList[i]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showCategorySearch", sender: categorySelectorTable)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CategorySearchViewController {
            dest.category = categoriesList[(selectedIndexPath?.row)!]
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
