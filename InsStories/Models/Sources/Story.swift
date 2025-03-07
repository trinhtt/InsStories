import Foundation

public struct Story: Identifiable, Codable, Sendable {
    public let id: UUID
    public let username: String
    public let userIcon: URL
    public var images: [StoryImage]
    
    public init(
        id: UUID = UUID(),
        username: String,
        userIcon: URL,
        images: [StoryImage]
    ) {
        self.id = id
        self.username = username
        self.userIcon = userIcon
        self.images = images
    }
}
