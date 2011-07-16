//
//  DCXPathArrayIndexFilterTests.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXPathElementFilter.h"
#import <dUsefulStuff/DCCommon.h>
#import "DCXmlNode.h"
#import "DCTextNode.h"

@interface DCXPathElementFilterTests : GHTestCase
{
}
@end

@implementation DCXPathElementFilterTests

- (void) testFilterAccepts {
	DCXPathElementFilter *filter = [[[DCXPathElementFilter alloc] initWithElementName:@"abc"] autorelease];
	NSError *error = nil;
	DCXmlNode * node = [DCXmlNode createWithName:@"abc"];
	GHAssertTrue([filter acceptNode:node index:1 errorVar:&error], @"Filter should have accepted");
	GHAssertNil(error, @"Error should not be populated");
}

- (void) testFilterRejects {
	DCXPathElementFilter *filter = [[[DCXPathElementFilter alloc] initWithElementName:@"abc"] autorelease];
	NSError *error = nil;
	DCXmlNode * node = [DCXmlNode createWithName:@"xyz"];
	GHAssertFalse([filter acceptNode:node index:0 errorVar:&error], @"Filter should have rejected");
	GHAssertNil(error, @"Error should not be populated");
}

- (void) testFilterRejectsTextNode {
	DCXPathElementFilter *filter = [[[DCXPathElementFilter alloc] initWithElementName:@"abc"] autorelease];
	NSError *error = nil;
	DCTextNode * node = [[[DCTextNode alloc] initWithText:@"abc"]autorelease];
	GHAssertFalse([filter acceptNode:node index:0 errorVar:&error], @"Filter should have rejected");
	GHAssertNil(error, @"Error should not be populated");
}

@end
