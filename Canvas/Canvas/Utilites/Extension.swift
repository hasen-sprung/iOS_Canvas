import UIKit

public extension UIView {
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

extension UIViewController {
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        customVcTransition.modalPresentationStyle = .fullScreen
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
}

// MARK: - App Group URL
extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.hasensprung.Canvas")!
}

// MARK: - 스테이터스바 색상 고정 (다크모드시 흰색 x)
extension UIStatusBarStyle {
    static var black: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
}

// MARK: - App Group을 사용해서 위젯과 앱 사이 UserDefault 교환
extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.hasensprung.Canvas"
        return UserDefaults(suiteName: appGroupId)!
    }
}

