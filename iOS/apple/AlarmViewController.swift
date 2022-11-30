//
//  AlarmViewController.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import UIKit

class AlarmViewController: UIViewController {

    lazy var tableView : UITableView = {
        var tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var dataArray : [AlarmModel] = {
        return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.title = "alarm"
        
        addNaviItem()
        self.view.addSubview(self.tableView)
        initData()
//        cancelAllLocalNotifications()
        getAllPendingNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func addNaviItem() {
        let rightItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(rightButtonClick))
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightButtonClick() {
        let addAlarmVC = AddAlarmViewController()
        addAlarmVC.sendDataClosure = { (sendModel: AlarmModel ) in
            self.dataArray.append(sendModel)
            self.tableView.reloadData()
            saveAlarmData(data: self.dataArray)
            addLocalNotification(model: sendModel)
        }
        self.navigationController?.pushViewController(addAlarmVC, animated: true)
    }
    
    func initData() {
        self.dataArray = getAlarmData()
        self.tableView.reloadData()
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

extension  AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AlarmTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! AlarmTableViewCell
        let model = self.dataArray[indexPath.row]
        cell.changeUI(data: model)
        weak var weakSelf = self
        cell.switchStatusClosure = { (isOn: Bool) in
            model.switchStatus = isOn
            saveAlarmData(data: weakSelf?.dataArray)
            if model.switchStatus {
                addLocalNotification(model: model)
            } else {
                cancelLocalNotificationWithIndentify(indentify: model.indentifyStr)
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = self.dataArray[indexPath.row]
        let addAlarmVC = AddAlarmViewController()
        addAlarmVC.alarmModel = model
        addAlarmVC.sendDataClosure = { (sendModel: AlarmModel ) in
            cancelLocalNotificationWithIndentify(indentify: model.indentifyStr)
            model = sendModel
            saveAlarmData(data: self.dataArray)
            self.tableView.reloadData()
            addLocalNotification(model: model)
        }
        self.navigationController?.pushViewController(addAlarmVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataArray.count {
            let model = self.dataArray[indexPath.row]
            cancelLocalNotificationWithIndentify(indentify: model.indentifyStr)
            self.dataArray.remove(at: indexPath.row)
            saveAlarmData(data: self.dataArray)
            self.tableView.reloadData()
        }
    }
}
