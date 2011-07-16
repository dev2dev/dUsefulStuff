//
//  DCXPathAbstractRule.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathAbstractSelector.h"
#import <dUsefulStuff/DCCommon.h>
#import "DCXmlNode.h"
#import "DCTextNode.h"
#import "DCXPathFilter.h"


@interface DCXPathAbstractSelector()
-(void) test;

@end


@implementation DCXPathAbstractSelector

/**
 * Empty implementation.
 */
- (NSArray *) selectFromNode:(DCXmlNode *)currentNode index:(int)anIndex errorVar:(NSError **)aErrorVar {

	DC_LOG(@"Executing selector");

	// Execution the selector method to get a list of new nodes.
	NSArray *newNodes = [self selectNodesFromNode:currentNode index:anIndex];

	// If there are no filters then add all the nodes and exit.
	if (filters == nil) {
		DC_LOG(@"No filters present, adding %i selectors nodes to selectedNodes.", [newNodes count]);
		return newNodes;
	}

	// Otherwise pass each node to all filters and reject if any so NO.
	NSMutableArray *resultNodes = [NSMutableArray array];
	int nbrFilters = [filters count];
	int nbrNodes = [newNodes count];
	BOOL addNode;
	DCDMNode *node;

	// For each selected node.
	for (int i = 0; i < nbrNodes; i++) {

		DC_LOG(@"Running filters on node: %i", i);
		addNode = YES;
		node = [newNodes objectAtIndex:i];

		// Run each filter unless one fails.
		for (int j = 0; j < nbrFilters; j++) {
			if (![(NSObject < DCXPathFilter > *)[filters objectAtIndex:j] acceptNode:node index:i errorVar:aErrorVar]) {

				// If an error occured then get out.
				if (aErrorVar != NULL && *aErrorVar != nil) {
					DC_LOG(@"Filter error detected");
					return nil;
				}

				DC_LOG(@"Filter rejected node");
				addNode = NO;
				break;
			}

		}

		// All filters say ok.
		if (addNode) {
			DC_LOG(@"Filters passed node. Adding to selectedNodes list.");
			[resultNodes addObject:node];
		}
	}
	return resultNodes;
}

/**
 * Empty implementation designed to be overridden.
 */
- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {
	return nil;
}

- (void) addFilter:(NSObject<DCXPathFilter> *)filter {
	if (filters == nil) {
		filters = [[NSMutableArray alloc] init];
	}
	[filters addObject:filter];
}

- (void) dealloc {
	DC_DEALLOC(filters);
	[super dealloc];
}
-(void) test {
}

@end
