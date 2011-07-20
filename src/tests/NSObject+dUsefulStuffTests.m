//
//  NSObject+dUsefulStuffTests.m
//  dUsefulStuff
//
//  Created by Derek Clarkson on 7/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "NSObject+dUsefulStuff.h"

@interface NSObject_dUsefulStuffTests : GHTestCase{}

@end

@implementation NSObject_dUsefulStuffTests

-(void) testErrorCreatedCorrectly {
	NSError *error = [self errorForCode:1 errorDomain:@"domain" shortDescription:@"abc" failureReason:@"def"];
	GHAssertEquals(error.code, 1, @"Incorrect code.");
	GHAssertEqualStrings(error.domain, @"domain", @"Incorrect domain.");
	NSDictionary * userInfo = [error userInfo];
	GHAssertEquals([userInfo objectForKey:NSLocalizedDescriptionKey], @"abc", @"short description not correct");
	GHAssertEquals([userInfo objectForKey:NSLocalizedFailureReasonErrorKey], @"def", @"failure reason not correct");
}

@end
