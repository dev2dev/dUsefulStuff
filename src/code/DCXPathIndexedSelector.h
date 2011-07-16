//
//  DCXPathIndexedSubNodeRule.h
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXPathAbstractSelector.h"


@interface DCXPathIndexedSelector : DCXPathAbstractSelector {
	@private
	int index;
}

@property (nonatomic) int index;

- (DCXPathIndexedSelector *) initWithIndex:(int)anIndex;

@end
