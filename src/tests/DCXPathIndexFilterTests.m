//
//  DCXPathArrayIndexFilterTests.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXPathIndexFilter.h"
#import <dUsefulStuff/DCCommon.h>


@interface DCXPathIndexFilterTests : GHTestCase
{
}
@end

@implementation DCXPathIndexFilterTests

- (void) testFilterAccepts {
	DCXPathIndexFilter *filter = [[[DCXPathIndexFilter alloc] initWithIndex:2] autorelease];
	NSError *error = nil;
	GHAssertTrue([filter acceptNode:nil index:1 errorVar:&error], @"Filter should have accepted");
	GHAssertNil(error, @"Error should not be populated");
}

- (void) testFilterRejects {
	DCXPathIndexFilter *filter = [[[DCXPathIndexFilter alloc] initWithIndex:2] autorelease];
	NSError *error = nil;
	GHAssertFalse([filter acceptNode:nil index:0 errorVar:&error], @"Filter should have rejected");
	GHAssertNil(error, @"Error should not be populated");
}

@end
