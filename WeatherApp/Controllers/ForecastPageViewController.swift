//
//  ForecastPageViewController.swift
//  WeatherApp
//
//  Created by APPLE on 06.08.22.
//

import UIKit

class ForecastPageViewController: UIViewController {
    
    @IBOutlet weak var forecastPageTableView: UITableView!
    var weatherDelegate = WeatherManager()
    var forecastArray = [WeatherData]()
    var icon = TodayWeatherViewController()
    var sections  = [Date]()
    var groupByID = [Int:[WeatherData]]()
    var arr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func substringTime(timeString : String) -> String{
        let index = timeString.firstIndex(of: " ")!
        let time = timeString.substring(from: index)
        print(time)
        var newStr : String = ""
            for i in time {
                newStr += String(i)
                if newStr.count == 6 {
                    break
                }

        }
        return newStr

    }
}

extension ForecastPageViewController : UITableViewDelegate,UITableViewDataSource {
//      ეს მაქვს გასასწორებელი 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        let item = forecastArray[indexPath.row]
        cell.timeLabel.text = substringTime(timeString: item.dt_txt)
        cell.temperatureLabel.text = String(item.main.temp)+"°"
        cell.forecastDescriptionLabel.text = item.weather[0].description
        cell.forecastImageview.imageFromWeb(urlString: "https://openweathermap.org/img/wn/\(item.weather[0].icon)@2x.png", placeHolderImage: UIImage())
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections =  datesRange(from: Date(), to: Calendar.current.date(byAdding: .day, value: 4, to: Date())!)
        print( "seqciebis raodenoba \(sections.count)")
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 20))
        header.addSubview(label)
        header.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        let str = dateToString(date: sections[section])
        print("STR\(str)")
        label.text = Getweekday(dateString: str)
     print(Getweekday(dateString: str))
        return header
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)

    }
    func Getweekday (dateString : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE"
        let date = dateFormatterGet.date(from: dateString)
        let dateToString = dateFormatterPrint.string(from: date!)
        return dateToString
    }
    
    func getTodayWeekDay(date: Date)-> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let weekDay = dateFormatter.string(from: Date())
            return weekDay
      }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func groupingArray(array: [WeatherData]) {
        groupByID = Dictionary(grouping: forecastArray) { $0.weather[0].id}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Section Title \(section)"
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
    if from > to { return [Date]() }
    var tempDate = from
    var array = [tempDate]
    while tempDate < to {
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }
    return array
}
}
