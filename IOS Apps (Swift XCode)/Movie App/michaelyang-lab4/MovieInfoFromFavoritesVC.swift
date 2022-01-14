//
//  MovieInfoFromFavoritesVC.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 11/1/21.
//

import UIKit

class MovieInfoFromFavoritesVC: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var movie: fav!
    var movieImage: UIImage!
    
    func updateInfo() {
        image.image = movieImage
        navBar.title = movie.title
        releaseLabel.text = movie.release_date
        ratingLabel.text = String(movie.vote_avg) + "/10"
        langLabel.text = movie.og_language
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
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
