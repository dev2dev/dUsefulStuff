//
//  DCXPathElementRule.h
//  dXml
//
//  Created by Derek Clarkson on 26/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlNode.h"
#import "DCXPathAbstractSelector.h"

@interface DCXPathElementSelector : DCXPathAbstractSelector {
	@protected
	NSString *elementName;
}

@property (retain,nonatomic) NSString * elementName;

- (DCXPathElementSelector *) initWithElementName:(NSString *)aElementName;

@end
