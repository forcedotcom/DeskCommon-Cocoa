//
//  DSCKeychainTests.m
//  DeskCommon
//
//  Created by Jamie Forrest on 1/14/15.
//  Copyright (c) 2015 Desk.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <DeskCommon/DSCKeychain.h>

static NSString *const DSCTestKeychainServiceName = @"TestKeychainService";

@interface DSCKeychainTests : XCTestCase

@property (nonatomic, strong) NSDictionary *expectedData;

@end

@implementation DSCKeychainTests

- (void)setUp
{
    [super setUp];
    self.expectedData = @{@"foo":@"bar", @"baz":@"qux"};
    [DSCKeychain save:DSCTestKeychainServiceName data:self.expectedData];
}

- (void)tearDown
{
    [DSCKeychain delete:DSCTestKeychainServiceName];
    [super tearDown];
}

- (void)testKeychainSaveAndLoad
{
    NSDictionary *actualData = [DSCKeychain load:DSCTestKeychainServiceName];
    
    XCTAssertTrue([actualData isEqual:self.expectedData]);
    XCTAssertNotNil(actualData);
}

- (void)testKeychainDelete
{
    OSStatus status = [DSCKeychain delete:DSCTestKeychainServiceName];
    
    NSDictionary *actualData = [DSCKeychain load:DSCTestKeychainServiceName];
    XCTAssertNil(actualData);
    XCTAssertEqual(status, 0);
}

@end
