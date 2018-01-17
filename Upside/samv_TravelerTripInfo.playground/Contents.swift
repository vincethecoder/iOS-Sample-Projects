/// Author: Vincent K. Sam
/// Date: 12/8/2017
/// Project: Upside Travlers Flight Info

import Foundation

struct Traveler {
    let id: Int
    let name: String
    let flights: [Legs]
}

struct Legs {
    let airlineCode: String
    let arlineName: String
    let flightNumber: String
    let frequentFlyerNumber: String
}

struct Trip {
    let travelerIds: [Int]
    let legs: [Leg]
}

struct Leg {
    let airlineCode: String
    let flightNumber: String
}

struct Airline: CustomStringConvertible {
    let code: String
    let name: String
    
    var description: String {
        return "\(code) : \(name)"
    }
}

struct Profile {
    let personId: Int
    let name: String
    let rewardPrograms: [Air]
}

struct Air {
    let data: [String:String]
}

/// - Error Handling
enum TravelerTripInfoError: Error, CustomStringConvertible {
    case noRecordFound

    var description: String {
        return "No Traveler Trip Info Record Found"
    }
}

func getTravelersFlightInfo(_ arlines: [Airline], _ profiles: [Profile], _ trips: [Trip]) throws -> [Traveler] {
    /// Safety check - we cannot proceed with operation if we're missing associated data
    guard arlines.count > 0 && profiles.count > 0 && trips.count > 0 else {
        throw TravelerTripInfoError.noRecordFound
    }
        
    var travelers = [Traveler]()
  
    for profile in profiles {

        let id = profile.personId
        let name = profile.name
        let flights = getFlights(for: profile, airlines: airlines, trips: trips)
        
        travelers.append(Traveler(id: id, name: name, flights: flights))
    }
    return travelers
}

func getFlights(for profile: Profile, airlines: [Airline], trips: [Trip]) -> [Legs] {
    var flights = [Legs]()
    let rewardPrograms = profile.rewardPrograms
    for rewardProgram in rewardPrograms {
        let legs = getLegs(for: profile.personId, trips: trips)
        for leg in legs {
            let airlineCode = leg.airlineCode
            let airlineName = getAirline(for: airlineCode, airlines: airlines)
            let flightNumber = leg.flightNumber
            let frequentFlyerNumber = rewardProgram.data[airlineCode] ?? ""
            let flightInfo = Legs(airlineCode: airlineCode, arlineName: airlineName, flightNumber: flightNumber, frequentFlyerNumber: frequentFlyerNumber)
            flights.append(flightInfo)
        }
    }
    return flights
}

func getAirline(for code: String, airlines: [Airline]) -> String {
    for airline in airlines {
        if airline.code == code {
            return airline.name
        }
    }
    return ""
}

func getLegs(for travelerId: Int, trips: [Trip]) -> [Leg] {
    var tripLegs = [Leg]()
    for trip in trips {
        if trip.travelerIds.contains(travelerId) {
            tripLegs += trip.legs
        }
    }
    return tripLegs
}

/// Traveler Data
/// - Airlines
let airlines = [
    Airline(code: "AK", name: "Alaskan"),
    Airline(code: "AA", name: "American"),
    Airline(code: "BA", name: "British"),
    Airline(code: "DT", name: "Delta"),
    Airline(code: "UA", name: "United"),
    Airline(code: "VA", name: "Virgin")
]
/// - Profiles
let profiles = [
    Profile(personId: 1, name: "Neo", rewardPrograms: [Air(data:["AK":"NAK123", "VA":"NVA123"])]),
    Profile(personId: 2, name: "Morpheus", rewardPrograms: [Air(data:["AA":"MAA123"])]),
    Profile(personId: 3, name: "Trinity", rewardPrograms: [Air(data:["VA":"TVA123"])]),
    Profile(personId: 4, name: "Mr. Anderson", rewardPrograms: [Air(data:["AA":"AAA444", "AK":"AAK444", "VA":"AVA444"])])
]
/// - Trips
let trips = [
    Trip(travelerIds: [1,2,3], legs: [Leg(airlineCode:"AA", flightNumber:"AA456")]),
    Trip(travelerIds: [1,2], legs: [Leg(airlineCode:"VA", flightNumber:"VA789"), Leg(airlineCode:"AK", flightNumber:"AA789")])
]

do {
    print(try getTravelersFlightInfo(airlines, profiles, trips))
    print(try getTravelersFlightInfo([], profiles, trips))
} catch {
    print(error)
}

