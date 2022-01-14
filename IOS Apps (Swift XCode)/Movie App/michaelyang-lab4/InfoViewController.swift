//
//  InfoViewController.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 10/28/21.
//

import UIKit
import SQLite3

class InfoViewController: UIViewController {
    
    var movie: Movie!
    var image: UIImage!
    
    @IBOutlet weak var infoImage: UIImageView!

    @IBOutlet weak var infoRating: UILabel!
    @IBOutlet weak var infoRelease: UILabel!
    @IBOutlet weak var infoLang: UILabel!
    
    @IBOutlet weak var infoTitle: UINavigationItem!
    
    @IBOutlet weak var addFavorites: UIButton!
    
    func updateInfo() {
        
        infoImage.image = image
        infoTitle.title = movie.title
        let rating = String(movie.vote_average) + "/10"
        infoRating.text = rating
        infoRelease.text = movie.release_date
        infoLang.text = movie.original_language
    }
    
    //add a movie and its data into favorites database
    @IBAction func addToFavorites(_ sender: Any) {
        let databasePath = Bundle.main.path(forResource: "favoritesDatabase", ofType: "db")
        let database = FMDatabase(path: databasePath)
        if !database.open() {
            print("Unable to open database")
            return
        } else {
            do {
                //creative portion: storing image and other movie data locally
                let imageData = image.pngData()
                let imageToString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? "NA"
                
                //creative portion: store favorited movie details (besides just title) for info display
                try database.executeUpdate("insert into movies (id, title, image, lang, release, rating) values (?, ?, ?, ?, ?, ?)", values: [movie.id!, movie.title, imageToString, movie.original_language ?? "NA", movie.release_date ?? "NA", movie.vote_average])
                
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
        // Do any additional setup after loading the view.
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
