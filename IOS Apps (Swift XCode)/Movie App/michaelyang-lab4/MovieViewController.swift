//
//  MovieViewController.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 10/28/21.
//

import UIKit

class MovieViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var noResults: UIView!
    @IBOutlet weak var noResultsFound: UILabel!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var movieList: [Movie] = []
    var imageList: [UIImage] = []
    var searchHistory: [String] = []
    var selectedSearchHistory: String!
    let apiKey: String = "68e5bebbcb8d2198ac468d7b8330a272"
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input: String = search.text ?? "asdfa"
        var edit = ""
        var empty = true
        for c in input {
            print(c)
            if (c != " ") {
                empty = false
                break;
            }
        }
            if (!input.isEmpty && !empty) {
                edit = input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! //removes spaces from input to make it url friendly
            } else {
                edit = "asdfa"
            }
        
        let search = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(edit)" //search url with edited input and custom apikey
        
        searchHistory.append(input)
        
        noResults.isHidden = true
        //clear all existing search results
        movieList.removeAll()
        imageList.removeAll()
        collection.reloadData()
        
        //start loading activity wheel
        self.loading.isHidden = false
        self.loading.startAnimating()
        
        //get data and stop loading wheel onces data is retrieved
        DispatchQueue.global(qos: .userInitiated).async {
            self.getData(search)
            
            DispatchQueue.main.async {
                self.collection.reloadData()
                self.loading.stopAnimating()
                self.loading.isHidden = true
                
                if self.movieList.isEmpty {
                    self.noResults.isHidden = false
                }
            }
            
        }
    }
    
    //setup cell layout and datasources
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 4.5)
        
        collection.dataSource = self
        collection.delegate = self
        search.delegate = self
        collection.collectionViewLayout = layout
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mcell", for: indexPath) as! MovieCell
        
        if !imageList.isEmpty && !movieList.isEmpty {
            //set cell label to title of movie
            cell.title.text = movieList[indexPath.row].title
            //set cell image to movie image
            cell.image.image = imageList[indexPath.row]
        }
        
        return cell
    }
    
    //fetch data from link and cache images
    func getData(_ link: String) {
        let url = URL(string: link)
        let data = try! Data (contentsOf: url!)
        let apiData = try! JSONDecoder().decode(APIResults.self, from: data)
        movieList = apiData.results
        
        for movie in movieList {
            if movie.poster_path != nil {
                let combinedURL = "https://image.tmdb.org/t/p/w300" + movie.poster_path!
                let url = URL(string: combinedURL)!
                let data = try! Data(contentsOf: url)
                let image = UIImage(data: data)
                imageList.append(image!)
            } else {
                let image = UIImage(named: "notfound.jpg")
                imageList.append(image!)
            }
        }
    }
    
    //prepare data for movie info viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mInfo" {
            let indexPaths = self.collection.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            
            let infoView = segue.destination as! InfoViewController
            
            infoView.movie = movieList[indexPath.row]
            infoView.image = imageList[indexPath.row]
        }
        
        if segue.identifier == "history" {
            let VC = segue.destination as! SearchHistoryModal
            VC.history = self.searchHistory
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        loading.isHidden = true
        noResults.isHidden = true
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
