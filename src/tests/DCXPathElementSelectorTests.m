//
//  DCXPathRootNodeRuleTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXPathElementSelector.h"

@interface DCXPathElementSelectorTests : GHTestCase
{
}

@end


@implementation DCXPathElementSelectorTests


- (void) testBasicSelection {
	
	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	[root addXmlNodeWithName:@"ignored"];
	[root addXmlNodeWithName:@"subnode"];
	
	DCXPathElementSelector *selector = [[[DCXPathElementSelector alloc] initWithElementName:@"subnode"] autorelease];
	NSArray * results = [selector selectNodesFromNode:root index:0];
	
	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"subnode", @"Subnode node not returned.");
	
}

@end
