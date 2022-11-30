//
//  AddAlarmViewController.swift
//  apple
//
//  Created by zqy on 2022/11/11.
//

import UIKit

class AddAlarmViewController: UIViewController {

    lazy var titleTextField: UITextField = {
        let titleTextField = UITextField(frame: CGRect(x: 20, y: 300, width: self.view.frame.width - 40, height: 40))
        titleTextField.placeholder = "请输入闹铃标题"
        titleTextField.borderStyle = .line
        return titleTextField
    }()
        
    lazy var weekArray : [String] = {
        return []
    }()
    
    var sendDataClosure: ((AlarmModel) ->Void)?

        
    var alarmModel: AlarmModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        addNaviItem()
        
        let timePicker: UIDatePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        self.view.addSubview(timePicker)
        timePicker.locale = NSLocale.current
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        
        self.view.addSubview(self.titleTextField)

        self.titleTextField.delegate = self

        if (alarmModel != nil) {
            self.titleTextField.text = alarmModel!.titleStr
            timePicker.date = getCurrentDate(timeStr: alarmModel!.timeStr)
        } else {
            self.titleTextField.text = "闹钟"
            let chooseDate = Date()
            let dateFormater = DateFormatter.init()
            dateFormater.dateFormat = "HH:mm"
            self.alarmModel = AlarmModel(timeStr: dateFormater.string(from: chooseDate), titleStr: "闹钟", switchStatus: true, weekArray: [], indentifyStr: createUuid())
        }
        
        addWeekView();
    }
    
    /**
     获取选择的时间
     */
    @objc func chooseDate(_ datePicker:UIDatePicker) {
        let chooseDate = datePicker.date
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "HH:mm"
        alarmModel?.timeStr = dateFormater.string(from: chooseDate);
    }

    func addNaviItem() {
        let rightItem = UIBarButtonItem(title: "存储", style: .plain, target: self, action: #selector(rightButtonClick))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightButtonClick() {
        titleTextField.resignFirstResponder()
        if self.sendDataClosure != nil {
            self.sendDataClosure!(alarmModel!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func addWeekView() {
        let weekArray = ["每周日", "每周一", "每周二", "每周三", "每周四", "每周五", "每周六"];
        for i in 0...6 {
            let button = UIButton(type: .custom)
            button.tag = 1010 + i
            button.setTitle(weekArray[i], for: .normal)
            button.frame = CGRect(x: i*50 + 10, y: Int(titleTextField.frame.maxY) + 5, width: 50, height: 40)
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)

            if (alarmModel?.weekArray.count)! > 0 && alarmModel!.weekArray.contains(i) {
                button.setTitleColor(.red, for: .normal)
            } else {
                button.setTitleColor(.black, for: .normal)
            }
            
            self.view.addSubview(button)
        }
    }
    
    @objc func buttonClick(button: UIButton) {
        button.isSelected = !button.isSelected;
        
        if (button.isSelected) {
            button.setTitleColor(.red, for: .normal)
            alarmModel?.weekArray.append(button.tag - 1010)
        } else {
            button.setTitleColor(.black, for: .normal)
            alarmModel?.weekArray.removeAll(where: {$0 == (button.tag - 1010)})
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


extension AddAlarmViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil && textField.text!.count > 0 {
            alarmModel?.titleStr = textField.text!
        }
    }
}
