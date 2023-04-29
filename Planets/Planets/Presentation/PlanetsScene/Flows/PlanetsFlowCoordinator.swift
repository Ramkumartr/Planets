//
//  PlanetsFlowCoordinator.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

protocol PlanetsFlowCoordinatorDependencies  {
    func makePlanetsViewController(actions: PlanetsViewModelActions) -> PlanetsViewController
}

final class PlanetsFlowCoordinator {
    
    private let router: Router
    private let dependencies: PlanetsFlowCoordinatorDependencies
    
    private weak var planetsViewController: PlanetsViewController?
    
    init(router: Router,
         dependencies: PlanetsFlowCoordinatorDependencies) {
        self.router = router
        self.dependencies = dependencies
    }
    
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        print("start PlanetsFlowCoordinator")
        let actions = PlanetsViewModelActions(showPlanetDetails: showPlanetDetails)
        let vc = dependencies.makePlanetsViewController(actions: actions)
        router.push(vc, animated: true)
        planetsViewController = vc
    }
    
    
    private func showPlanetDetails(planet: Planet) {
        
    }
    
    //    private func backAction() {
    //        router?.popModule()
    //    }
}
