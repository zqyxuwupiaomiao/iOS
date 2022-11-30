//
//  AlarmTableViewCell.swift
//  apple
//
//  Created by zqy on 2022/11/11.
//

import UIKit

class AlarmModel: Codable {
    var timeStr: String
    var titleStr: String
    var switchStatus: Bool
    var weekArray: [Int]
    var indentifyStr: String
    
    init(timeStr: String, titleStr: String, switchStatus: Bool, weekArray: [Int], indentifyStr: String) {
        self.timeStr = timeStr
        self.titleStr = titleStr
        self.switchStatus = switchStatus
        self.weekArray = weekArray
        self.indentifyStr = indentifyStr
    }
}

class AlarmTableViewCell: UITableViewCell {
    
    private var timeLable: UILabel = {
        let timeLable = UILabel(frame: CGRect(x: 20, y: 20, width: 140, height: 40));
        timeLable.font = UIFont.systemFont(ofSize: 40);
        return timeLable;
    }()

    private var titleLable: UILabel = {
        let titleLable = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 20));
        titleLable.font = UIFont.systemFont(ofSize: 20);
        return titleLable;
    }()
    
    private var alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch(frame: CGRect(x: 300, y: 30, width: 100, height: 20));
        return alarmSwitch;
    }()
    
    var switchStatusClosure: ((Bool) ->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.timeLable);
        self.contentView.addSubview(self.titleLable);
        self.contentView.addSubview(self.alarmSwitch);
        alarmSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeUI(data: AlarmModel) {
        self.timeLable.text = data.timeStr;
        self.titleLable.text = data.titleStr;
        self.alarmSwitch.isOn = data.switchStatus;
    }
    
    @objc func switchDidChange(sender: UISwitch){
        self.switchStatusClosure!(sender.isOn)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
