//
//  DCXPathSubtreeSelector.h
//  dXml
//
//  Created by Derek Clarkson on 7/02/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

/**
 * Selector which can search all DCXmlNode element below the current node. it matches all again the specified name and 
 * returns all which match.
 */

#import <Foundation/Foundation.h>
#import "DCXPathAbstractSelector.h"


@interface DCXPathSubtreeSelector : DCXPathAbstractSelector {
@protected
	NSString *elementName;
}

@property (retain,nonatomic) NSString * elementName;

- (DCXPathSubtreeSelector *) initWithElementName:(NSString *)aElementName;

@end
