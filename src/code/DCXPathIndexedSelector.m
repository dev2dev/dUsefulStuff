//
//  DCXPathIndexedSubNodeRule.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathIndexedSelector.h"
#import "DCXmlNode.h"
#import <dUsefulStuff/DCCommon.h>


@implementation DCXPathIndexedSelector

@synthesize index;

- (DCXPathIndexedSelector *) initWithIndex:(int)anIndex {
	self = [super init];
	if (self) {
		self.index = anIndex;
	}
	return self;
}

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {
	NSMutableArray *result = [NSMutableArray array];
	if ([node countNodes] >= index) {
		DC_LOG(@"Getting sub node of %@ at index %i", node.name, index);
		[result addObject:[node nodeAtIndex:index - 1]];
	}
	return result;
}

@end
