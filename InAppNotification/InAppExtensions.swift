//
//  InAppExtensions.swift
//  ios17
//
//  Created by Benji Loya on 03.10.2023.
//

import SwiftUI

extension UIApplication {
    func inAppNotification<Content: View>(adaptForDynamicIsland: Bool = false, timeout: CGFloat = 5, swipeToClose: Bool = true,  @ViewBuilder content: @escaping () -> Content) {
        /// Fetching Active Window VIA WindowScene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            /// Frame and SafeArea Values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            
            var tag: Int = 1009
            let checkForDynamicIsland = adaptForDynamicIsland && safeArea.top >= 51
            
            if let previousTag = UserDefaults.standard.value(forKey: "in_app_notification_tag") as? Int {
                tag = previousTag + 1
            }
            
            UserDefaults.standard.setValue(tag, forKey: "in_app_notification_tag")
            
            /// Changing Status into Black to blend with Dunamic Island
            if checkForDynamicIsland {
                if let controller = activeWindow.rootViewController as?
                    StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
            
            /// Creating UIView from SwiftUIView using UIHosting Configuration
            let config = UIHostingConfiguration {
                AnimatedNotificationView(
                    content: content(),
                    safeArea: safeArea,
                    tag: tag,
                    adaptForDynamicIsland: checkForDynamicIsland,
                    timeout: timeout,
                    swipeToClose: swipeToClose)
                
                /// Max Notification Height will be 120
                .frame(width: frame.width - (checkForDynamicIsland ? 20 : 30), height: 120, alignment: .top)
                .contentShape(.rect)
                
            }
            
            /// Creating UIView
            let view = config.makeContentView()
            view.tag = tag
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let rootView = activeWindow.rootViewController?.view {
                /// Adding View to the Window
                rootView.addSubview(view)
                
                ///  Layout Constraints
                view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor, constant: (-(frame.height - safeArea.top) / 2) + (checkForDynamicIsland ? 11 : safeArea.top)).isActive = true
            }
            
        }
    }
}

fileprivate struct AnimatedNotificationView<Content: View>: View {
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    /// View Properties
    @State private var animateNotification: Bool = false
    
    var body: some View {
        content
            .blur(radius: animateNotification ? 0 : 10)
            .disabled(!animateNotification)
            .mask {
                if adaptForDynamicIsland {
                    /// Size  Based Capsule
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        let radius = size.height / 2
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                    })
                } else {
                    Rectangle()
                }
            }
        /// Scaling Animation only For Dynamic Island Notification
            .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.01))
        
        /// Offset Animation for Non Dynamic Island notification
            .offset(y: offsetY)
            .gesture(
            DragGesture()
                .onEnded({ value in
                    if -value.translation.height > 50 && swipeToClose {
                        withAnimation(.smooth, completionCriteria: .logicallyComplete) {
                            animateNotification = false
                        } completion: {
                            removeNotificationViewfromWindow()
                        }
                    }
                })
            )
        
            .onAppear(perform: {
                Task {
                    guard !animateNotification else { return }
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    
                    /// Timeout For notification
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    
                    guard animateNotification else { return }
                    
                    withAnimation(.smooth, completionCriteria: .logicallyComplete) {
                        animateNotification = false
                    } completion: {
                        removeNotificationViewfromWindow()
                    }
                }
            })
    }
    
    var offsetY: CGFloat {
        if adaptForDynamicIsland {
            return 0
        }
        return animateNotification ? 10 : -(safeArea.top + 130)
    }
    
    
    func removeNotificationViewfromWindow() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as?
                               UIWindowScene)?.windows.first(where: { $0.tag == 0320}) {
            if let view = activeWindow.viewWithTag(tag) {
               // print("Removed View with \(tag)")
                view.removeFromSuperview()
                
                /// Reseting Once All the notifications was removed
                if let controller = activeWindow.rootViewController as?
                    StatusBarBasedController, controller.view.subviews.isEmpty {
                    controller.statusBarStyle = .default
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
