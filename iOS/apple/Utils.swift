//
//  Utils.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import Foundation
import EventKit
import UserNotifications

let keyStr = "alarmDataKey"
let identifierIdKey = "identifierId"

let timerIdentifierIdKey = "timerIdentifierId"

typealias CallBackBlock = (Bool)->();
let store = EKEventStore.init();

func requestAccessToEntityType(type: EKEntityType, callBack: @escaping CallBackBlock) {
    store.requestAccess(to: type) { result, error in
        callBack(result);
    }
}

func requestAccessToNotifi(callBack: @escaping CallBackBlock) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        if (settings.authorizationStatus == .authorized){
            callBack(true);
        } else {
            callBack(false);
        }
    }
}

/**
 * 添加本地通知
 */
func addLocalNotification(model: AlarmModel) {
    let content = UNMutableNotificationContent()
    content.title = model.timeStr
    content.body = model.timeStr
    content.sound = .default
    content.userInfo = [identifierIdKey: model.indentifyStr]
    
    let timeArray = model.timeStr.components(separatedBy: ":")
    
    let nowDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: Date())
    let dateStr = String(nowDateComponents.year ?? 0) + "-" + String(nowDateComponents.month ?? 0) + "-" + String(nowDateComponents.day ?? 0) + " " + model.timeStr
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm"
    let fireDate = formatter.date(from: dateStr)!
    let oldDateComponents = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter], from: fireDate)

    var components: DateComponents = DateComponents()
    components.hour = Int(timeArray[0])
    components.minute = Int(timeArray[1])
    components.second = 0
    var isRepeat = false
    if model.weekArray.count == 7 {
        // 每天都重复
        isRepeat = true
    } else if model.weekArray.count == 0 {
        // 只触发一次
        isRepeat = false
        let result:ComparisonResult = fireDate.compare(Date())
        if result == ComparisonResult.orderedDescending {
            components.year = oldDateComponents.year
            components.month = oldDateComponents.month
            components.day = oldDateComponents.day
        } else {
            // 当前日期小加一天
            let newDate = Calendar.current.date(from: oldDateComponents)?.addingTimeInterval(TimeInterval(3600 * 24))
            components = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: newDate!)
        }
        
    } else {
        // 每周重复
        isRepeat = true
        for obj in model.weekArray {
            var temp = 0
            var days = 0
            temp = Int(obj) + 1 - oldDateComponents.weekday!
            days = (temp >= 0 ? temp : temp + 7)
            let newDate = Calendar.current.date(from: oldDateComponents)?.addingTimeInterval(TimeInterval(3600 * 24 * days))
            let newDateComponents = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter], from: newDate!)
            components.weekday = newDateComponents.weekday
            sendNoti(components: components, isRepeat: isRepeat, content: content)
        }
        return
    }
    
    sendNoti(components: components, isRepeat: isRepeat, content: content)
}

func sendNoti(components: DateComponents, isRepeat: Bool, content: UNMutableNotificationContent) {
    let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: isRepeat);

    let request = UNNotificationRequest.init(identifier: createUuid(), content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
//            print(error);
    };
}

func createUuid() -> String {
    let uuidRef = CFUUIDCreate(nil)
    let uuidStringRef = CFUUIDCreateString(nil,uuidRef)
    return uuidStringRef! as String
}

func getAllPendingNoti() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        print(requests)
    }
}

func sendTimerNoti(timeN: Int) {
    let content = UNMutableNotificationContent()
    content.title = "计时器"
    content.body = "计时器"
    content.sound = .default
    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    let newDate = Calendar.current.date(from: components)?.addingTimeInterval(TimeInterval(timeN))
    let newDateComponents = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: newDate!)
    let trigger = UNCalendarNotificationTrigger.init(dateMatching: newDateComponents, repeats: false);
    let request = UNNotificationRequest.init(identifier: timerIdentifierIdKey, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
//            print(error);
    };
}

func cancelTimerNoti() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timerIdentifierIdKey])
}

/**
 * 根据ID取消所有通知123
 * @param indentify 用来识别通知 日程模块传ID
 */
func cancelLocalNotificationWithIndentify(indentify: String) {
    let center = UNUserNotificationCenter.current()
    center.getPendingNotificationRequests { requests in
        for request in requests {
            if let indentifyNow = request.content.userInfo[identifierIdKey] {
                if indentifyNow as! String == indentify {
                    center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                }
            }
        }
        print(requests)
    }
}

/**
 * 取消所有通知123
 */
func cancelAllLocalNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
}

/**
 *  根据时间HH:mm拼接当前日期
 */
func getCurrentDate(timeStr: String) -> Date {
    if timeStr.count > 0 {
        let timeArray = timeStr.components(separatedBy: ":")
        if timeArray.count > 1 {
            let nowDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: Date())
            let dateStr = String(nowDateComponents.year ?? 0) + "-" + String(nowDateComponents.month ?? 0) + "-" + String(nowDateComponents.day ?? 0) + " " + timeStr
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm"
            return formatter.date(from: dateStr)!
        }
    }
    
    return Date()
}

func localDate() -> Date {
    let nowUTC = Date()
    let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
    guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

    return localDate
}

func saveAlarmData(data: Array<AlarmModel>?) {
    do {
        let tokenJson = try JSONEncoder().encode(data);
        UserDefaults.standard.set(tokenJson, forKey: keyStr);
    } catch {
        print("添加数据失败：Json无法解码成对象")
    }
}

func getAlarmData() -> Array<AlarmModel> {
    if let val = UserDefaults.standard.value(forKey: keyStr) {
        do {
            let varData =  val as! Data;
            let result = try JSONDecoder().decode(Array<AlarmModel>.self, from: varData);
            return result;
        } catch {
            print("加载数据失败：Json无法解码成对象")
        }
    }
    return [];
}
