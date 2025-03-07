# InsStories

## Description

Skeleton of Instagram stories feature

## Features
- list of stories on Home
- story view with a gallery of pictures (auto-scrolling)
- swipe down to dismiss the story
- each picture can be liked
- persistence across app launch

## Architecture 

- The app has a clean modular architecture, each building block is separated in a Package (Services/Models/Features). 
- Each service layer is a protocol and is easy to mock.
- MVVM pattern to separate UI and logic layer


## What can be improved

- Missing seen/unseen status on the home. I spent more time tweaking the animation and gestures on the story view.
- Unit/UI tests
- I wanted to add the progress bar to show the time remaining before next image instead of the dots, but didn't have time.
- Wanted to add double tap to like, but couldn't make it work with the tap and swipe gesture.
- Use a better persistence mechanism than UserDefaults (CoreData or SwiftData)
- Missing error/retry handling



