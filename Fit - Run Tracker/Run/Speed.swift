//
//  Speed.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

protocol SpeedUnit {}

enum MetresPerSecond: SpeedUnit {
    case unit
}

enum KilometresPerHour: SpeedUnit {
    case unit
}

enum MinutesPerMile: SpeedUnit {
    case unit
}

enum SecondsPerMile: SpeedUnit {
    case unit
}

enum MilesPerHour: SpeedUnit {
    case unit
}

final class Speed<U: SpeedUnit>: UnitPreservingArithmetic {
    typealias SUnit = U

    var rawValue: Double

    required init(rawValue: Double) {
        self.rawValue = rawValue
    }

    init(_ speed: Double) {
        self.rawValue = speed
    }
}

extension Speed where U == SecondsPerMile {

    func toMinutesPerMile() -> Speed<MinutesPerMile> {
        return Speed<MinutesPerMile>(self.rawValue / 60)
    }

}

extension Speed where U == MinutesPerMile {

    func toString(_ unit: SpeedUnit) -> String {
        if unit is MinutesPerMile {
            let minutes = Int(self.rawValue)
            let seconds = Int((self.rawValue - floor(self.rawValue)) * 60)
            return (NSString(format: "%02i:%02i", minutes, seconds) as String) + " min/mile"
        }

        if unit is KilometresPerHour {
            let mph = 60.0 / self.rawValue
            let kmh = Double(mph) * Conversions.milesToKm
            return (NSString(format: "%1.2f", kmh) as String) + " km/h"
        }

        return "Unsupported unit."
    }

}

extension Double {

    var secondsPerMile: Speed<SecondsPerMile> {
        return Speed<SecondsPerMile>(self)
    }

    var minutesPerMile: Speed<MinutesPerMile> {
        return Speed<MinutesPerMile>(self)
    }

    var kph: Speed<KilometresPerHour> {
        return Speed<KilometresPerHour>(self)
    }

}

extension Int {

    var secondsPerMile: Speed<SecondsPerMile> {
        return Double(self).secondsPerMile
    }

    var minutesPerMile: Speed<MinutesPerMile> {
        return Double(self).minutesPerMile
    }

    var kph: Speed<KilometresPerHour> {
        return Double(self).kph
    }

}
