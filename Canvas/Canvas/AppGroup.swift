import Foundation

public enum AppGroup: String {
    case facts = "group.com.hasensprung.Canvas"
    
    public var containerURL: URL {
        switch self {
        case .facts:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}
