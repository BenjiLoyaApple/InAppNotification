//
//  InAppNotificationApp.swift
//  InAppNotification
//
//  Created by Benji Loya on 13.09.2024.
//

import SwiftUI

@main
struct InAppNotificationApp: App {
    
    //MARK: For In App Notifications
    @State private var overlayWindow: PassThroughWindow?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
            //MARK: For In App Notifications
                .onAppear(perform: {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let overlayWindow = PassThroughWindow(windowScene: windowScene)
                        overlayWindow.backgroundColor = .clear
                        overlayWindow.tag = 0320
                        let controller = StatusBarBasedController()
                        controller.view.backgroundColor = .clear
                        overlayWindow.rootViewController = controller
                        overlayWindow.isHidden = false
                        overlayWindow.isUserInteractionEnabled = true
                        self.overlayWindow = overlayWindow
                      //  print("Overlay Window Created")
                        
                    }
                })
            
        }
    }
}



//MARK: For In App Notifications
 class StatusBarBasedController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

fileprivate class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}


