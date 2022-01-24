//
//  MockImageLoaderService.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import Foundation
@testable import BoxOffice_ReactorKit

import RxSwift

final class MockImageLoaderService: ImageLoaderServiceType {
    func load(url: String) -> Observable<UIImage> {
        switch url {
        case "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2":
            return Observable.just(UIImage(named: "img_placeholder")!)
        default:
            return Observable.create { observer in
                observer.onError(ImageLoaderError.invalidURL)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
