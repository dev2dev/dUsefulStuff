//
//  DCXPathElementFilter.h
//  dXml
//
//  Created by Derek Clarkson on 2/02/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXPathFilter.h"

/**
 * Filters DCXmlNode and only accepts nodes which have the specified name.
 */
@interface DCXPathElementFilter : NSObject<DCXPathFilter> {
	@private
	NSString *elementName;
}

@property (retain, nonatomic) NSString *elementName;

- (DCXPathElementFilter *) initWithElementName:(NSString *)aElementName;

@end
