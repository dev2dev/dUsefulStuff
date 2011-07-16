//
//  untitled.h
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import "DCDMNode.h"

/**
 * A filter is called once for each node that will be added to the new current list of nodes. It provides the ability
 * to do additional processing based on the node or it's index within it's parent node.
 */
@protocol DCXPathFilter
/**
 * This method is called for each node added.
 * \param node A reference to the node being added. Can be any type of node.
 * \param anIndex The index of the node within the list of returned nodes from a selector. This is 0 based.
 * \param aErrorVar A reference to a variable where an error can be placed if it occurs.
 * \returns YES if the node should be added to the results, NO if it should not.
 */
- (BOOL) acceptNode:(DCDMNode *)node index:(int)anIndex errorVar:(NSError **)aErrorVar;

@end
