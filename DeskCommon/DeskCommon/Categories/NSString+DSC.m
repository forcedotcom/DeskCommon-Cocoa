//
//  NSString+DSC.m
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


#import "NSString+DSC.h"

#define kMinStringLength 3

@implementation NSString (DSC)

- (NSString *)camelCase
{
    NSMutableString *camelCasedString = [NSMutableString stringWithCapacity:self.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    BOOL lowerCasePassComplete = NO;
    while (!scanner.isAtEnd) {
        NSString *buffer;
        if ([scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_- :,"] intoString:&buffer]) {
            if (lowerCasePassComplete) {
                buffer = [buffer capitalizedString];
            }
            [camelCasedString appendString:buffer];
            lowerCasePassComplete = YES;
        } else {
            scanner.scanLocation = scanner.scanLocation + 1;
        }
    }
    
    return [camelCasedString copy];
}

+ (BOOL)isEmpty:(NSString *)string
{
    return !string || [string isEqual:[NSNull null]] || [string isEqualToString:@""];
}

+ (BOOL)isWhitespaceOrEmpty:(NSString *)string
{
    if ([self isEmpty:string]) {
        return YES;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *stringWithoutWhitepace = [string stringByTrimmingCharactersInSet:whitespace];
    return [self isEmpty:stringWithoutWhitepace];
}

// TODO:  Refactor the above to use the below (or refactor all callers to use the below)

- (BOOL)isEmpty
{
    return !self || [self isEqual:[NSNull null]] || [self isEqualToString:@""];
}

- (BOOL)isWhitespaceOrEmpty
{
    if ([self isEmpty]) {
        return YES;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *stringWithoutWhitepace = [self stringByTrimmingCharactersInSet:whitespace];
    return [stringWithoutWhitepace isEmpty];
}

- (BOOL)isPresent
{
    return ![self isWhitespaceOrEmpty];
}

- (BOOL)conformsToDoublePrecision:(NSUInteger)precision andScale:(NSUInteger)scale
{

    BOOL doesConformPrecision = YES;
    BOOL doesConformScale = YES;

    NSArray *components = [self componentsSeparatedByString:@"."];

    doesConformPrecision = ([self length] <= (precision + 1) && components.count > 1) || ([self length] <= precision && components.count == 1);
    
    if (components.count > 1) {
        doesConformScale = [(NSString *)[components lastObject] length] <= scale;
    }
    
    return doesConformPrecision && doesConformScale;
}

- (BOOL)isANumber
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[-+]?[0-9]*.?[0-9]+$'"] evaluateWithObject: self];
}

- (NSString *)truncatedTo:(NSUInteger)numCharacters
{
    if (numCharacters < kMinStringLength) {
        return @"";
    }
    return (self.length <= numCharacters) ? self : [self substringToIndex:numCharacters];
}

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options
{
    return [self rangeOfString:string options:options].location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string
{
    return [self containsString:string options:0];
}

- (NSString *)stringByRemovingNewlines
{
    NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    return [components componentsJoinedByString:@" "];
}

- (NSString *)stringByRemovingEmailBrackets
{
    NSArray *components = [self componentsSeparatedByString:@"<"];
    if (components.count > 1) {
        return [[components[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@">"]];
    } else {
        return components[0];
    }
}

- (NSString *)initials
{
    NSString *empty = @"";
    NSString *stripped = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *components = [stripped componentsSeparatedByString:@" "];
    
    if ([components.firstObject length] < 1) {
        return empty;
    }
    
    NSString *firstInitial = [[components.firstObject substringToIndex:1] capitalizedString];
    NSString *lastInitial = @"";
    if (components.count > 1) {
        lastInitial = [[components.lastObject substringToIndex:1] capitalizedString];
    }
    
    return [NSString stringWithFormat:@"%@%@", firstInitial, lastInitial];
}

@end
