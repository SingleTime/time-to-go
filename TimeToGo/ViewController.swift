//
//  ViewController.swift
//  TimeToGo
//
//  Created by 姜辽 on 2019/12/18.
//  Copyright © 2019 姜辽. All rights reserved.
//

import UIKit
import SearchTextField


class ViewController: UIViewController {

    @IBOutlet weak var location:  SearchTextField!
    @IBOutlet weak var travelType: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
//    var gaodeKey: String = "8f354cde282534ac501c3bc5d6618c3e"
    
    @IBOutlet weak var timeField: SearchTextField!
    @IBOutlet weak var typpe: UISegmentedControl!
    @IBOutlet weak var timeSelector: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        location.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .allEditingEvents  )
        location.returnKeyType = UIReturnKeyType.done

        addButton.addTarget(self, action: #selector(addClick(sender:)), for: .touchUpInside)
        timeField.addTarget(self, action: #selector(timeFieldSelected(sender:)), for: .touchDown)
         timeSelector.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        location.startVisibleWithoutInteraction = true
        // Set the array of strings you want to suggest
        location.filterStrings(["Red", "Blue", "Yellow"])
        location.placeholder = "select your color"
        timeSelector.isHidden = true
        
        
    }
    
    //日期选择器响应方法
    @objc  func dateChanged(datePicker : UIDatePicker){
           //更新提醒时间文本框
           let formatter = DateFormatter()
           //日期样式
           formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
           print(formatter.string(from: datePicker.date))
            timeField.value(forKey: formatter.string(from: datePicker.date))
       }
        
    
    @objc func textFieldDidChange(sender: UITextField){
       print("textFieldDidChange is called")
    let item1 = SearchTextFieldItem(title: "Blue", subtitle: "Color", image: UIImage(named: "icon_blue"))
           let item2 = SearchTextFieldItem(title: "Red", subtitle: "Color", image: UIImage(named: "icon_red"))
           let item3 = SearchTextFieldItem(title: "Yellow", subtitle: "Color", image: UIImage(named: "icon_yellow"))
           location.filterItems([item1, item2, item3])
       print(sender.text ?? "")
    }
    
    @objc func addClick(sender: UIButton){
       print("addButton is called")
        print("travel index \(travelType.selectedSegmentIndex)")
       self.showToast(message: "This is a piece of toast", controller:  self)

//       print(sender.text ?? "")
    }
     @objc func timeFieldSelected(sender: SearchTextField){
           print("SearchTextField is called")
            print("travel index \(travelType.selectedSegmentIndex)")
        sender.resignFirstResponder()
        sender.isUserInteractionEnabled = false
        timeSelector.isHidden = false

    //       print(sender.text ?? "")
    }
    
    func getRequest(url: String) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
    }
}
extension UIViewController {

func showToast(message: String, controller: UIViewController) {
    let toastContainer = UIView(frame: CGRect())
    toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastContainer.alpha = 0.0
    toastContainer.layer.cornerRadius = 25;
    toastContainer.clipsToBounds  =  true

    let toastLabel = UILabel(frame: CGRect())
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font.withSize(12.0)
    toastLabel.text = message
    toastLabel.clipsToBounds  =  true
    toastLabel.numberOfLines = 0

    toastContainer.addSubview(toastLabel)
    controller.view.addSubview(toastContainer)

    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    toastContainer.translatesAutoresizingMaskIntoConstraints = false

    let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
    let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
    let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
    let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
    toastContainer.addConstraints([a1, a2, a3, a4])

    let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
    let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
    let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
    controller.view.addConstraints([c1, c2, c3])

    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
        toastContainer.alpha = 1.0
    }, completion: { _ in
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
            toastContainer.alpha = 0.0
        }, completion: {_ in
            toastContainer.removeFromSuperview()
        })
    })
}
    
}
