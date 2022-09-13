//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by APPLE on 01.08.22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherRequest)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
    var weatherManagerdelegate : WeatherManagerDelegate?
    
    var myArray = [WeatherData]()
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=7ee4f99d043d4acde71d75d7578ff278&units=metric"
    let cityNameURL = "https://api.openweathermap.org/data/2.5/forecast?appid=7ee4f99d043d4acde71d75d7578ff278&units=metric&"
    
    func fetchWeather(cityname: String) {
        let urlString = "\(cityNameURL)q=\(cityname)"
        getDataFromWeb(urlString: urlString)
        print(#function)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        getDataFromWeb(urlString: urlString)
    }
    
    func getDataFromWeb(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task =  session.dataTask(with: url) {(data,response,error) in
                if error != nil {
                    self.weatherManagerdelegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherRequest: safeData){
                        self.myArray = weather.list
                        print(weather.city.name)
                        DispatchQueue.main.async { [self] in
                            self.weatherManagerdelegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
        print(#function)
    }
    func parseJSON(weatherRequest: Data) -> WeatherRequest?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherRequest.self, from: weatherRequest)
            let arrayList = decodedData.list
            let city = decodedData.city
            var weatherOBJ = WeatherRequest(list: arrayList, city: city)
            return weatherOBJ
        }
        catch {
            weatherManagerdelegate?.didFailWithError(error: error)
            return nil
        }
    }
}

