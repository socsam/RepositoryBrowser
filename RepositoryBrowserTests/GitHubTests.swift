//
//  GitHubTests.swift
//  RepositoryBrowserTests
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import XCTest
@testable import RepositoryBrowser


class GitHubTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRepository() {
        guard let data = readJSONFromFile("repositories", ofType: "json") else {
            XCTFail("Could not read file repositories.json")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let repositories = try decoder.decode([GitHubRepository].self, from: data)
            
            XCTAssertTrue(repositories.count > 0)
            let repo = repositories.first!
            XCTAssertEqual(repo.name, ".github")
            XCTAssertEqual(repo.starsCount, 0)
            XCTAssertEqual(repo.forksCount, 0)
        } catch {
            print(error)
            XCTFail("Can't parse repositories.json")
        }

    }
    
    func testUser() {
        guard let data = readJSONFromFile("user", ofType: "json") else {
            XCTFail("Could not read file user.json")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let user = try decoder.decode(GitHubUser.self, from: data)
            XCTAssertEqual(user.id, 47313)
            XCTAssertEqual(user.login, "fabpot")
            XCTAssertEqual(user.publicRepos, 42)
            XCTAssertEqual(user.avatarUrl, "https://avatars3.githubusercontent.com/u/47313?v=4")
            XCTAssertEqual(user.followers, 10095)
            XCTAssertEqual(user.following, 0)
            XCTAssertNil(user.bio)
            XCTAssertNil(user.email)
            XCTAssertNotNil(user.createdAt)
            
            let createdDate = getDateFormatter().string(from: user.createdAt!)
            XCTAssertEqual(createdDate, "2009-01-17T13:42:51Z")

        } catch {
            print(error)
            XCTFail("Can't parse user.json")
        }
    }
    
    func testUsersList() {
        guard let data = readJSONFromFile("users_list", ofType: "json") else {
            XCTFail("Could not read file users_list.json")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let list = try decoder.decode(GitHubUserList.self, from: data)
            XCTAssertEqual(list.totalCount, 2483)
            XCTAssertEqual(list.incompleteResults, false)
            
            XCTAssertNotNil(list.users)
            XCTAssertTrue(list.users!.count > 0)
            let user = list.users!.first!
            XCTAssertEqual(user.id, 2749)
            XCTAssertEqual(user.login, "fabien")
            XCTAssertEqual(user.avatarUrl, "https://avatars1.githubusercontent.com/u/2749?v=4")
        } catch {
            print(error)
            XCTFail("Can't parse users_list.json")
        }
    }
    

    
    private func getDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone, .withFullTime]
        return formatter
    }

    func readJSONFromFile(_ filename: String, ofType fileType: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: filename, ofType: fileType) {
            return try? Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            return nil
        }
    }

}

