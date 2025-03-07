import Foundation

public protocol UserService {
    func getCurrentUserId() -> UUID
}

public final class MockUserService: UserService {
    
    private let currentUserKey = "com.instagram.currentUserID"
    
    public init() {}
    
    public func getCurrentUserId() -> UUID {
        if let savedID = UserDefaults.standard.string(forKey: currentUserKey),
           let uuid = UUID(uuidString: savedID) {
            return uuid
        } else {
            let newID = UUID()
            UserDefaults.standard.set(newID.uuidString, forKey: currentUserKey)
            return newID
        }
    }
}

