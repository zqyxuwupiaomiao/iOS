//
//  CustomViewController.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import UIKit

class CustomViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNeedsStatusBarAppearanceUpdate();
        
        //导航条上UIBarButtonItem的颜色
        navigationBar.tintColor = .black;
        // 导航条的中间title的颜色字体大小
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        appearance.configureWithOpaqueBackground()
        // 导航条的背景色
//        appearance.backgroundColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        // 状态栏的样式（.dark时，🔋电池栏为白色）
        UINavigationBar.appearance().overrideUserInterfaceStyle = .light
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
