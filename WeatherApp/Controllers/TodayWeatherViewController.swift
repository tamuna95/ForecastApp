//
//  TodayWeatherViewController.swift
//  WeatherApp
//
//  Created by APPLE on 30.07.22.
//

import UIKit
import CoreLocation

class TodayWeatherViewController: UIViewController {
    
    @IBOutlet weak var compassLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var mainLocationLabel: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var windlLabel: UILabel!
    @IBOutlet weak var enterCityNameTextField: UITextField!
    @IBOutlet weak var searchButtonLabel: UIButton!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var forecastArray = [WeatherData]()
    var icon : String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLocationLabel.titleLabel?.isHidden = true
        enterCityNameTextField.delegate = self
        weatherManager.weatherManagerdelegate = self
        locationManager.delegate = self
        enterCityNameTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //    Forecast Page
    @IBAction func showForecastPage(_ sender: Any) {
        performSegue(withIdentifier: "forecastSegue", sender: nil)
        forecastArray = weatherManager.myArray
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue" {
            let vc = segue.destination as! ForecastPageViewController
            vc.forecastArray = weatherManager.myArray
        }
    }
    @IBAction func mainLocationDisplay(_ sender: UIButton) {
        locationManager.requestLocation()
    }
//ქალაქის სახელის მიხედვით გამოიტანოს ამინდის პროგნოზი
    @IBAction func searchButton(_ sender: UIButton) {
//endEditing - ჩაწერა დასრულდა და ქიბორდი გაქრეს ეკრანიდან
        textFieldDidEndEditing(enterCityNameTextField)
        enterCityNameTextField.endEditing(true)
        print(#function)
    }
    
}

extension TodayWeatherViewController : UITextFieldDelegate {
    
//    return button pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //qიბორდი რომ თავისით გაითიშოს როცა იუზერი ქალაქს შეიყვანს და მოძებნის
        enterCityNameTextField.endEditing(true)
        print(enterCityNameTextField.text!)
        return true
    }
    //    როცა ტექსტ ფილდი ცარიელი იქნება და ისე აწვება ღილაკს მაშინ გამოჩნდეს ფლეისჰოლდერში ტექსტი
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if enterCityNameTextField.text != "" {
            return true
        } else {
            enterCityNameTextField.placeholder = "Type a city name"
            return false
            
        }
    }
    //    როცა დაასრულებს ჩაწერას და ღილაკს დააწვება, ტექსტ ფილდი გასუფთავდეს
    func textFieldDidEndEditing(_ textField: UITextField) {
                if let city = enterCityNameTextField.text {
                    weatherManager.fetchWeather(cityname: city)
        }
                enterCityNameTextField.text = ""
//        if enterCityNameTextField.text != nil {
//            enterCityNameTextField.text = " "
//        }
    }
    
    
}
//MARK:- Update Weather

extension TodayWeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherRequest){
        DispatchQueue.main.async { [self] in
            for i in weather.list {
                degreeLabel.text = String(i.main.temp)+"°"
                windlLabel.text = String(i.wind.speed)+"km/h"
                humidityLabel.text = String(i.main.humidity)+"%"
                pressureLabel.text = String(i.main.pressure)+"hPa"
                descriptionLabel.text = i.weather[0].description
                compassLabel.text = i.sys.pod
                seaLevelLabel.text = String(i.main.sea_level)
                icon = i.weather[0].icon
                weatherImage.imageFromWeb(urlString: "https://openweathermap.org/img/wn/\(icon)@2x.png", placeHolderImage: UIImage())
            }
            cityLabel.text = weather.city.name+","
            countryLabel.text = weather.city.country
            print(#function)
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK:- CLLocationManagerDelegate

extension TodayWeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

