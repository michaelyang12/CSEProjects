//
//  ViewController.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 10/25/21.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    
    struct APIResults: Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String?
        let vote_average: Double
        let overview: String
        let vote_count: Int!
    }
    
    var movieList: [Movie] = []
    var imageList: [UIImage] = []
    let apiKey: String = "68e5bebbcb8d2198ac468d7b8330a272"
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input: String? = search.text
        let edit = input?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print("clicked")
        //let search = "https://www.themoviedb.org/search?query=\(input!)"
        let search = "https://api.themoviedb.org/3/movie/550?api_key=68e5bebbcb8d2198ac468d7b8330a272"

        collection.reloadData()
        
        movieList.removeAll()
        imageList.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchData(search)
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    func setupCollectionView() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        if (!imageList.isEmpty && !movieList.isEmpty) {
            //set cell image to movie image
            cell.image.image = imageList[indexPath.row]
            //Set cell label to movie title
            cell.title.text = movieList[indexPath.row].title
        }
        
        return cell
    }
    
    func fetchData(_ link: String) {
        let url = URL(string: link)
        let data = try! Data (contentsOf: url!)
        let apiData = try! JSONDecoder().decode(Movie.self, from: data)
        movieList.append(apiData)
//        movieList = try! JSONDecoder().decode([Int: Movie].self, from: data)
//        print(movieList[0].title)
    }
    
    func cacheImages() {
        for movie in movieList {
            let url = URL(string: movie.poster_path!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            imageList.append(image!)
        }
    }
    
//    //Segue And Load Appropriate Info for Individual Movies
//    func collectionView(_ collectionView:
//        UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         self.performSegue(withIdentifier: "showMovieInfo", sender: self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchData("https://api.themoviedb.org/3/movie/550?api_key=68e5bebbcb8d2198ac468d7b8330a272")
        cacheImages()
    }
    
    

}

