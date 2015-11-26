//
//  NetflixRestManager.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import Foundation

class NetflixRestManager {
    static let sharedManager = NetflixRestManager()
    let mainEndPoint = "http://netflixroulette.net/api/api.php?"
    
    private func makeRestCall(endpoint: String, closure: (request: NSURLRequest?, response: NSURLResponse?, data: NSData?, error: ErrorType?) -> Void) {
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1
        let session = NSURLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        let url : String = "\(self.mainEndPoint)\(endpoint)"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            closure(request: request, response: response, data: data, error: error)
        }
        task.resume()
    }
    
    func getMoviesByActor(actor: String, closure: (movies: NSArray) -> Void) {
        var movies = NSArray()
        let escapedActor = actor.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        makeRestCall("actor=\(escapedActor!)") { (request, response, data, error) -> Void in
            if let responseData = data {
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(rawValue: 0))
                    if let array = dict as? NSArray {
                        for movie in array {
                            movies = movies.arrayByAddingObject(Movie(JSON: movie as! NSDictionary))
                        }
                        // Sort movies by release year
                        movies = movies.sort({ (movie1, movie2) -> Bool in
                            if let first = movie1 as? Movie {
                                if let second = movie2 as? Movie {
                                    return first.releaseYear > second.releaseYear
                                }
                            }
                            return false
                        })
                        
                        closure(movies: movies)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}
