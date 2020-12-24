//
//  AppDelegate.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 15/6/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
// 

import UIKit
import PushKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
//    var window: UIWindow?
//    var fileLogger: DDFileLogger?
    weak var activeConversations: ConversationsVC?
    
    //MARK:- APNS Notification:
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//        let token = MLPush.string(fromToken: deviceToken)
//        MLXMPPManager.sharedInstance().hasAPNSToken = true
//        print("APNS token string \(token)")
//        MLPush().post(toPushServer: token)
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("push reg error \(error)")
//
//    }
    
    // MARK:- VOIP Notification:
    
//    func voipRegistration() {
//        print("registering for voip APNS...")
//        let mainQueue = DispatchQueue.main
//        let voipRegistry = PKPushRegistry(queue: mainQueue)
//        voipRegistry.delegate = self
////        voipRegistry.desiredPushTypes = Set<AnyHashable>([.voIP])
//    }

    // Handle updated APNS tokens
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let token = MLPush.string(fromToken: credentials.token)
//        MLXMPPManager.sharedInstance().hasAPNSToken = true
//        print("APNS voip token string \(token)")
//        MLPush().post(toPushServer: token)
//    }
//
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("didInvalidatePushTokenForType called (and ignored, TODO: disable push on server?)")
//    }
//
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        print("incoming voip push notfication: \(payload.dictionaryPayload)")
//        if UIApplication.shared.applicationState == .active {
//            return
//        }
//        if #available(iOS 13.0, *) {
//            print("Voip push shouldnt arrive on ios13.")
//        } else {
//            DispatchQueue.main.async(execute: {
//                var tempTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//                    print("VOIP push wake expiring")
////                    UIApplication.shared().endBackgroundTask(tempTask)
////                    UIApplication.shared.endBackgroundTask(tempTask)
////                    tempTask = .invalid
//                    MLXMPPManager.sharedInstance().logoutAllKeepStream(completion: nil)
//                })
//
//                MLXMPPManager.sharedInstance().connectIfNecessary()
//                print("voip push wake complete")
//            })
//        }
//    }
    
    // MARK:- Notificaiton Actions:
    
    @objc func updateUnread(){
        DataLayer.sharedInstance()?.countUnreadMessages(completion: { result in
            DispatchQueue.main.async {
                var unread = 0
                if result != nil {
                    unread = result?.intValue ?? 0
                }
                
                if unread > 0 {
                    UIApplication.shared.applicationIconBadgeNumber = unread
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        })
    }
    
    // MARK:- App Lifecycle:
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                  willPresent notification: UNNotification,
//                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler(.alert)
//      }
//
//    func handle(Url url: URL?){
//
//    }
//
//    func setConversations(_ conversations: UIViewController?){
//
//    }
            
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DDLog.add(DDOSLogger.sharedInstance)

//        #if DEBUG
//
//        #if !TARGET_IPHONE_SIMULATOR
//        fileLogger = DDFileLogger()
//        fileLogger?.rollingFrequency = 60 * 60 * 24 // 24 hour rolling
//        fileLogger?.logFileManager.maximumNumberOfLogFiles = 5
//        fileLogger?.maximumFileSize = 1024 * 500
//        DDLog.add(fileLogger!)
//        #endif
//
//        #endif
//
//
//        UNUserNotificationCenter.current().delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(updateState(_:)), name: NSNotification.Name(rawValue: kMLHasConnectedNotice), object: nil)
//        //NotificationCenter.default.addObserver(self, selector: #selector(showConnectionStatus(_:)), name: kXMPPError, object: nil)
//
//        //register for local notifications and badges
//            var categories: Set<AnyHashable>?
//
//
//            let replyAction = UNNotificationAction(identifier: "ReplyButton", title: "Reply", options: .foreground)
//            let replyActionCategory = UNNotificationCategory(identifier: "Reply", actions: [replyAction], intentIdentifiers: [])
//
//            let extensionCategory = UNNotificationCategory(identifier: "Extension", actions: [], intentIdentifiers: [])
//
//            categories = Set<AnyHashable>([replyActionCategory, extensionCategory])
//
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//                (granted, error) in
//                if granted == false {
//                    print("User declined notifications")
//                }
//            }
//
//
//        //register for voip push using pushkit
//        if UIApplication.shared.applicationState != .background {
//            // if we are launched in the background, it was from a push. dont do this again.
//            if #available(iOS 13.0, *) {
//                //no more voip mode after ios 13
//                if !UserDefaults.standard.bool(forKey: "HasUpgradedPushiOS13") {
//                    let push = MLPush()
//                    push.unregisterVOIPPush()
//                    UserDefaults.standard.set(true, forKey: "HasUpgradedPushiOS13")
//                }
//
//                UIApplication.shared.registerForRemoteNotifications()
//            } else {
//            #if !TARGET_OS_MACCATALYST
//                voipRegistration()
//            #endif
//            }
//        } else {
//            MLXMPPManager.sharedInstance().pushNode = UserDefaults.standard.object(forKey: "pushNode") as? String
//            MLXMPPManager.sharedInstance().pushSecret = UserDefaults.standard.object(forKey: "pushSecret") as? String
//            MLXMPPManager.sharedInstance().hasAPNSToken = true
//            print("push node \(MLXMPPManager.sharedInstance().pushNode)")
//        }
//
//        // should any accounts connect?
//        MLXMPPManager.sharedInstance().connectIfNecessary()
//
//        //update logs if needed
//        if !UserDefaults.standard.bool(forKey: "Logging") {
//            DataLayer.sharedInstance().messageHistoryCleanAll()
//        }
//        print("App started")
        return true
    }
    
    // MARK:- Handling URLS:
    
//    func openFile(_ file: String) -> Bool {
//        do{
//            let data = try Data(contentsOf: URL(string: file)!)
//            MLXMPPManager.sharedInstance().parseMessage(for: data)
//            return data.isEmpty == false ? true : false
//        } catch {}
//    }
    
//    func handle(_ url: URL?) {
//        //TODO just uses fist account. maybe change in the future
//        let account = (MLXMPPManager.sharedInstance().connectedXMPP.first as? [AnyHashable : Any])?["xmppAccount"] as? xmpp
//        if account != nil {
//            var components: NSURLComponents? = nil
//            if let url = url {
//                components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
//            }
//            let contact = MLContact()
////            contact.contactJid = components?.path as? String
////            contact.accountId = account?.accountNo as? String
//            var mucPassword: String?
//
//            (components?.queryItems as NSArray?)?.enumerateObjects({ obj, idx, stop in
//                if (obj as AnyObject).name == "join" {
//                    contact.isGroup = true
//                }
//                if (obj as AnyObject).name == "password" {
//                    mucPassword = (obj as AnyObject).value
//                }
//            })
//
//            if contact.isGroup {
//                //TODO maybe default nick once we have defined one
//                MLXMPPManager.sharedInstance().joinRoom(contact.contactJid,
//                                                        withNick: account?.connectionProperties.identity.user, andPassword: mucPassword, forAccounId: contact.accountId)
//            }
//
//            DataLayer.sharedInstance().addActiveBuddies(contact.contactJid, forAccount: contact.accountId, withCompletion: { success in
//                //no success may mean its already there
//                DispatchQueue.main.async(execute: {
//                    (self.activeConversations)?.presentChat(withRow: contact)
//                    (self.activeConversations)?.refreshDisplay()
//                })
//            })
//        }
//    }
////
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if url.scheme == "file" {
//            //return openFile(url)
//        }
//        if url.scheme == "xmpp" {
//            handle(url)
//            return true
//        }
//
//        return false
//    }

    // MARK:- User notifications:

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        if response.notification.request.identifier == "Local Notification" {
//            print("Handling notifications with the Local Notification Identifier")
//        }
//
//        completionHandler()
//        let userInfo = response.notification.request.content.userInfo
//        if userInfo["from"] != nil {
//            NotificationCenter.default.post(name: NSNotification.Name("kMonalPresentChat"), object: nil, userInfo: userInfo)
//        }
//
//        scheduleNotification(notificationType: "Testing")
//
//    }
//
//    func scheduleNotification(notificationType: String) {
//
//        let content = UNMutableNotificationContent()
//        let categoryIdentifire = "Delete Notification Type"
//
//        content.title = notificationType
//        content.body = "This is example how to create " + notificationType
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        content.categoryIdentifier = categoryIdentifire
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let identifier = "Local Notification"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error \(error.localizedDescription)")
//            }
//        }
//
//        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
//        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
//        let category = UNNotificationCategory(identifier: categoryIdentifire,
//                                              actions: [snoozeAction, deleteAction],
//                                              intentIdentifiers: [],
//                                              options: [])
//
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//    }

//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UNNotificationRequest, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
//
//
//        if notification.content.categoryIdentifier == "Reply" {
//            if identifier == "ReplyButton" {
//                let message = responseInfo[UIUserNotificationActionResponseTypedTextKey] as? String
//                if (message?.count ?? 0) > 0 {
//
//                    if notification.content.userInfo["from"] != nil {
//
//                        let replyingAccount = notification.content.userInfo["to"] as? String
//
//                        let messageID = UUID().uuidString
//
//                        //let encryptChat = DataLayer.sharedInstance().shouldEncrypt(forJid: notification.content.userInfo["from"], andAccountNo: notification.content.userInfo["accountNo"])
//
////                        DataLayer.sharedInstance().addMessageHistory(from: replyingAccount, to: notification.userInfo?["from"], forAccount: notification.userInfo?["accountNo"], withMessage: message, actuallyFrom: replyingAccount, withId: messageID, encrypted: encryptChat, withCompletion: { success, messageType in
////
////                        })
//
//
////                        MLXMPPManager.sharedInstance().sendMessage(message, toContact: notification.userInfo?["from"], fromAccount: notification.userInfo?["accountNo"], isEncrypted: encryptChat, isMUC: false, isUpload: false, messageId: messageID, withCompletionHandler: { success, messageId in
////
////                        })
//
//                        //DataLayer.sharedInstance().mark(asReadBuddy: notification.content.userInfo["from"], forAccount: notification.content.userInfo["accountNo"])
//                        updateUnread()
//                    }
//                }
//            }
//        }
//        if completionHandler != nil {
//            completionHandler()
//        }
//    }
//
    // MARK:- Background Functions:

//    @objc func updateState(_ notification: Notification?) {
//        DispatchQueue.main.async(execute: {
//            let state = UIApplication.shared.applicationState
//            if state == .inactive || state == .background {
//                MLXMPPManager.sharedInstance().setClientsInactive()
//            } else {
//                MLXMPPManager.sharedInstance().setClientsActive()
//            }
//        })
//    }

   // func applicationWillEnterForeground(_ application: UIApplication) {
//        print("Entering FG")
//
//        MLXMPPManager.sharedInstance().resetForeground()
//        MLXMPPManager.sharedInstance().setClientsActive()
//        MLXMPPManager.sharedInstance().sendMessageForConnectedAccounts()
    //}

    //func applicationWillResignActive(_ application: UIApplication) {
//        let groupDefaults = UserDefaults(suiteName: "group.monal")
//        DataLayer.sharedInstance().activeContacts(completion: { cleanActive in
//            var archive: Data? = nil
//            do {
//                if let cleanActive = cleanActive {
//                    archive = try NSKeyedArchiver.archivedData(withRootObject: cleanActive, requiringSecureCoding: true)
//                }
//            } catch {
//            }
//            groupDefaults?.set(archive, forKey: "recipients")
//            groupDefaults?.synchronize()
//        })
//
//        groupDefaults?.set(DataLayer.sharedInstance().enabledAccountList(), forKey: "accounts")
//        groupDefaults?.synchronize()
    //}

    
    //func applicationDidEnterBackground(_ application: UIApplication) {
//        let state = application.applicationState
//        if state == .inactive {
//            print("Screen lock")
//        } else if state == .background {
//            print("Entering BG")
//        }
//
//        updateUnread()
//        MLXMPPManager.sharedInstance().setClientsInactive()

    //}

//    func applicationWillTerminate(_ application: UIApplication) {
//        updateUnread()
//        UserDefaults.standard.synchronize()
//    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setActiveConversations(_ conversations: UIViewController?){
        self.activeConversations = conversations as? ConversationsVC
    }
    


}

//extension AppDelegate: PKPushRegistryDelegate,
//UNUserNotificationCenterDelegate {
//
//}

