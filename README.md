# LSJCurrencyCalculator
내일배움캠프 iOS 마스터 6기 Chapter 4  환율 계산기

## 사용 라이브러리
라이브러리 | 사용 목적 | Management Tool
:---------:|:----------:|:---------:
SnapKit | UI Layout | SPM
Then | UI 선언 | SPM
Alamofire | HTTP 네트워크 | SPM

## 폴더구조
# 📁 프로젝트 폴더 구조

```
LSJCurrencyCalculator
└── LSJCurrencyCalculator
    ├── App
    │   ├── Manager
    │   │   ├── NavigationManager.swift
    │   │   ├── RepositoryManager.swift
    │   │   └── UseCaseManager.swift
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    │
    ├── Data
    │   ├── Coredata
    │   │   ├── SubClasses
    │   │   │   ├── CachedCurrency+CoreDataClass.swift
    │   │   │   ├── CachedCurrency+CoreDataProperties.swift
    │   │   │   ├── FavoriteCurrency+CoreDataClass.swift
    │   │   │   ├── FavoriteCurrency+CoreDataProperties.swift
    │   │   │   ├── LastView+CoreDataClass.swift
    │   │   │   └── LastView+CoreDataProperties.swift
    │   │   └── CurrencyCoreData.xcdatamodeld
    │   └── Network
    │       ├── DTOs
    │       │   └── ExchangeRateDTO.swift
    │       ├── AlamofireAPIClient.swift
    │       ├── Endpoint.swift
    │       ├── URLSessionAPIClient.swift
    │       └── Repository
    │           ├── CachedCurrencyRepository.swift
    │           ├── CurrencyItemRepository.swift
    │           ├── FavoriteCurrencyRepository.swift
    │           ├── FileCurrencyItemRepository.swift
    │           └── LastViewRepository.swift
    │
    ├── Domain
    │   ├── Entities
    │   │   ├── CurrencyItem.swift
    │   │   └── LastViewItem.swift
    │   ├── RepositoryProtocols
    │   │   ├── APIClientProtocol.swift
    │   │   ├── CachedCurrencyRepositoryProtocol.swift
    │   │   ├── CurrencyItemRepositoryProtocol.swift
    │   │   ├── FavoriteCurrencyRepositoryProtocol.swift
    │   │   └── LastViewItemRepositoryProtocol.swift
    │   └── UseCases
    │       ├── CachedCurrencyUseCase.swift
    │       ├── CurrencyItemUseCase.swift
    │       ├── FavoriteCurrencyUseCase.swift
    │       └── LastViewItemUseCase.swift
    │
    ├── Presentation
    │   ├── Calculator
    │   │   ├── View
    │   │   │   └── CalculatorViewController.swift
    │   │   └── ViewModel
    │   │       └── CalculatorViewModel.swift
    │   ├── Common
    │   │   └── ViewModelProtocol.swift
    │   └── Exchange
    │       ├── View
    │       │   ├── ViewComponents
    │       │   │   └── ExchangeRateTableViewCell.swift
    │       │   └── ExchangeRateViewController.swift
    │       └── ViewModel
    │           └── ExchangeRateViewModel.swift
    │
    ├── Resource
    │   ├── Assets.xcassets
    │   └── sample.json
    │
    ├── Storyboard
    │   └── LaunchScreen.storyboard
    │
    ├── Utility
    │   ├── Constants
    │   │   └── CurrencyCountryMapper.swift
    │   └── Extensions
    │       ├── UIColor+.swift
    │       ├── UIStackView+.swift
    │       └── UIView+.swift
    │
    └── Info.plist
```

## 과제

### 필수 과제
[Level1](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/1), 
[Level2](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/2), 
[Level3](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/3), 
[Level4](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/4), 
[Level5](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/5)

[Level6](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/6), 
[Level7](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/7), 
[Level8](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/8), 
[Level9](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/10), 
[Level10](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/10)

### 도전 과제
[Level11](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/14), 
[Level12](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/12)

### 추가 과제
[Task 1 : 오토레이아웃을 포함한 UI 디버깅 상황 중 Xcode 툴을 사용하여 문제 정의 + 문제 해결한 사례에 대해 그 해결 과정에 대해 기록](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/14)

[Task 2 : 메모리 이슈 디버깅 및 개선 경험 문서화](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/15)

[Task 3 : Clean Architecture + MVVM 패턴 적용](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/16)

[Task 4 : XCTest Unit Test 진행](https://github.com/nbcampMasterChapter4Team7/LSJCurrencyCalculator/issues/17)
