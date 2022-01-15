# BoxOffice ReactorKit

<div align="left">
  <img alt="swift" src="https://img.shields.io/badge/Swift-5.5%20-orange" />
  <img alt="swift" src="https://img.shields.io/badge/iOS-15.2-lightgrey" />
</div>


gif 세개 추가하기 (메인, 디테일, 리뷰작성)



## Contents

* <a href="#Introduction">Introduction</a>
* <a href="#Dependencies">Dependencies</a>
* <a href="#Features"><a href="#Features">Features</a></a>
* <a href="#Directory-Structure">Directory Structure</a>
* <a href="#License">License</a>

## Introduction

네이버 커넥트 재단에서 운영하는 BoostCourse의 [iOS 앱 프로그래밍 심화과정](https://www.boostcourse.org/mo326) 마지막 프로젝트를 <a href="#아키텍처_구성도">MVVM 아키텍처</a>로 재구현하였습니다. 

BoxOffice 애플리케이션은 서버의 API를 통해 영화 정보를 요청하고, 가져온 정보를 테이블 뷰와 컬렉션 뷰를 활용하여 화면에 표현해줍니다. 

여러 조건 (예매율순, 큐레이션, 개봉일순)에 따라 영화 정보를 요청할 수 있고, 영화 목록 중 원하는 영화를 선택하여 상세 정보를 볼 수 있습니다. 

또한 리뷰 작성 버튼을 클릭하여 한 줄 감상평을 남길 수 있습니다.

## Dependencies

* [ReactorKit](https://github.com/ReactorKit/ReactorKit)
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift)
* [RxViewController](https://github.com/devxoul/RxViewController)
* [RxGesture](https://github.com/RxSwiftCommunity/RxGesture)
* [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)
* iOS 15+
* Swift 5.5
* CocoaPods

## Features

### 1. Movie List Screen

![BoxOffice+ReactorKit1 001](https://user-images.githubusercontent.com/20268101/149631046-036315db-7965-4d96-88db-7aa7a317477c.jpeg)

| ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148557072-4f995086-118f-4520-ae19-5bf8c4066bb2.png) | ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148557066-0b8225b2-87d7-4868-89ec-489cf12c179f.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

### 2. Movie Information Screen

![BoxOffice+ReactorKit2 001](https://user-images.githubusercontent.com/20268101/149632752-c033a01d-7cd0-442f-8208-6439245ea155.jpeg)

| ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148557058-97e59393-1f7d-4f8d-a47d-afbfa3cbeb29.png) | ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148557057-f8a50ca7-56f0-4bb3-9dfe-36b49efc11c7.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

### 3. Review Writing Screen

![BoxOffice+ReactorKit3 001](https://user-images.githubusercontent.com/20268101/149631053-210bee63-f005-4321-8165-81cfa9def3bf.jpeg)

| ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148557053-99ee7777-fab5-4824-8579-1e81ed3e67f4.png) | ![120216339-dbd20800-c271-11eb-80ee-12759a44ca35](https://user-images.githubusercontent.com/20268101/148558801-c8a2ccc6-970e-46ac-aee4-45774d1041d5.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

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