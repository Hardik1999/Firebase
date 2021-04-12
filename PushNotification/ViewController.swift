//
//  ViewController.swift
//  PushNotification
//
//  Created by Hardik on 4/12/21.
//

import UIKit
import UserNotifications
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

   
    @IBOutlet weak var viewFB: UIView!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnLocal: UIButton!
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    fileprivate let fbLoginButton = FBLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
        btnLocal.layer.cornerRadius = 5
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }else{
            btnFacebook.permissions = ["public_profile", "email"]
            btnFacebook.delegate = self
            btnFacebook.imageView?.isHidden = true
            
        }
        
    }
    
    func requestNotificationAuthorization() {
//        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
//
//        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
//            if let error = error {
//                print("Error: ", error)
//            }
//        }
        
        userNotificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (Success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    @IBAction func onClickFacebook(_ sender: Any) {

        
        
    }
    
    @IBAction func onClickLocal(_ sender: Any) {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()

        notificationContent.categoryIdentifier = "My Category indetifier"
        // Add the content to the notification content
        notificationContent.title = "Trip"
        notificationContent.body = "Manali trip Photos added"
        notificationContent.badge = 1
        notificationContent.sound = UNNotificationSound.default

        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "Hardik",
                                        withExtension: "jpg") {
            if let attachment = try? UNNotificationAttachment(identifier: "Hardik",
                                                                url: url,
                                                                options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PushViewController") as! PushViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            print(#function)
            completionHandler([.banner, .list, .sound])
        }
}

extension ViewController : LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start { (connection, result, error) in
            print("\(result)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PushViewController") as! PushViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

