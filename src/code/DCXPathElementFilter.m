//
//  DCXPathElementFilter.m
//  dXml
//
//  Created by Derek Clarkson on 2/02/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathElementFilter.h"
#import "DCDMNode.h"
#import "DCXmlNode.h"
#import <dUsefulStuff/DCCommon.h>

@implementation DCXPathElementFilter

@synthesize elementName;

- (DCXPathElementFilter *) initWithElementName:(NSString *)aElementName {
	self = [super init];
	if (self) {
		self.elementName = aElementName;
	}
	return self;
}

- (BOOL) acceptNode:(DCDMNode *)node index:(int)anIndex errorVar:(NSError **)aErrorVar {
	if (![node isKindOfClass:[DCXmlNode class]]) {
		return NO;
	}
	return [(DCXmlNode *)node isEqualToName:self.elementName];
}

@end
