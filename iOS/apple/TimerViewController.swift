//
//  TimerViewController.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import UIKit

class TimerViewController: UIViewController {

    var hourTag = 0
    var minuteTag = 0
    var secondTag = 0
    
    var sumTag = 0
    var labelShowTag = 0

    var displayLinkTimer:CADisplayLink? = nil
    

    lazy var timeLabel: UILabel = {
        var timeLabel = UILabel()
        timeLabel.textColor = .black
        timeLabel.backgroundColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 40)
        timeLabel.textAlignment = .center
        timeLabel.isHidden = true
        return timeLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "timer";
        
        let timePicker: UIPickerView = UIPickerView()
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        timePicker.backgroundColor = .white
        self.view.addSubview(timePicker)
        
        self.view.addSubview(self.timeLabel)
        timeLabel.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.frame = CGRect(x: 20, y: Int(timePicker.frame.maxY) + 50, width: 100, height: 40)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        cancelButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(cancelButton)
        
        let beginButton = UIButton(type: .custom)
        beginButton.setTitle("开始计时", for: .normal)
        beginButton.frame = CGRect(x: Int(self.view.bounds.width) - 120, y: Int(timePicker.frame.maxY) + 50, width: 100, height: 40)
        beginButton.addTarget(self, action: #selector(beginButtonClick), for: .touchUpInside)
        beginButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        beginButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(beginButton)
    }
    
    @objc func cancelButtonClick(button: UIButton) {
        timeLabel.isHidden = true
        cancelTimer()
        cancelTimerNoti()
    }
    
    @objc func beginButtonClick(button: UIButton) {
        sendTimerNoti(timeN: sumTag)
        displayLinkTimer = CADisplayLink(target: self, selector: #selector(handlePaletteData))
//        displayLinkTimer?.isPaused = true
        displayLinkTimer?.preferredFramesPerSecond = 1
        displayLinkTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        timeLabel.isHidden = false
        labelShowTag = sumTag
        timeLabel.text = "\(String(format: "%02d", hourTag)):\(String(format: "%02d", minuteTag)):\(String(format: "%02d", secondTag))"
    }


    @objc func handlePaletteData() {
        labelShowTag -= 1
        let hourT = labelShowTag / 3600
        let minuteT = (labelShowTag % 3600) / 60
        let secondT = labelShowTag - hourT * 3600 - minuteT * 60
        timeLabel.text = "\(String(format: "%02d", hourT)):\(String(format: "%02d", minuteT)):\(String(format: "%02d", secondT))"

        if labelShowTag < 0 {
            cancelTimer()
            timeLabel.isHidden = true
        }
    }

    deinit {
        cancelTimer()
        cancelTimerNoti()
    }
    
    func cancelTimer() {
        if displayLinkTimer != nil {
            displayLinkTimer?.invalidate()
            displayLinkTimer = nil
        }
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

extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        default:
            return 60
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return String(format: "%02d", row)
        case 1:
            return String(format: "%02d", row)
        default:
            return String(format: "%02d", row)
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hourTag = row
        case 1:
            minuteTag = row
        default:
            secondTag = row
        }
        
        sumTag = hourTag * 3600 + minuteTag * 60 + secondTag
    }
    
}

