//
//  MockDataService.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-04.
//

import Foundation
import Combine

class MockDataService { //: CrewDataServiceProtocol, LaunchesDataServiceProtocol {
    
    @Published var crew = [CrewMember] ()
    @Published var launches = [Launch] ()
    
    var crewPublisher: Published<[CrewMember]>.Publisher { $crew }
    var launchesPublisher: Published<[Launch]>.Publisher { $launches }

    private var crewSubscription: AnyCancellable?
    private var launchesSubscription: AnyCancellable?
    
    init() {
        loadCrew()
        loadLaunches()
    }
    
    func loadCrew() {
        let data = MockDataService.crewJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        crewSubscription = Just(data)
            .decode(type: [CrewMember].self, decoder: NetworkingManager.defaultDecoder())
            .delay(for: 1.5, scheduler: RunLoop.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.crew = receivedData
                self?.crewSubscription?.cancel()
            })
    }
    
    func loadLaunches() {
        let data = MockDataService.launchesJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        launchesSubscription = Just(data)
            .decode(type: [Launch].self, decoder: NetworkingManager.defaultDecoder())
            .delay(for: 1.5, scheduler: RunLoop.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.launches = receivedData
                self?.crewSubscription?.cancel()
            })
    }

}

// MARK: - data for testing
extension MockDataService {
    
    static func crewMember(random: Bool = false) -> CrewMember {
        let data = crewJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let result = try! NetworkingManager.defaultDecoder().decode([CrewMember].self, from: data)
        return random ? result.randomElement()! : result.first!
    }
}

// MARK: - JSON data
extension MockDataService {
    
    private static var crewJSON: String {
        return """
    [
    {
    "name": "Robert Behnken",
    "agency": "NASA",
    "image": "https://imgur.com/0smMgMH.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Robert_L._Behnken",
    "launches": [
    "5eb87d46ffd86e000604b388"
    ],
    "status": "active",
    "id": "5ebf1a6e23a9a60006e03a7a"
    },
    {
    "name": "Douglas Hurley",
    "agency": "NASA",
    "image": "https://i.imgur.com/ooaayWf.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Douglas_G._Hurley",
    "launches": [
    "5eb87d46ffd86e000604b388"
    ],
    "status": "active",
    "id": "5ebf1b7323a9a60006e03a7b"
    },
    {
    "name": "Shannon Walker",
    "agency": "NASA",
    "image": "https://imgur.com/9z4tRIO.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Shannon_Walker",
    "launches": [
    "5eb87d4dffd86e000604b38e"
    ],
    "status": "active",
    "id": "5f7f1543bf32c864a529b23e"
    },
    {
    "name": "Soichi Noguchi",
    "agency": "JAXA",
    "image": "https://imgur.com/7B1jxl8.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Soichi_Noguchi",
    "launches": [
    "5eb87d4dffd86e000604b38e"
    ],
    "status": "active",
    "id": "5f7f158bbf32c864a529b23f"
    },
    {
    "name": "Victor J. Glover",
    "agency": "NASA",
    "image": "https://imgur.com/Vv5Hgzh.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Victor_J._Glover",
    "launches": [
    "5eb87d4dffd86e000604b38e"
    ],
    "status": "active",
    "id": "5f7f15d5bf32c864a529b240"
    },
    {
    "name": "Michael S. Hopkins",
    "agency": "NASA",
    "image": "https://imgur.com/Dfg8OJ2.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Michael_S._Hopkins",
    "launches": [
    "5eb87d4dffd86e000604b38e"
    ],
    "status": "active",
    "id": "5f7f1614bf32c864a529b241"
    },
    {
    "name": "Shane Kimbrough",
    "agency": "NASA",
    "image": "https://imgur.com/nwxqtcT.png",
    "wikipedia": "https://en.wikipedia.org/wiki/Shane_Kimbrough",
    "launches": [
    "5fe3af58b3467846b324215f"
    ],
    "status": "active",
    "id": "5fe3ba5fb3467846b3242188"
    }
    ]
    """
    }
    
    private static var launchesJSON: String {
        return """
    [
    {
    "fairings": {
    "reused": false,
    "recovery_attempt": false,
    "recovered": false,
    "ships": []
    },
    "links": {
    "patch": {
    "small": "https://images2.imgbox.com/94/f2/NN6Ph45r_o.png",
    "large": "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png"
    },
    "reddit": {
    "campaign": null,
    "launch": null,
    "media": null,
    "recovery": null
    },
    "flickr": {
    "small": [],
    "original": []
    },
    "presskit": null,
    "webcast": "https://www.youtube.com/watch?v=0a_00nJ_Y88",
    "youtube_id": "0a_00nJ_Y88",
    "article": "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html",
    "wikipedia": "https://en.wikipedia.org/wiki/DemoSat"
    },
    "static_fire_date_utc": "2006-03-17T00:00:00.000Z",
    "static_fire_date_unix": 1142553600,
    "net": false,
    "window": 0,
    "rocket": "5e9d0d95eda69955f709d1eb",
    "success": false,
    "failures": [
    {
    "time": 33,
    "altitude": null,
    "reason": "merlin engine failure"
    }
    ],
    "details": "Engine failure at 33 seconds and loss of vehicle",
    "crew": [],
    "ships": [],
    "capsules": [],
    "payloads": [
    "5eb0e4b5b6c3bb0006eeb1e1"
    ],
    "launchpad": "5e9e4502f5090995de566f86",
    "flight_number": 1,
    "name": "FalconSat",
    "date_utc": "2006-03-24T22:30:00.000Z",
    "date_unix": 1143239400,
    "date_local": "2006-03-25T10:30:00+12:00",
    "date_precision": "hour",
    "upcoming": false,
    "cores": [
    {
    "core": "5e9e289df35918033d3b2623",
    "flight": 1,
    "gridfins": false,
    "legs": false,
    "reused": false,
    "landing_attempt": false,
    "landing_success": null,
    "landing_type": null,
    "landpad": null
    }
    ],
    "auto_update": true,
    "tbd": false,
    "launch_library_id": null,
    "id": "5eb87cd9ffd86e000604b32a"
    },
    {
    "fairings": {
    "reused": false,
    "recovery_attempt": false,
    "recovered": false,
    "ships": []
    },
    "links": {
    "patch": {
    "small": "https://images2.imgbox.com/f9/4a/ZboXReNb_o.png",
    "large": "https://images2.imgbox.com/80/a2/bkWotCIS_o.png"
    },
    "reddit": {
    "campaign": null,
    "launch": null,
    "media": null,
    "recovery": null
    },
    "flickr": {
    "small": [],
    "original": []
    },
    "presskit": null,
    "webcast": "https://www.youtube.com/watch?v=Lk4zQ2wP-Nc",
    "youtube_id": "Lk4zQ2wP-Nc",
    "article": "https://www.space.com/3590-spacex-falcon-1-rocket-fails-reach-orbit.html",
    "wikipedia": "https://en.wikipedia.org/wiki/DemoSat"
    },
    "static_fire_date_utc": null,
    "static_fire_date_unix": null,
    "net": false,
    "window": 0,
    "rocket": "5e9d0d95eda69955f709d1eb",
    "success": false,
    "failures": [
    {
    "time": 301,
    "altitude": 289,
    "reason": "harmonic oscillation leading to premature engine shutdown"
    }
    ],
    "details": "Successful first stage burn and transition to second stage, maximum altitude 289 km, Premature engine shutdown at T+7 min 30 s, Failed to reach orbit, Failed to recover first stage",
    "crew": [],
    "ships": [],
    "capsules": [],
    "payloads": [
    "5eb0e4b6b6c3bb0006eeb1e2"
    ],
    "launchpad": "5e9e4502f5090995de566f86",
    "flight_number": 2,
    "name": "DemoSat",
    "date_utc": "2007-03-21T01:10:00.000Z",
    "date_unix": 1174439400,
    "date_local": "2007-03-21T13:10:00+12:00",
    "date_precision": "hour",
    "upcoming": false,
    "cores": [
    {
    "core": "5e9e289ef35918416a3b2624",
    "flight": 1,
    "gridfins": false,
    "legs": false,
    "reused": false,
    "landing_attempt": false,
    "landing_success": null,
    "landing_type": null,
    "landpad": null
    }
    ],
    "auto_update": true,
    "tbd": false,
    "launch_library_id": null,
    "id": "5eb87cdaffd86e000604b32b"
    }
    ]
    """
    }
}
