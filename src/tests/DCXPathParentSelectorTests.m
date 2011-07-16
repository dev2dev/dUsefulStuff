//
//  DCXPathRootNodeRuleTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXPathParentSelector.h"

@interface DCXPathParentSelectorTests : GHTestCase
{
}

@end


@implementation DCXPathParentSelectorTests


- (void) testBasicRootNode {
	
	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	DCXmlNode * subnode = [root addXmlNodeWithName:@"subnode"];
	
	DCXPathParentSelector *selector = [[[DCXPathParentSelector alloc] init] autorelease];
	id results = [selector selectNodesFromNode:subnode index:0];
	
	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"root", @"Root node not returned.");
	
}

@end
