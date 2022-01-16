# BoxOffice ReactorKit

<div align="left">
  <img alt="swift" src="https://img.shields.io/badge/Swift-5.5%20-orange" />
  <img alt="swift" src="https://img.shields.io/badge/iOS-15.2-lightgrey" />
</div>

<div align="center">
  
![Boxoffice ReactorKit](https://user-images.githubusercontent.com/20268101/149651553-38554692-3350-4c9a-8696-e06324bb5f32.gif)

</div>

## Contents

* <a href="#Introduction">Introduction</a>
* <a href="#Dependencies">Dependencies</a>
* <a href="#Features"><a href="#Features">Features</a></a>
* <a href="#Directory-Structure">Directory Structure</a>
* <a href="#License">License</a>

## Introduction

The BoxOffice ReactorKit is a simple movie information application where you can see movie lists and movie information and write reviews of selected movies. 

And also this project is a implementation of [Boost Course iOS app programming](https://www.boostcourse.org/mo326)'s final project run by the NAVER Connect Foundation into a ReactorKit.

## Dependencies

* [ReactorKit](https://github.com/ReactorKit/ReactorKit)
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift)
* [RxViewController](https://github.com/devxoul/RxViewController)
* [RxGesture](https://github.com/RxSwiftCommunity/RxGesture)
* [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)
* iOS 15+
* Swift 5
* CocoaPods

## Features

### 1. Movie List Screen

![BoxOffice+ReactorKit1 001](https://user-images.githubusercontent.com/20268101/149650819-31f50fbe-506e-4b04-936f-c5868bf85ca5.jpeg)

The Movie List page requests movie information through the server API and shows the imported data using table views and collection views. You can request movie information according to the conditions (by reservation rate, curation, release date), and select the desired movie from the movie list to view the details.

### 2. Movie Screen

![BoxOffice+ReactorKit2 001](https://user-images.githubusercontent.com/20268101/149649998-c6d94233-2ef7-4192-a3a6-d866429e16d2.jpeg)

On the Movie page, you can see movie details and movie comments. If you touch the review creation button, you will go to the page where you write the review.

### 3. Review Screen

![BoxOffice+ReactorKit3 001](https://user-images.githubusercontent.com/20268101/149649999-d3049c16-f02e-4711-8763-c9330dcf18ec.jpeg)

On the Review creation page, you can select star rating and create a review.

## Directory Structure

```text
BoxOffice+ReactorKit
├── Soureces
│   ├── App
│   │   └── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Models
│   ├── Services
│   ├── Sections
│   ├── ViewControllers
│   ├── Views
│   ├── Utils
│   └── Constants
└── Resources
    ├── Assets
    ├── LaunchScreen.storyboard
    ├── Info.plist
    └── Localizable.strings

```

## License

BoxOffice-ReactorKit is under MIT license. See the [LICENSE]() for more info.

## Contribution

Contributions are always welcome 😎

## Contact

Facebook: https://www.facebook.com/haeseoklee.dev/

E-mail: haeseoklee.dev@gmail.com
