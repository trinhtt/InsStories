import Foundation

public struct StoryImage: Identifiable, Codable, Sendable {
    public let id: UUID
    public let imageURL: URL
    public var likedByUsers: [UUID]
    
    public init(id: UUID = UUID(), imageURL: URL, likedByUsers: [UUID] = []) {
        self.id = id
        self.imageURL = imageURL
        self.likedByUsers = likedByUsers
    }
}
