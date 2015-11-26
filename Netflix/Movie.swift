//
//  Movie.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import Foundation

class Movie {
    internal var title:String
    internal var releaseYear:Int
    internal var rating:Int
    internal var category:String
    internal var runtime:String
    internal var summary:String
    internal var cast:String
    internal var director:String
    internal var poster:String
    
    //Parse the JSON to a Movie object
    init (JSON:NSDictionary) {
        self.title = JSON.getStringValueFromJSON("show_title")
        self.releaseYear = JSON.getIntValueFromJSON("release_year")
        self.rating = JSON.getIntValueFromJSON("rating")
        self.category = JSON.getStringValueFromJSON("category")
        self.runtime = JSON.getStringValueFromJSON("runtime")
        self.summary = JSON.getStringValueFromJSON("summary")
        self.cast = JSON.getStringValueFromJSON("show_cast")
        self.director = JSON.getStringValueFromJSON("director")
        self.poster = JSON.getStringValueFromJSON("poster")
    }
}