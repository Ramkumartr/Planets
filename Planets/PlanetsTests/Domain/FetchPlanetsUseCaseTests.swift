//
//  FetchPlanetsUseCaseTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 02/05/23.
//

import XCTest


class FetchPlanetsUseCaseTests: XCTestCase {
    
    
    static let planetsPage: PlanetsPage = {
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        let planet2 = Planet(name: "Tatooine2", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/2/")
        return PlanetsPage(count: 1, next: "https://swapi.dev/api/planets/?page=2", previous: nil, results: [planet1, planet2])}()
    
    
    enum PlanetsRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    struct PlanetsRepositoryMock: PlanetsRepository {
        var result: Result<PlanetsPage, Error>
        
        func fetchPlanets(query: PlanetsQueryModel,
                          cached: @escaping (PlanetsPage) -> Void,
                          completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    func testFetchPlanetsUseCase_whenSuccessfullyFetchesPlanets() {
        // given
        let expectation = self.expectation(description: "Fetched Planets")
        let planetsRepository = PlanetsRepositoryMock(result: .success(FetchPlanetsUseCaseTests.planetsPage))
        let fetchPlanetUseCase = DefaultFetchPlanetsUseCase(planetsRepository: planetsRepository)
        //When
        let requestValue = FetchPlanetsUseCaseRequestValue(query: PlanetsQueryModel(page: "1"))
        
        //then
        var planetsPage: PlanetsPage?
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        _ = fetchPlanetUseCase.execute(requestValue: requestValue) { _ in } completion: { result in
            planetsPage = (try? result.get())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(planetsPage)
        XCTAssertTrue(planetsPage!.results.contains(where: {$0 == planet1}))
    }
    
    
    func testFetchPlanetsUseCase_whenFailedFetchingPlanets() {
        // given
        let expectation = self.expectation(description: "Fetched Planets")
        let planetsRepository = PlanetsRepositoryMock(result: .failure(PlanetsRepositorySuccessTestError.failedFetching))
        let fetchPlanetUseCase = DefaultFetchPlanetsUseCase(planetsRepository: planetsRepository)
        //When
        let requestValue = FetchPlanetsUseCaseRequestValue(query: PlanetsQueryModel(page: "1"))
        
        //then
        var planetsPage: PlanetsPage?
        var errorNow: PlanetsRepositorySuccessTestError?
        _ = fetchPlanetUseCase.execute(requestValue: requestValue) { _ in } completion: { result in
            
            do {
                planetsPage = try result.get()
            } catch {
                errorNow = error as? PlanetsRepositorySuccessTestError
            }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(planetsPage)
        XCTAssertEqual(errorNow, PlanetsRepositorySuccessTestError.failedFetching)
    }
}
