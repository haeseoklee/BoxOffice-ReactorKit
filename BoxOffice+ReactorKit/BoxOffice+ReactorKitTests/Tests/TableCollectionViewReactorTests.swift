//
//  BoxOffice_ReactorKitTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/21.
//

import XCTest
@testable import BoxOffice_ReactorKit

class TableCollectionViewReactorTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testAction_refresh() {
        // given
        let movieService = MovieService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        reactor.isStubEnabled = true
        
        let view = TableViewController()
        
        // when
        
        
        
        // then
    }

}
