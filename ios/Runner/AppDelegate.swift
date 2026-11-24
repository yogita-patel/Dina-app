import UIKit
import FirebaseCore
import Flutter
import Firebase
import GoogleMaps
import QuickLook
import AuthenticationServices
import MLKit
import SwiftKeychainWrapper

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var _latestLink: String?
    private var methodChannel: FlutterMethodChannel?
    private var latestLink: String? {
        get {
            _latestLink
        }
        set(latestLink) {
            
            _latestLink = latestLink
            if _eventSink != nil {
                _eventSink?(_latestLink)
            }
        }
    }
    
    private var _eventSink: FlutterEventSink?
    var fileURL: URL!
    var  result: FlutterResult?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyC7KJpt2Bii6zG0QXdvG3VuWUCj3t_HjMg")
        GeneratedPluginRegistrant.register(with: self)

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let mlkitChannel = FlutterMethodChannel(name: "com.webkul.oc.methodchannel",
                                                binaryMessenger: controller.binaryMessenger)
        methodChannel = mlkitChannel
        mlkitChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "imageSearch"{
                let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
                vc.detectorType =  .image
                vc.modalPresentationStyle = .overFullScreen
                vc.suggestedData = { data in
                    result(data)
                }
                controller.present(vc, animated: true, completion: nil)
            }else if call.method == "textSearch"{
                let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
                vc.detectorType = .text
                vc.modalPresentationStyle = .overFullScreen
                vc.suggestedData = { data in
                    result(data)
                }
                controller.present(vc, animated: true, completion: nil)
            }else if call.method == "fileviewer"{
                if let urlString = call.arguments as? String, let url = self.showFileWithPath(urlString){
                    self.fileURL = url
                    DispatchQueue.main.async {
                        guard
                            UIApplication.shared.applicationState == .active,
                            let presenter = self.topViewController(from: self.window?.rootViewController),
                            presenter.viewIfLoaded?.window != nil
                        else {
                            result(FlutterError(
                                code: "VIEW_NOT_READY",
                                message: "The app is not ready to display the downloaded PDF",
                                details: nil
                            ))
                            return
                        }

                        let previewController = QLPreviewController()
                        previewController.dataSource = self
                        previewController.delegate = self
                        previewController.modalPresentationStyle = .fullScreen
                        presenter.present(previewController, animated: true) {
                            result(true)
                        }
                    }
                } else {
                    result(FlutterError(
                        code: "FILE_NOT_FOUND",
                        message: "Downloaded PDF was not found",
                        details: nil
                    ))
                }
            }else if call.method == "publishPdfToDownloads" {
                guard
                    let arguments = call.arguments as? [String: Any],
                    let sourcePath = arguments["sourcePath"] as? String,
                    let fileName = arguments["fileName"] as? String
                else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Missing sourcePath or fileName",
                        details: nil
                    ))
                    return
                }
                self.publishPdfToDocuments(
                    sourcePath: sourcePath,
                    fileName: fileName,
                    result: result
                )
            }else if call.method == "getExistingDownloadFileNames" {
                result(self.existingCatalogueFileNames())
            }else if call.method == "appleSignin"{
                self.result = result
                if #available(iOS 13.0, *) {
                    let request = ASAuthorizationAppleIDProvider().createRequest()
                    request.requestedScopes = [.fullName, .email]
                    //   let authorizationController = ASAuthorizationController(authorizationRequests: [request, ASAuthorizationPasswordProvider().createRequest()])
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    authorizationController.delegate = self
                    authorizationController.presentationContextProvider = self
                    authorizationController.performRequests()
                }

            }else if call.method == "dynamicLauncher" {
                self.result = result
                let appIconType = call.arguments as? String
                print("IconCount--->" + (appIconType ?? ""))
                if #available(iOS 13.0, *){
                    self.checkIconType(Int( appIconType ?? "0") ?? 0)
                }
                result(true)
            }else if call.method == "initialLink" {
                result(self.consumeLatestLink())
            }else{
                result(FlutterMethodNotImplemented)
            }
        })




        let chargingChannel = FlutterEventChannel(
            name: "uni_links/events",
            binaryMessenger: controller.binaryMessenger)
        chargingChannel.setStreamHandler(self)


//        GeneratedPluginRegistrant.register(with: self)
////        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//        if #available(iOS 10.0, *){
//            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func showFileWithPath(_ path: String) -> URL?{
        if let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            print(documentsUrl)
            let destinationFileUrl = documentsUrl.appendingPathComponent(path)
            print(documentsUrl)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationFileUrl.path) {
                print("FILE AVAILABLE")
                return destinationFileUrl
            }
        }
        return nil
    }

    private func topViewController(from controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController,
           let selectedController = tabBarController.selectedViewController {
            return topViewController(from: selectedController)
        }
        if let presentedController = controller?.presentedViewController,
           !presentedController.isBeingDismissed {
            return topViewController(from: presentedController)
        }
        return controller
    }

    func publishPdfToDocuments(
        sourcePath: String,
        fileName: String,
        result: FlutterResult
    ) {
        guard let documentsUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            result(FlutterError(
                code: "DOCUMENTS_UNAVAILABLE",
                message: "Documents directory is unavailable",
                details: nil
            ))
            return
        }

        let sourceUrl = URL(fileURLWithPath: sourcePath)
        let destinationUrl = documentsUrl.appendingPathComponent(fileName)
        do {
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                result(FlutterError(
                    code: "FILE_EXISTS",
                    message: "A catalogue with this filename already exists",
                    details: nil
                ))
                return
            }
            try FileManager.default.moveItem(at: sourceUrl, to: destinationUrl)
            result(fileName)
        } catch {
            result(FlutterError(
                code: "PUBLISH_FAILED",
                message: error.localizedDescription,
                details: nil
            ))
        }
    }

    func existingCatalogueFileNames() -> [String] {
        guard let documentsUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return []
        }
        let names = (try? FileManager.default.contentsOfDirectory(
            atPath: documentsUrl.path
        )) ?? []
        return names.filter {
            $0.hasPrefix("Dina_International_Catalogue") && $0.hasSuffix(".pdf")
        }
    }

    private func consumeLatestLink() -> String? {
        let link = latestLink
        latestLink = nil
        return link
    }

    // Routes that should NOT be handled in-app – open in Safari instead.
    private let excludedRoutes = [
        "extension/module/email_verification",
        "account/forgotten",
        "account/reset"
    ]

    private func isExcludedDeepLink(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let routeItem = components.queryItems?.first(where: { $0.name == "route" }),
              let route = routeItem.value else {
            return false
        }
        return excludedRoutes.contains(where: { route.hasPrefix($0) })
    }

    private func handleIncomingDeepLink(_ url: URL) {
        let deepLink = url.absoluteString
        print("Deep Link Received: \(deepLink)")

        // Skip excluded routes — open them in Safari instead
        if isExcludedDeepLink(url) {
            print("Excluded deep link route – opening in Safari: \(deepLink)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }

        setLatestLink(deepLink)
        methodChannel?.invokeMethod("handleDeepLink", arguments: deepLink)
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                      if let url = userActivity.webpageURL {
                        handleIncomingDeepLink(url)
                      }
                    }
                    return true

//        if userActivity.activityType == "NSUserActivityTypeBrowsingWeb" {
//            print(userActivity.webpageURL as Any)
//            setLatestLink(userActivity.webpageURL?.description)
//        }
//        return true
    }

    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        handleIncomingDeepLink(url)
        return true
    }
}

extension AppDelegate: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print(#function)
        print(userActivityType)
        return true
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }
    
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
    func setLatestLink(_ latestLink: String?) {
        self.latestLink = latestLink
        if (_eventSink != nil) {
            _eventSink?(self.latestLink)
        }
    }
}
enum Keys: String {
    case fname
    case lname
    case email
    case userID
    case personID
}
@available(iOS 13.0, *)
extension AppDelegate: ASAuthorizationControllerDelegate {
    private var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        var socialParams = [String: Any]()
        if let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
            var status = false
            if KeychainWrapper.standard.set(appleIDCredential.email!, forKey: Keys.email.rawValue) {
                status = true
            }
            if KeychainWrapper.standard.set(appleIDCredential.fullName?.givenName ?? "Test", forKey: Keys.fname.rawValue) {
                status = true
            }
            if KeychainWrapper.standard.set(appleIDCredential.fullName?.familyName ?? "Test", forKey: Keys.lname.rawValue) {
                status = true
            }
            if status {
                socialParams["firstname"] = appleIDCredential.fullName?.givenName
                socialParams["lastname"] = appleIDCredential.fullName?.familyName
                let key = self.fourDigitNumber
                KeychainWrapper.standard.set(key, forKey: Keys.personID.rawValue)
                socialParams["email"] = appleIDCredential.email
                socialParams["pictureURL"] = ""
                self.result?(socialParams)
            }
        }else {
            //socialParams["wk_token"] = sharedPrefrence.object(forKey:"wk_token");
            socialParams["firstname"] = KeychainWrapper.standard.string(forKey: Keys.fname.rawValue)
            socialParams["lastname"] = KeychainWrapper.standard.string(forKey: Keys.lname.rawValue)
            socialParams["personId"] = KeychainWrapper.standard.string(forKey: Keys.personID.rawValue)
            socialParams["email"] = KeychainWrapper.standard.string(forKey: Keys.email.rawValue)
            socialParams["pictureURL"] = ""
            self.result?(socialParams)
        }
    }


    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //   NetworkManager.sharedInstance.showErrorSnackBar(msg: error.localizedDescription)
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
    
    func checkIconType(_ appIcon: Int) {
        if(appIcon == 1){
            self.setIcon("AppIconOne")
        }else if(appIcon == 2){
            self.setIcon("AppIconTwo")
        }else if(appIcon == 3){
            self.setIcon("AppIconThree")
        }else{
            self.setIcon("AppIconOC")
        }
    }
    
    func setIcon(_ appIcon: String) {
                    print(appIcon)

                    if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
                        
                        typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
                        
                        let selectorString = "_setAlternateIconName:completionHandler:"
                        
                        let selector = NSSelectorFromString(selectorString)
                        let imp = UIApplication.shared.method(for: selector)
                        let method = unsafeBitCast(imp, to: setAlternateIconName.self)
                        method(UIApplication.shared, selector, appIcon as NSString?, { _ in })
                    }else{
                        print("Error in icon update")
                    }

        }
}

@available(iOS 13.0, *)
extension AppDelegate: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
}
