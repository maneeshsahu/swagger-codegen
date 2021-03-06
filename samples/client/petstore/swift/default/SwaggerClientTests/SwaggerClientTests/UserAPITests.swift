//
//  UserAPITests.swift
//  SwaggerClient
//
//  Created by Robin Eggenkamp on 5/21/16.
//  Copyright © 2016 Swagger. All rights reserved.
//

import PetstoreClient
import XCTest
@testable import SwaggerClient

class UserAPITests: XCTestCase {
    
    let testTimeout = 10.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        let expectation = self.expectationWithDescription("testLogin")
        
        UserAPI.loginUser(username: "swiftTester", password: "swift") { (_, error) in
            // The server isn't returning JSON - and currently the alamofire implementation
            // always parses responses as JSON, so making an exception for this here
            // Error Domain=NSCocoaErrorDomain Code=3840 "Invalid value around character 0."
            // UserInfo={NSDebugDescription=Invalid value around character 0.}
            guard let error = error where error._code == 3840 else {
                XCTFail("error logging in")
                return
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func testLogout() {
        let expectation = self.expectationWithDescription("testLogout")
        
        UserAPI.logoutUser { (error) in
            // The server gives us no data back so Alamofire parsing fails - at least
            // verify that is the error we get here
            // Error Domain=com.alamofire.error Code=-6006 "JSON could not be serialized. Input data was nil or zero
            // length." UserInfo={NSLocalizedFailureReason=JSON could not be serialized. Input data was nil or zero
            // length.}
            guard let error = error where error._code == -6006 else {
                XCTFail("error logging out")
                return
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func test1CreateUser() {
        let expectation = self.expectationWithDescription("testCreateUser")
        
        let newUser = User()
        newUser.email = "test@test.com"
        newUser.firstName = "Test"
        newUser.lastName = "Tester"
        newUser.id = 1000
        newUser.password = "test!"
        newUser.phone = "867-5309"
        newUser.username = "test@test.com"
        newUser.userStatus = 0
        
        UserAPI.createUser(body: newUser) { (error) in
            // The server gives us no data back so Alamofire parsing fails - at least
            // verify that is the error we get here
            // Error Domain=com.alamofire.error Code=-6006 "JSON could not be serialized. Input data was nil or zero
            // length." UserInfo={NSLocalizedFailureReason=JSON could not be serialized. Input data was nil or zero
            // length.}
            guard let error = error where error._code == -6006 else {
                XCTFail("error creating user")
                return
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func test2GetUser() {
        let expectation = self.expectationWithDescription("testGetUser")
        
        UserAPI.getUserByName(username: "test@test.com") { (user, error) in
            guard error == nil else {
                XCTFail("error getting user")
                return
            }
            
            if let user = user {
                XCTAssert(user.userStatus == 0, "invalid userStatus")
                XCTAssert(user.email == "test@test.com", "invalid email")
                XCTAssert(user.firstName == "Test", "invalid firstName")
                XCTAssert(user.lastName == "Tester", "invalid lastName")
                XCTAssert(user.password == "test!", "invalid password")
                XCTAssert(user.phone == "867-5309", "invalid phone")
                
                expectation.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func test3DeleteUser() {
        let expectation = self.expectationWithDescription("testDeleteUser")
        
        UserAPI.deleteUser(username: "test@test.com") { (error) in
            // The server gives us no data back so Alamofire parsing fails - at least
            // verify that is the error we get here
            // Error Domain=com.alamofire.error Code=-6006 "JSON could not be serialized. Input data was nil or zero
            // length." UserInfo={NSLocalizedFailureReason=JSON could not be serialized. Input data was nil or zero
            // length.}
            guard let error = error where error._code == -6006 else {
                XCTFail("error deleting user")
                return
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

}
