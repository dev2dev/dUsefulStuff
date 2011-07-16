//
//  DCXPathRootNodeRuleTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXPathRootSelector.h"

@interface DCXPathRootSelectorTests : GHTestCase
{
}

@end


@implementation DCXPathRootSelectorTests


- (void) testBasicRootNode {

	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	DCXmlNode * subnode = [root addXmlNodeWithName:@"subnode"];

	DCXPathRootSelector *selector = [[[DCXPathRootSelector alloc] init] autorelease];
	NSArray * results = [selector selectNodesFromNode:subnode index:0];
	
	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"root", @"Root node not returned.");
	
}

@end
