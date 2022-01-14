//
//  FavoritesViewController.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 10/27/21.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var table: UITableView!
    
    var favorites: [fav] = []
    var images: [UIImage] = []
    
    //get data from database and append to above arrays^
    func loadDatabase() {
        let databasePath = Bundle.main.path(forResource: "favoritesDatabase", ofType: "db")
        let database = FMDatabase(path: databasePath)
        if !database.open() {
            print("Unable to open database")
            return
            
        } else {
            do {
                let results = try database.executeQuery("select * from movies", values: nil)
                
                while results.next() {
                    let id = results.int(forColumn: "id")
                    let title = results.string(forColumn: "title")
                    let img_string = results.string(forColumn: "image")
                    let language = results.string(forColumn: "lang")
                    let release = results.string(forColumn: "release")
                    let rating = results.double(forColumn: "rating")

                    //creative portion: get image from stored string data
                    let imgDecoded = Data(base64Encoded: img_string!, options: .ignoreUnknownCharacters)
                    let img = UIImage(data: imgDecoded!) ?? UIImage(named: "notfound.png")
                    
                    //creative portion: store favorited movie details for info display
                    let movie = fav(id: Int(id), title: title ?? "NA", img_string: img_string ?? "NA", og_language: language ?? "NA", release_date: release ?? "NA", vote_avg: rating)
                    
                    var exists = false
                    for item in favorites {
                        if item.id == movie.id {
                            exists = true
                            break;
                        }
                    }
                    if !exists {
                        favorites.append(movie)
                        images.append(img!)
                    }
                }
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
    
    //remove appropriate data from database
    func deleteFavorite(id: Int) {
        let databasePath = Bundle.main.path(forResource: "favoritesDatabase", ofType: "db")
        let database = FMDatabase(path: databasePath)
        if !database.open() {
            print("Unable to open database")
            return
            
        } else {
            do {
                try database.executeUpdate("delete from movies where id = ?", values: [id])
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    //set table cells to respective info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = favorites[indexPath.row].title
        cell.imageView?.image = images[indexPath.row] //creative feature: show image of favorited movie
        
        return cell
    }

    //editable cells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //delete cells and data upon delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteFavorite(id: favorites[indexPath.row].id)
            favorites.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    func setupTableView() {
        table.dataSource = self
        table.delegate = self
    }
    
    //creative portion: seque into movie info view from favorites
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fInfo" {
            let indexPaths = self.table.indexPathsForSelectedRows
            let indexPath = indexPaths![0] as IndexPath
            
            let VC = segue.destination as! MovieInfoFromFavoritesVC
            VC.movieImage = images[indexPath.row]
            VC.movie = favorites[indexPath.row]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadDatabase()
                self.table.reloadData()
            }
        }
    }
    
    //refresh favorites data everytime page appears
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadDatabase()
                self.table.reloadData()
            }
        }
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
