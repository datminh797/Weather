//
//  ViewController.swift
//  Weather
//
//  Created by minhdat on 11/10/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    

    
 
    
    
}


//MARK: - WeatherManagerDelegate
extension ViewController : WeatherManagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.Temperature.text = weather.temperatureString
            self.Humidity.text = weather.humidityString
            self.CityName.text = weather.cityName
            self.weatherImage.image = UIImage(systemName: weather.getConditionName(conditionID: weather.conditionId))
        }
        
    }
    
    
}


//MARK: - UITextField Delegate
extension ViewController : UITextFieldDelegate {
    
    @IBAction func SearchLocation(_ sender: UIButton) {
        SearchTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = SearchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        SearchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Search a city !"
            return false
        }
    }
    
}

//MARK: - Core location
extension ViewController : CLLocationManagerDelegate {
    @IBAction func CurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
