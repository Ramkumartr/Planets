//
//  PlanetsViewModelTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 03/05/23.
//

import XCTest
@testable import Planets

class PlanetsViewModelTests: XCTestCase {
    
    fileprivate enum FetchPlanetsUseCaseError: Error {
        case someError
    }
    
    let planetsPage: PlanetsPage = {
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        let planet2 = Planet(name: "Tatooine2", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/2/")
        return PlanetsPage(count: 1, next: "https://swapi.dev/api/planets/?page=2", previous: nil, results: [planet1, planet2])}()
    
    
    class FetchPlanetsUseCaseMock: FetchPlanetsUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var planetsPage:PlanetsPage?
        
        func execute(requestValue: FetchPlanetsUseCaseRequestValue,
                     cached: @escaping (PlanetsPage) -> Void,
                     completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else if let planetsPage = planetsPage  {
                completion(.success(planetsPage))
            } else {
                completion(.failure(FetchPlanetsUseCaseError.someError))
            }
            expectation?.fulfill()
            return nil
            
        }
    }
    
    func test_whenFetchPlanetsUseCaseRetrivesTwoPlanets_thenViewModelContainsOnlyTwoPlanets() {
        // given
        let fetchPlanetsUseCaseMock = FetchPlanetsUseCaseMock()
        fetchPlanetsUseCaseMock.expectation = self.expectation(description: "contains only two planets")
        fetchPlanetsUseCaseMock.planetsPage = planetsPage
        
        let viewModel = DefaultPlanetsViewModel(fetchPlanetsUseCase: fetchPlanetsUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.planets.value.map { $0.name }, planetsPage.results.map { $0.name })
        XCTAssertEqual(viewModel.planets.value.count, 2)
    }
    
    func test_whenFetchPlanetsUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let fetchPlanetsUseCaseMock = FetchPlanetsUseCaseMock()
        fetchPlanetsUseCaseMock.expectation = self.expectation(description: "contains error")
        fetchPlanetsUseCaseMock.error = FetchPlanetsUseCaseError.someError
        let viewModel = DefaultPlanetsViewModel(fetchPlanetsUseCase: fetchPlanetsUseCaseMock)

        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Failed loading planets from network")
        XCTAssertEqual(viewModel.planets.value.count, 0)
    }
}
