//
//  DCXPathArrayIndexFilter.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathIndexFilter.h"
#import <dUsefulStuff/DCCommon.h>

@implementation DCXPathIndexFilter
- (DCXPathIndexFilter *) initWithIndex:(int)anIndex {
	self = [super init];
	if (self) {
		index = anIndex;
	}
	return self;
}

- (BOOL) acceptNode:(DCDMNode *)node index:(int)anIndex errorVar:(NSError **)aErrorVar {
	return anIndex + 1 == index;
}
@end
