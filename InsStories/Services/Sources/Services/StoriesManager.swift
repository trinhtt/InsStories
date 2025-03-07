import Foundation
import Models

public protocol StoriesManager: Sendable {
    
    func getNewStories() async throws -> [Story]
    func persistStories(_ stories: [Story]) async throws
    func loadPersistedStories() async throws -> [Story]
    
}

public final class MockStoriesManager: StoriesManager {
    
    private let userDefaultsStoriesKey = "com.instagram.storiesKey"
    
    public init() {}
    
    public func getNewStories() async throws -> [Story] {
        [
            Story(
                username: "user1",
                userIcon: URL(string: "https://images.freeimages.com/images/large-previews/56d/peacock-1169961.jpg?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
            Story(
                username: "user2",
                userIcon: URL(string: "https://images.freeimages.com/images/large-previews/355/poppies-2-1334190.jpg?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
            Story(
                username: "user3",
                userIcon: URL(string: "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
            Story(
                username: "user4",
                userIcon: URL(string: "https://images.freeimages.com/variants/ARFoM1GQWRqUuBDXfvwPBvux/f4a36f6589a0e50e702740b15352bc00e4bfaf6f58bd4db850e167794d05993d?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
            Story(
                username: "user5",
                userIcon: URL(string: "https://images.freeimages.com/images/large-previews/bc4/curious-bird-1-1374322.jpg?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
            Story(
                username: "user6",
                userIcon: URL(string: "https://images.freeimages.com/variants/pgFBx5hMEeeJ1s6eWuDjHBZe/f4a36f6589a0e50e702740b15352bc00e4bfaf6f58bd4db850e167794d05993d?fmt=webp&w=100")!,
                images: [
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/1461264/pexels-photo-1461264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                    .init(imageURL: URL(string: "https://images.pexels.com/photos/804605/pexels-photo-804605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
                ]
            ),
        ]
    }
    
    public func persistStories(_ stories: [Story]) async throws {
        let data = try JSONEncoder().encode(stories)
        UserDefaults.standard.set(data, forKey: userDefaultsStoriesKey)
    }
    
    public func loadPersistedStories() async throws -> [Story] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsStoriesKey) {
            do {
                let stories = try JSONDecoder().decode([Story].self, from: data)
                return stories
            } catch {
                return try await getNewStories()
            }
        } else {
            return try await getNewStories()
        }
    }
}
