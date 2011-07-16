//
//  DCXPathRootNodeRuleTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXPathIndexedSelector.h"

@interface DCXPathIndexedSelectorTests : GHTestCase
{
}

@end


@implementation DCXPathIndexedSelectorTests


- (void) testBasicIndex {

	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	[root addXmlNodeWithName:@"abc" value:@"A"];
	[root addXmlNodeWithName:@"def" value:@"B"];
	[root addXmlNodeWithName:@"ghi" value:@"C"];

	DCXPathIndexedSelector *selector = [[[DCXPathIndexedSelector alloc] initWithIndex:1] autorelease];
	id results = [selector selectNodesFromNode:root index:0];

	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"abc", @"Subnode node not returned.");

	selector = [[[DCXPathIndexedSelector alloc] initWithIndex:2] autorelease];
	results = [selector selectNodesFromNode:root index:0];

	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"def", @"Subnode node not returned.");

	selector = [[[DCXPathIndexedSelector alloc] initWithIndex:3] autorelease];
	results = [selector selectNodesFromNode:root index:0];

	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"ghi", @"Subnode node not returned.");

}

- (void) testIndexBeyondAvailableNodes {

	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	[root addXmlNodeWithName:@"subnode" value:@"A"];
	[root addXmlNodeWithName:@"subnode" value:@"B"];

	DCXPathIndexedSelector *selector = [[[DCXPathIndexedSelector alloc] initWithIndex:3] autorelease];
	id results = [selector selectNodesFromNode:root index:0];

	GHAssertEquals((int)[results count], 0, @"Incorrect number of nodes returned");

}

@end
