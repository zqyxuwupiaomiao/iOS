//
//  SceneDelegate.swift
//  apple
//
//  Created by zqy on 2022/11/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let scene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow.init(windowScene: scene);
        self.window?.backgroundColor = UIColor.white;
        
        let nvc1:CustomViewController = CustomViewController.init(rootViewController: AlarmViewController());
        let nvc2:CustomViewController = CustomViewController.init(rootViewController: TimerViewController());
        let nvc3:CustomViewController = CustomViewController.init(rootViewController: ScrollViewController());
        let tabbar1 = UITabBarItem(title: "Alarm", image: UIImage.init(), selectedImage: UIImage.init());
        let tabbar2 = UITabBarItem(title: "Timer", image: UIImage.init(), selectedImage: UIImage.init());
        let tabbar3 = UITabBarItem(title: "Scroll", image: UIImage.init(), selectedImage: UIImage.init());
        nvc1.tabBarItem = tabbar1;
        nvc2.tabBarItem = tabbar2;
        nvc3.tabBarItem = tabbar3;

        let tc = UITabBarController();
        tc.viewControllers = [nvc1,nvc2,nvc3];
        tc.tabBar.backgroundColor = .white;
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal);
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected);

        self.window?.rootViewController = tc;
                
        self.window?.makeKeyAndVisible();
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

