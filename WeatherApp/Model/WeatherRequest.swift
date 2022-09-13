//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by APPLE on 31.07.22.
//

import Foundation

struct WeatherRequest : Codable {
    var list : [WeatherData]
    var city : City
}

struct WeatherData : Codable {
    var main : Main
    var weather :[Weather]
    var wind : Wind
    var sys : Sys
    var dt_txt : String
}

struct City : Codable {
    var name : String
    var country : String
}

struct Main : Codable {
    var temp : Double
    var humidity : Int
    var pressure: Int
    var sea_level :Int

}

struct Weather : Codable {
    var description : String
    var id : Int
    var icon : String

}

struct Wind : Codable {
    var speed : Double
}

struct Sys : Codable {
    var pod : String
}
