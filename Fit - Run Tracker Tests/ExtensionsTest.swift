//
//  ExtensionsTest.swift
//  Fit - Run Tracker Tests
//
//  Created by William Ray on 30/03/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import XCTest
@testable import Fit___Run_Tracker

class ExtensionsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: NSDate

    func test_givenShortDateString_whenInitialisingDate_thenDateIsCorrect() {
        let dateString = "07/06/2014"

        let dateRes = NSDate(shortDateString: dateString)
        let expectDate = NSDate(timeIntervalSince1970: 1402099200)

        XCTAssertEqual(dateRes, expectDate)
    }

    func test_givenDatabaseDateString_whenInitialisingDate_thenDateIsCorrect() {
        let dateString = "07/06/201417:54:23"

        let dateRes = NSDate(databaseString: dateString)
        let expectDate = NSDate(timeIntervalSince1970: 1402163663)

        XCTAssertEqual(dateRes, expectDate)
    }

    func test_givenDate_whenConvertingToShortString_thenStringIsCorrect() {
        let date = NSDate(timeIntervalSince1970: 1402099200)

        let stringRes = date.databaseString()
        let expectString = "07/06/2014"

        XCTAssertEqual(stringRes, expectString)
    }

    func test_givenDate_whenConvertingToDatabaseString_thenStringIsCorrect() {
        let date = NSDate(timeIntervalSince1970: 1402163663)

        let stringRes = date.databaseString()
        let expectString = "07/06/201417:54:23"

        XCTAssertEqual(stringRes, expectString)
    }

    func test_givenDate_whenConvertingToShortestString_thenStringIsCorrect() {
        let date = NSDate(timeIntervalSince1970: 1402099200)

        let stringRes = date.databaseString()
        let expectString = "07/06/14"

        XCTAssertEqual(stringRes, expectString)
    }

    func test_givenDate_whenConvertingToMonthYear_thenStringIsCorrect() {
        let date = NSDate(timeIntervalSince1970: 1402099200)

        let stringRes = date.databaseString()
        let expectString = "06/2014"

        XCTAssertEqual(stringRes, expectString)
    }

    func test_givenDate_whenConvertingTo12HourTimeString_thenStringIsCorrect() {
        let date = NSDate(timeIntervalSince1970: 1402163663)

        let stringRes = date.databaseString()
        let expectString = "05:54 pm"

        XCTAssertEqual(stringRes, expectString)
    }

    func test_givenTodaysDate_whenCheckingIfIsToday_thenReturnsTrue() {
        let date = NSDate(timeIntervalSinceNow: 0)

        XCTAssertTrue(date.isToday())
    }

    func test_givenYesterdaysDate_whenCheckingIfIsToday_thenReturnsFalse() {
        let date = NSDate(timeIntervalSinceNow: -86400)

        XCTAssertFalse(date.isToday())
    }

    func test_givenYesterdaysDate_whenCheckingIfIsYesterday_thenReturnsTrue() {
        let date = NSDate(timeIntervalSinceNow: -86400)

        XCTAssertTrue(date.isYesterday())
    }

    func test_givenTodaysDate_whenCheckingIfIsYesterday_thenReturnsFalse() {
        let date = NSDate(timeIntervalSinceNow: 0)

        XCTAssertFalse(date.isYesterday())
    }

    // MARK: CLLocation

    func test_givenLatLongString_whenUsedToInitialiseCLLocation_thenLocationIsCorrect() {
        let latLong = "51.5033° N, 0.1195° W"
        let loc = CLLocation(locationString: latLong)

        XCTAssertEqual(loc.coordinate.latitude, 51.5033, accuracy: 0.0001)
        XCTAssertEqual(loc.coordinate.longitude, 0.1195, accuracy: 0.0001)
    }

    // MARK: String

    func test_givenValidString_whenValidated_thenReturnsTrue() {
        let string = "Fo0.Bar?!"

        XCTAssertTrue(string.validateString(stringName: "test", maxLength: 40, minLength: 3).valid)
    }

    func test_givenTooShortString_whenValidated_thenReturnsFalse() {
        let string = "short"

        XCTAssertFalse(string.validateString(stringName: "test", maxLength: 40, minLength: 10).valid)
    }

    func test_givenTooLongString_whenValidated_thenReturnsFalse() {
        let string = "toolong"

        XCTAssertFalse(string.validateString(stringName: "test", maxLength: 4, minLength: 3).valid)
    }

    func test_givenStringDoesntMatchFormat_whenValidated_thenReturnsFalse() {
        let string = "oh no, I don't match!"

        XCTAssertFalse(string.validateString(stringName: "test", maxLength: 40, minLength: 3).valid)
    }

    // MARK: HKHealthStore

    // TODO: these tests were skipped.
}