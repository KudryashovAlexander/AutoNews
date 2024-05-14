//
//  UIViewController_ext..swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import UIKit

extension UIViewController {
    // Метод для нахождения самого верхнего контроллера,
    // для показа на нем аллерта системы обработки ошибок ErrorHandler

    static func topMostViewController() -> UIViewController? {
        guard let activeScene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else {
            return nil
        }
        var topController = activeScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }

    var keyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        for scene in allScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window
            }
        }
        return nil
    }
}
