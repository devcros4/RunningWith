import Foundation

/// all completion type
typealias UserCompletion = (_ user: User?) -> Void
typealias UsersCompletion = (_ user: [User]?) -> Void
typealias RunCompletion = (_ run: Run?) -> Void
typealias RunsCompletion = (_ run: [Run]?) -> Void
typealias SuccessCompletion = (_ success: Bool?, _ string: String?) -> Void
typealias ErrorCompletion = (_ error: Error?) -> Void
typealias NotifCompletion = (_ notif: Notif?) -> Void
