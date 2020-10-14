//
//  ViewController.swift
//  Movie App
//
//  Created by Denis Osmanovic on 10/9/20.
//  Copyright © 2020 Denis Osmanovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var field: UITextField!
    
    
    var movies = [Movie]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
    }
    
    //TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies(){
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else{
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(query)&page=1")!, completionHandler: {data, response, error in
            
                guard let data = data, error == nil else {
                    return
                }
            
            var result: MovieResult?
            do
            {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch
            {
             print("Error")
            }
            
            guard let finalResult = result else {
                return
            }
            
            let newMovies = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
            
            }).resume()
        
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

struct MovieResult: Codable {
    let results: [Movie]
    
}

struct Movie: Codable{
    
    let title: String
    let release_date: String
    let overview: String
    let poster_path: String
    
    private enum CodingKeys: String, CodingKey {
        case title, release_date, overview, poster_path
    }
}
