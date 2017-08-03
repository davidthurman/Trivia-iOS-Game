//
//  CategoryController.swift
//  Trivia Game
//
//  Created by David Thurman on 6/6/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import UIKit

class CategoryController: UIViewController {
    
    @IBOutlet var categoriesPicker: UIPickerView!
    @IBOutlet var categoriesScroll: UIScrollView!

    let categories = ["Any Category","General Knowledge", "Books", "Film", "Music", "Musicals and Theatres", "Television", "Video Games", "Board Games", "Science and Nature", "Computers", "Mathematics", "Mythology", "Sports", "Geography", "History", "Politics", "Art", "Celebrities", "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime and Manga", "Cartoon and Animations"]
    
    var chosenCategory = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateScroll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateScroll(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scrollHeight = categories.count * 50
        self.categoriesScroll.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
        var index = 0
        var categoryIndex = 8
        
        for category in categories {
            var categoryButton: UIButton = UIButton(frame: CGRect(x: 15, y: index, width: Int(screenWidth - 30), height: 40))
            categoryButton.setTitle(category, for: .normal)
            categoryButton.setTitleColor(UIColor.init(colorLiteralRed: 1.000, green: 1.000, blue: 1.000, alpha: 1.0), for: .normal)
            categoryButton.backgroundColor = UIColor(colorLiteralRed: 0.216, green: 0.396, blue: 0.678, alpha: 1.0)
            categoryButton.tag = categoryIndex
            categoryButton.addTarget(self, action: #selector(self.onCategorySelect(sender:)), for: .touchUpInside)
            categoryButton.layer.cornerRadius = 5
            categoriesScroll.addSubview(categoryButton)
            index = index + 60
            categoryIndex = categoryIndex + 1
            
        }
    }
    
    func onCategorySelect(sender: UIButton!){
        print("Success")
        print(sender.tag)
        chosenCategory = sender.tag
        self.performSegue(withIdentifier: "chosenCategory", sender: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        chosenCategory = 9
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "returnFromCategoryPickerSegue" || segue.identifier == "chosenCategory") {
            if let startScreenVC: StartScreen = segue.destination as? StartScreen {
                startScreenVC.category = "&category=" + String(chosenCategory)
            }
            
        }
    }
//
}
