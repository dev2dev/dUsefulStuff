//
//  DCXPathArrayIndexFilter.h
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXPathFilter.h"

/**
 * Filter that only accepts a single node, depending on it's index within it's parent node.
 */
@interface DCXPathIndexFilter : NSObject<DCXPathFilter> {
	@private
	int index;
}

- (DCXPathIndexFilter *) initWithIndex:(int)anIndex;

@end
