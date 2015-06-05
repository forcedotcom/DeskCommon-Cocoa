//
//  NSURLRequestDSCTests.m
//  DeskCommon
//
//  Created by Jamie Forrest on 5/8/15.
//  Copyright (c) 2015 Desk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <DeskCommon/DeskCommon.h>

@interface NSURLRequestDSCTests : XCTestCase

@end

@implementation NSURLRequestDSCTests

- (void)testStripsAcceptAndContentTypeHeaders
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setValue:@"foo" forHTTPHeaderField:DSC_HTTP_HEADER_ACCEPT];
    [request setValue:@"foo" forHTTPHeaderField:DSC_HTTP_HEADER_CONTENT_TYPE];
    XCTAssertNotNil([request valueForHTTPHeaderField:DSC_HTTP_HEADER_ACCEPT]);
    XCTAssertNotNil([request valueForHTTPHeaderField:DSC_HTTP_HEADER_CONTENT_TYPE]);
    
    NSURLRequest *requestStripped = [NSURLRequest requestWithAcceptAndContentTypeHeadersStripped:request];
    XCTAssertNil([requestStripped valueForHTTPHeaderField:DSC_HTTP_HEADER_ACCEPT]);
    XCTAssertNil([requestStripped valueForHTTPHeaderField:DSC_HTTP_HEADER_CONTENT_TYPE]);
}

@end
