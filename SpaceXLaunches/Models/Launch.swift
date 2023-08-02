//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import Foundation

struct Launch: Identifiable, Codable {
    let fairings: Fairings?
    let links: Links?
    let staticFireDateUtc: String?
    let staticFireDateUnix: Int?
    let net: Bool?
    let window: Int?
    let rocket: String?
    let success: Bool?
    let failures: [Failures]?
    let details: String?
    let crew: [Crew]?
    let ships: [String]?
    let capsules: [String]?
    let payloads: [String]?
    let launchpad: String?
    let flightNumber: Int?
    let name: String?
    let dateUtc: String?
    let dateUnix: Int?
    let dateLocal: String?
    let datePrecision: String?
    let upcoming: Bool?
    let cores: [Cores]?
    let autoUpdate: Bool?
    let tbd: Bool?
    let launchLibraryId: String?
    let id: String?
}

#if DEBUG
// MARK: - Example Launch
extension Launch {
    
    static var example: Launch {

        Launch(
            fairings: nil,
            links:
                Links(patch: Patch(small: "https://images2.imgbox.com/ef/36/h10Ds3kT_o.png",
                                   large: "https://images2.imgbox.com/ab/12/2cQPNTCZ_o.png"),
                      reddit: Reddit(campaign: "https://www.reddit.com/r/spacex/comments/fxkc7k/starlink6_launch_campaign_thread/",
                                     launch: "https://www.reddit.com/r/spacex/comments/g5jmx0/rspacex_starlink_6_official_launch_discussion/",
                                     media: "https://www.reddit.com/r/spacex/comments/g5fqka/rspacex_starlink6_media_thread_photographer/",
                                     recovery: "https://www.reddit.com/r/spacex/comments/g6kztd/rspacex_starlink_v1_l6_recovery_discussion/"),
                      flickr: Flickr(small: [],
                                     original: [
                                        "https://live.staticflickr.com/65535/49673373182_93a517e140_o.jpg",
                                        "https://live.staticflickr.com/65535/49672551378_fabc17ef6f_o.jpg",
                                        "https://live.staticflickr.com/65535/49672551303_564ce21658_o.jpg",
                                        "https://live.staticflickr.com/65535/49806771628_fef13c852d_o.jpg",
                                        "https://live.staticflickr.com/65535/49807633862_e5abcb41a6_o.jpg"
                                     ]),
                      presskit: nil,
                      webcast: nil,
                      youtubeId: nil,
                      article: nil,
                      wikipedia: nil),
            staticFireDateUtc: "2020-05-22T17:39:00.000Z",
            staticFireDateUnix: nil,
            net: nil,
            window: nil,
            rocket: "5e9d0d95eda69973a809d1ec",
            success: true,
            failures: [],
            details: "SpaceX will launch the second demonstration mission of its Crew Dragon vehicle as part of NASA's Commercial Crew Transportation Capability Program (CCtCap), carrying two NASA astronauts to the International Space Station. Barring unexpected developments, this mission will be the first crewed flight to launch from the United States since the end of the Space Shuttle program in 2011. DM-2 demonstrates the Falcon 9 and Crew Dragon's ability to safely transport crew to the space station and back to Earth and it is the last major milestone for certification of Crew Dragon. Initially the mission duration was planned to be no longer than two weeks, however NASA has been considering an extension to as much as six weeks or three months. The astronauts have been undergoing additional training for the possible longer mission.",
            crew: [
                Crew(crew: "5ebf1a6e23a9a60006e03a7a", role: "Joint Commander"),
                Crew(crew: "5ebf1b7323a9a60006e03a7b", role: "Commander"),
            ],
            ships: [
                "5ea6ed30080df4000697c913",
                "5ea6ed2f080df4000697c90b",
                "5ea6ed2f080df4000697c90c",
                "5ea6ed2e080df4000697c909",
                "5ea6ed2f080df4000697c90d"
            ],
            capsules: [
                "5e9e2c5df359188aba3b2676"
            ],
            payloads: [
                "5eb0e4d1b6c3bb0006eeb257"
            ],
            launchpad: "5e9e4502f509094188566f88",
            flightNumber: 94,
            name: "CCtCap Demo Mission 2",
            dateUtc: "2020-05-30T19:22:00.000Z",
            dateUnix: 1590866520,
            dateLocal: "2020-05-30T15:22:00-04:00",
            datePrecision: "hour",
            upcoming: false,
            cores: [
                Cores(core: "5e9e28a7f3591817f23b2663",
                      flight: 1,
                      gridfins: true,
                      legs: true,
                      reused: false,
                      landingAttempt: true,
                      landingSuccess: true,
                      landingType: "ASDS",
                      landpad: "5e9e3032383ecb6bb234e7ca")
            ],
            autoUpdate: true,
            tbd: false,
            launchLibraryId: nil,
            id: "5eb87d46ffd86e000604b388"
        )
    }
}
#endif
