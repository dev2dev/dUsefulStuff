//
//  DCXPathabstractSelectorTests.m
//  dXml
//
//  Created by Derek Clarkson on 31/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXPathAbstractSelector.h"
#import "DCXmlNode.h"
#import <GHUnitIOS/GHUnitIOS.h>
#import <dUsefulStuff/DCCommon.h>
#import "DummyImplementations.h"
#import "DCTextNode.h"
#import <OCMock/OCMock.h>
#import "DCXPathFilter.h"


@interface DCXPathAbstractSelectorTests : GHTestCase {
	@private
}

@end

@implementation DCXPathAbstractSelectorTests

- (void) testCallsSelectNodes {

	DummySelector *selector = [[[DummySelector alloc] init] autorelease];
	NSMutableArray *returnNodes = [NSMutableArray array];
	[returnNodes addObject:[DCXmlNode createWithName:@"abc"]];
	selector.nodes = returnNodes;
	NSError *error = nil;

	id selectedNodes = [selector selectFromNode:nil index:0 errorVar:&error];

	GHAssertNil(error, @"Error should be nil");
	GHAssertNotNil(selectedNodes, @"Should be good to go");
	GHAssertEquals((int)[selectedNodes count], 1, @"Incorrect number of nodes returned.");
	GHAssertEqualStrings([(DCXmlNode *)[selectedNodes objectAtIndex:0] name], @"abc", @"Incorrect node returned");
}

- (void) testFilterIsCalledAndRejectsNode {

	DummySelector *selector = [[[DummySelector alloc] init] autorelease];
	NSMutableArray *returnNodes = [NSMutableArray array];
	DCXmlNode *aNode = [DCXmlNode createWithName:@"abc"];
	[returnNodes addObject:aNode];
	selector.nodes = returnNodes;
	NSError *error = nil;

	id mockFilter = [OCMockObject mockForProtocol:@protocol (DCXPathFilter)];
	BOOL sayNo = NO;
	[[[mockFilter stub] andReturnValue:DC_MOCK_VALUE(sayNo)] acceptNode:aNode index:0 errorVar:&error];
	[selector addFilter:mockFilter];

	id selectedNodes = [selector selectFromNode:nil index:0 errorVar:&error];

	GHAssertNil(error, @"Error should be nil");
	GHAssertNotNil(selectedNodes, @"Array should have been returned.");
	GHAssertEquals((int)[selectedNodes count], 0, @"Result array should be empty.");

	[mockFilter verify];
}

- (void) testFilterErrorDetectedAndReturned {
	
	DummySelector *selector = [[[DummySelector alloc] init] autorelease];
	NSMutableArray *returnNodes = [NSMutableArray array];
	DCXmlNode *aNode = [DCXmlNode createWithName:@"abc"];
	[returnNodes addObject:aNode];
	selector.nodes = returnNodes;
	NSError *error = nil;
	
	ErrorFilter * errorFilter = [[[ErrorFilter alloc]init]autorelease];
	[selector addFilter:errorFilter];
	
	id selectedNodes = [selector selectFromNode:nil index:0 errorVar:&error];
	
	GHAssertNotNil(error, @"Error should be nil");
	GHAssertNil(selectedNodes, @"Should have been a nil returned.");
	
}


@end

