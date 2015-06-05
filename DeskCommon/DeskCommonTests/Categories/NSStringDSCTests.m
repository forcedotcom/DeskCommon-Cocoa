//
//  NSStringDSCTests.m
//  DeskCommon
//
//  Created by Desk.com on 12/18/14.
//  Copyright (c) 2015, Salesforce.com, Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided
//  that the following conditions are met:
//
//     Redistributions of source code must retain the above copyright notice, this list of conditions and the
//     following disclaimer.
//
//     Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
//     the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//     Neither the name of Salesforce.com, Inc. nor the names of its contributors may be used to endorse or
//     promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import <XCTest/XCTest.h>
#import <DeskCommon/NSString+DSC.h>

@interface NSStringDSCTests : XCTestCase

@end

@implementation NSStringDSCTests

- (void)testToCamelCase
{
    NSString *underscoreCaseString = @"created_by_user";
    XCTAssertTrue([[underscoreCaseString camelCase] isEqualToString:@"createdByUser"]);
    
    NSString *nonSeparatedString = @"customer";
    XCTAssertTrue([[nonSeparatedString camelCase] isEqualToString:@"customer"]);
    
    NSString *whitespaceAndColonString = @"created by:user";
    XCTAssertTrue([[whitespaceAndColonString camelCase] isEqualToString:@"createdByUser"]);
    
    NSString *dashAndCommaString = @"created-by,user";
    XCTAssertTrue([[dashAndCommaString camelCase] isEqualToString:@"createdByUser"]);
}

- (void)testTruncationMinimumIs4Characters
{
    NSString *shortString = @"a";
    XCTAssertTrue([[shortString truncatedTo:2] isEqualToString:@""]);
}

- (void)testTruncationOnShortString
{
    NSString *shortString = @"a";
    XCTAssertTrue([[shortString truncatedTo:3] isEqualToString:shortString]);
}

- (void)testTruncationOnLongString
{
    NSString *shortString = @"abcdefgh";
    XCTAssertTrue([[shortString truncatedTo:4] isEqualToString:@"abcd"]);
}

- (void)testContainsString
{
    NSString *containedString = @"abc";
    NSString *string = @"abcdefgh";
    
    XCTAssertTrue([string containsString:containedString]);
}

- (void)testDoesNotContainString
{
    NSString *containedString = @"foo";
    NSString *string = @"abcdefgh";
    
    XCTAssertFalse([string containsString:containedString]);
}

- (void)testStripNewlines
{
    NSString *stringWithNewlines = @"Hey,\n\nthere";
    NSString *strippedString = [stringWithNewlines stringByRemovingNewlines];
    XCTAssertTrue([strippedString isEqualToString:@"Hey, there"]);
}

- (void)testStripWindozeNewlines
{
    NSString *stringWithNewlines = @"Hey,\r\n\r\nthere";
    NSString *strippedString = [stringWithNewlines stringByRemovingNewlines];
    XCTAssertTrue([strippedString isEqualToString:@"Hey, there"]);
}

- (void)testStripNewlinesDoesNotStripWhitespace
{
    NSString *stringWithNewlines = @"Hey, there";
    NSString *strippedString = [stringWithNewlines stringByRemovingNewlines];
    XCTAssertTrue([strippedString isEqualToString:@"Hey, there"]);
}

- (void)testIsEmpty
{
    NSString *nilString = nil;
    XCTAssertTrue([NSString isEmpty:nilString]);
    
    id nullString = [NSNull null];
    XCTAssertTrue([NSString isEmpty:nullString]);
    
    NSString *blankString = @"";
    XCTAssertTrue([NSString isEmpty:blankString]);
    
    NSString *whitespaceOnly = @"   ";
    XCTAssertFalse([NSString isEmpty:whitespaceOnly]);
    
    NSString *nonBlankString = @"foo";
    XCTAssertFalse([NSString isEmpty:nonBlankString]);
}

- (void)testIsWhiteSpaceOrEmpty
{
    NSString *nilString = nil;
    XCTAssertTrue([NSString isWhitespaceOrEmpty:nilString]);
    
    id nullString = [NSNull null];
    XCTAssertTrue([NSString isWhitespaceOrEmpty:nullString]);
    
    NSString *blankString = @"";
    XCTAssertTrue([NSString isWhitespaceOrEmpty:blankString]);
    
    NSString *whitespaceOnly = @"   ";
    XCTAssertTrue([NSString isWhitespaceOrEmpty:whitespaceOnly]);
    
    NSString *whitespaceWithNewline = @" \n\n  ";
    XCTAssertTrue([NSString isWhitespaceOrEmpty:whitespaceWithNewline]);
    
    NSString *nonBlankString = @"foo";
    XCTAssertFalse([NSString isWhitespaceOrEmpty:nonBlankString]);
    
    NSString *someWhitespaceString = @"   some whitespace  ";
    XCTAssertFalse([NSString isWhitespaceOrEmpty:someWhitespaceString]);
}

- (void)testInitials
{
    XCTAssertTrue([[@"john doe" initials] isEqualToString:@"JD"]);
    XCTAssertTrue([[@"John Doe" initials] isEqualToString:@"JD"]);
    XCTAssertTrue([[@"John M. Doe" initials] isEqualToString:@"JD"]);
    XCTAssertTrue([[@"John" initials] isEqualToString:@"J"]);
    XCTAssertTrue([[@"E.E. Cummings" initials] isEqualToString:@"EC"]);
    XCTAssertTrue([[@"E. E. Cummings" initials] isEqualToString:@"EC"]);
    XCTAssertTrue([[@"Desk.com" initials] isEqualToString:@"D"]);
    XCTAssertTrue([[@"Home Depot" initials] isEqualToString:@"HD"]);
    XCTAssertTrue([[@"PUBLIC NAME - Joe & Jones Agnès Prunières " initials] isEqualToString:@"PP"]);
}

- (void)testInitialsShouldHandleEmptyString
{
    XCTAssertTrue([[@"" initials] isEqualToString:@""]);
}

- (void)testIsANumber
{
    XCTAssertTrue([@"12.34" isANumber]);
    XCTAssertTrue([@".34" isANumber]);
    XCTAssertTrue([@"0.34" isANumber]);
    XCTAssertFalse([@"1..2" isANumber]);
    XCTAssertFalse([@"12.a" isANumber]);
    XCTAssertFalse([@"aaa" isANumber]);
}

-(void)testConformsToPrecisionAndScale
{
    XCTAssertTrue([@"12.34" conformsToDoublePrecision:5 andScale:3]);
    XCTAssertTrue([@"12.34" conformsToDoublePrecision:4 andScale:2]);
    XCTAssertFalse([@"12345" conformsToDoublePrecision:4 andScale:2]);
    XCTAssertFalse([@"12.345" conformsToDoublePrecision:5 andScale:2]);
    XCTAssertFalse([@"12.345" conformsToDoublePrecision:4 andScale:3]);
}

@end
