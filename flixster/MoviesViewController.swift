//
//  MoviesViewController.swift
//  flixster
//
//  Created by Fabian Jujescu on 9/27/20.
//  Copyright © 2020 jujescufabian@gmail.com. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    // properities here for lifetime of that screen
    var movies = [[String:Any]]() // array of dictionaries
    // special function that is run first time screen comes up
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] // when thing has fetched data back it will provide it inthe data dictionary
            
            //download of movies is complete
            self.movies = dataDictionary["results"] as! [[String:Any]]// access particular key inside of dictionary and use casting
            
            self.tableView.reloadData() // has it call these functions two functions again
            
            print(dataDictionary)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    // functions aren't called continously thus movie count is 0 and nothing is called. We must tell the functions to update.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // create a new recycled cell because you can only see a number of cells at a time.
        
        let movie = movies[indexPath.row] // access array movie of each index
        let title = movie["title"] as! String // access title of movie by some key. Casting tells you what is the type
        let synopsis = movie["overview"] as! String // make synopsis variable that access array of movie types and access overview element from API
        
        cell.titleLabel.text = title // connect title to each cell from storyboard
        cell.synopsisLabel.text = synopsis // connect synopsis variable to each cell
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseUrl + posterPath)! // baseUrl differentiates and lets swift know its a url and not just a normal string
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        
        return cell
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
