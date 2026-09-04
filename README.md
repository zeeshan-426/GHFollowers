# GHFollowers - Native iOS Explorer

A lightning-fast, purely native iOS application that allows users to search for GitHub profiles, view their followers, and save favorite profiles for offline viewing. 

This project was built from scratch to demonstrate modern iOS development standards, explicitly avoiding Storyboards in favor of a 100% programmatic UI, and utilizing modern Swift Concurrency.

## 🚀 Features
- **100% Programmatic UI:** No Storyboards or XIBs. Every single view, constraint, and layout is built purely in Swift using AutoLayout.
- **Modern Concurrency:** Network requests utilize Swift's modern `async/await` and `Task` structures, completely eliminating callback hell and escaping closures.
- **Custom UI Components:** Reusable, highly scalable custom UI components (Buttons, TextFields, Alerts, ImageViews) designed to act like a proprietary design system.
- **Offline Persistence:** Uses `UserDefaults` with custom `JSONEncoder/Decoder` to securely save and load the user's favorite GitHub profiles.
- **Advanced Collection Views:** Utilizes `UICollectionView` with `UICollectionViewDiffableDataSource` and custom Flow Layouts for a buttery smooth, 3-column grid of followers.
- **Pagination:** Automatically fetches and appends the next 100 followers when the user scrolls to the bottom of the list.
- **Dynamic Search:** Real-time filtering of followers using `UISearchController`.

## 🛠 Tech Stack & Architecture
- **Language:** Swift 6
- **Framework:** UIKit
- **Architecture:** MVC (Model-View-Controller) heavily utilizing Delegates & Protocols for decoupled communication.
- **Networking:** Native `URLSession`
- **Data Parsing:** `JSONDecoder` (handling snake_case conversion)

## 📱 Screenshots
> *(Tip for Developer: Drag and drop 3-4 screenshots of your app running on the simulator right here before your final commit!)*

## 🧠 What I Learned
Building this app solidified my understanding of how iOS applications scale at an enterprise level. By abandoning Storyboards, I gained complete mastery over AutoLayout and the view lifecycle. Upgrading the network manager to `async/await` drastically simplified error handling and taught me how modern Swift handles background threads.

---
*Developed by a passionate iOS Engineer.*
