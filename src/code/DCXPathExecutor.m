//
//  DCXpathExcutor.m
//  dXml
//
//  Created by Derek Clarkson on 24/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathExecutor.h"
#import <dUsefulStuff/DCCommon.h>
#import "DCXPathAbstractSelector.h"
#import "DCXPathRootSelector.h"
#import "DCXPathElementSelector.h"
#import "DCXPathIndexedSelector.h"
#import "DCXPathParentSelector.h"
#import "DCXPathIndexFilter.h"
#import "DCXPathElementFilter.h"
#import "DCTextNode.h"
#import "DCXPathSubtreeSelector.h"
#import "dXml.h"

typedef enum {
	START =0,
	ROOT_SLASH=1,
	ROOT_ELEMENT=2,
	SLASH=3,
	ELEMENT=4,
	OPEN_BRACKET=5,
	CLOSE_BRACKET=6,
	NUMBER=7,
	ANYWHERE=8,
	PARENT = 9,
	DOT = 10,
	END = 11
} TokenType;

// This array defines the valid syntax for our xpath expressions. This is a standard paser matrix.
// The token types enum defines the tokens. Therefore XPATH_TOKEN_SELECTORS[TokenTypes from][TokenTypes to] returns if
// the particular combination of tokens is allowed.
BOOL const XPATH_TOKEN_SELECTORS [12][12] = {
	/*               St  RtSl RtEl Slsh Ele  Open Cls  Nbr  Any  Prnt Dot  End */
	/* Start    */ { NO, YES, NO,	 NO,	YES, YES, NO,	NO,  YES, YES, YES, NO	},
	/* Root Sl  */ { NO, NO,  YES, NO,	NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  YES },
	/* Root Ele */ { NO, NO,  NO,	 YES, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  YES },
	/* Slash    */ { NO, NO,  NO,	 NO,	YES, YES, NO,	NO,  NO,	 NO,	NO,  YES },
	/* Element  */ { NO, NO,  NO,	 YES, NO,  YES, NO,	NO,  YES, NO,	NO,  YES },
	/* Open     */ { NO, NO,  NO,	 NO,	NO,  NO,	 NO,	YES, NO,	 NO,	NO,  NO	},
	/* Close    */ { NO, NO,  NO,	 YES, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  YES },
	/* Number   */ { NO, NO,  NO,	 NO,	NO,  NO,	 YES, NO,  NO,	 NO,	NO,  NO	},
	/* Anywhere */ { NO, NO,  NO,	 NO,	YES, NO,	 NO,	NO,  NO,	 NO,	NO,  NO	},
	/* Parent   */ { NO, NO,  NO,	 YES, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  YES },
	/* Dot      */ { NO, NO,  NO,	 YES, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  YES },
	/* End      */ { NO, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  NO	}
};

@interface DCXPathExecutor ()

- (NSMutableArray *) selectorPipelineFromXPath:(NSString *)xpath;

- (TokenType) tokenTypeFromScanner:(NSScanner *)scanner lastToken:(TokenType)lastToken nodeNameVar:(NSString **)nodeNameVar arrayIndexVar:(int *)arrayIndexVar;

- (id) finalResult:(NSArray *)currentNodes;

@end

@implementation DCXPathExecutor

@synthesize document;

- (DCXPathExecutor *) initWithDocument:(DCXmlNode *)aDocument {
	self = [super init];
	if (self) {
		self.document = aDocument;
		validElementnameCharacters = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
		[validElementnameCharacters addCharactersInString:@"_"];
	}
	return self;
}

- (id) executeXPath:(NSString *)aXPath errorVar:(NSError **)aErrorVar {

	DC_LOG(@"Processing xpath: %@", aXPath);

	// Obtain the selectors to be run.
	NSMutableArray *selectors = [self selectorPipelineFromXPath:aXPath];

	// Setup an array to store the working set of nodes. Initially, just the document node.
	NSMutableArray *currentNodes = [NSMutableArray array];
	DC_LOG(@"Setting current element %@ in list of current elements", document.name);
	[currentNodes addObject:document];

	// Loop through the selectors and execute then.
	DC_LOG(@"Processing selectors");
	NSMutableArray *newCurrentNodes;
	NSArray *selectorNodes;
	DCDMNode *node;
	for (DCXPathAbstractSelector *selector in selectors) {

		newCurrentNodes = [NSMutableArray array];

		// For each node in the current node list.
		for (int i = 0; i < [currentNodes count]; i++) {

			node = [currentNodes objectAtIndex:i];

			// If the current node is a text node we cannot do anything so create an error and exit.
			if ([ node isKindOfClass:[DCTextNode class]]) {
				if (aErrorVar != NULL) {
					NSError *error = [NSError errorWithDomain:DXML_DOMAIN code:CannotSelectFromTextNode userInfo:nil];
					DC_LOG(@"Generating error %@", error);
					*aErrorVar = error;
				}
				return nil;
			}

			// Call the selector.
			selectorNodes = [selector selectFromNode:(DCXmlNode *)node index:i errorVar:aErrorVar];
			if (selectorNodes == nil) {
				DC_LOG(@"Selector returned nil indicating an error will be present. Stopping xpath processing.");
				return nil;
			}

			// Add the selected nodes to the list.
			[newCurrentNodes addObjectsFromArray:selectorNodes];

		}

		// Replace the current nodes with the nodes from the selector.
		currentNodes = newCurrentNodes;

	}

	// Sort out what we are going to return.
	return [self finalResult:currentNodes];

}

- (NSMutableArray *) selectorPipelineFromXPath:(NSString *)xpath {

	TokenType lastToken = START;
	TokenType nextToken;
	int arrayIndex;
	NSString *nodeName;
	NSMutableArray *selectors = [NSMutableArray array];
	NSScanner *scanner = [NSScanner scannerWithString:xpath];
	BOOL elementSpecification = NO;
	BOOL subtreeSearch = NO;
	id newSelector;
	id newFilter;
	while ([scanner isAtEnd] == NO) {

		nextToken = [self tokenTypeFromScanner:scanner
		                             lastToken:lastToken
		                           nodeNameVar:&nodeName
		                         arrayIndexVar:&arrayIndex];

		// Setup for next interation through the loop.
		lastToken = nextToken;

		// All is good so lets process.
		switch (nextToken) {
			case ROOT_SLASH:
				DC_LOG(@"Adding root node selector");
				newSelector = [[DCXPathRootSelector alloc] init];
				[selectors addObject:newSelector];
				[newSelector release];
				continue;

			case ROOT_ELEMENT:
				// Tell the root node selector to validate the name of the root node.
				DC_LOG(@"Adding filter to root node selector to validate it's name is %@", nodeName);
				newFilter = [[DCXPathElementFilter alloc] initWithElementName:nodeName];
				[(DCXPathAbstractSelector *)[selectors lastObject] addFilter:newFilter];
				[newFilter release];
				continue;

			case SLASH:
				DC_LOG(@"Turning off element specification flag.");
				elementSpecification = NO;
				continue;

			case ELEMENT:

				if (subtreeSearch) {
					DC_LOG(@"Adding subtree search selector.");
					newSelector = [[DCXPathSubtreeSelector alloc] initWithElementName:nodeName];
					[selectors addObject:newSelector];
					[newSelector release];
					subtreeSearch = NO;

				} else {
					// Add a selector to select the next elements.
					DC_LOG(@"Adding element selector for %@", nodeName);
					newSelector = [[DCXPathElementSelector alloc] initWithElementName:nodeName];
					[selectors addObject:newSelector];
					[newSelector release];
				}

				elementSpecification = YES;
				continue;

			case OPEN_BRACKET:
				continue;

			case CLOSE_BRACKET:
				continue;

			case NUMBER:
				if (elementSpecification) {
					DC_LOG(@"Appending filter to element selector for index %i", arrayIndex);
					newFilter = [[DCXPathIndexFilter alloc] initWithIndex:arrayIndex];
					[(DCXPathAbstractSelector *)[selectors lastObject] addFilter:newFilter];
					[newFilter release];
					elementSpecification = NO;

				} else {
					// Just get the item from sub nodes.
					DC_LOG(@"Adding index only selector for index %i", arrayIndex);
					newSelector = [[DCXPathIndexedSelector alloc] initWithIndex:arrayIndex];
					[selectors addObject:newSelector];
					[newSelector release];
				}
				continue;

			case PARENT:
				DC_LOG(@"Adding parent node selector.");
				newSelector = [[DCXPathParentSelector alloc] init];
				[selectors addObject:newSelector];
				[newSelector release];
				continue;

			case ANYWHERE:
				subtreeSearch = YES;
				continue;

			case DOT:
				// Refers to self so no change.
				DC_LOG(@"Self reference, no change to selectors.");
				continue;

			default:
				break;
		}
	}

	// Now check the xpath is complete.
	if (!XPATH_TOKEN_SELECTORS[lastToken][END]) {
		DC_LOG(@"XPath not complete, throwing exception.");
		@throw [NSException exceptionWithName : @"IncompleteXpathException" reason :[NSString stringWithFormat:@"Incomplete xpath."] userInfo : nil];
	}

	return selectors;

}

- (TokenType) tokenTypeFromScanner:(NSScanner *)scanner lastToken:(TokenType)lastToken nodeNameVar:(NSString **)nodeNameVar arrayIndexVar:(int *)arrayIndexVar {

	int scanStartIndex = [scanner scanLocation];
	TokenType nextToken;

	// Read and identify the next token.
	if ([scanner scanString:@"//" intoString:NULL]) {
		DC_LOG(@"Found anywhere indicator (//)");
		nextToken = ANYWHERE;
	} else if ([scanner scanString:@"/" intoString:NULL]) {
		nextToken = scanStartIndex == 0 ? ROOT_SLASH : SLASH;
		DC_LOG(@"Found%@ slash (/)", scanStartIndex == 0 ? @" root" : @"");
	} else if ([scanner scanString:@"[" intoString:NULL]) {
		DC_LOG(@"Found start bracket ([)");
		nextToken = OPEN_BRACKET;
	} else if ([scanner scanString:@"]" intoString:NULL]) {
		DC_LOG(@"Found closing bracket (])");
		nextToken = CLOSE_BRACKET;
	} else if ([scanner scanString:@".." intoString:NULL]) {
		DC_LOG(@"Found parent reference (..)");
		nextToken = PARENT;
	} else if ([scanner scanString:@"." intoString:NULL]) {
		DC_LOG(@"Found self reference (.)");
		nextToken = DOT;
	} else if ([scanner scanInt:arrayIndexVar]) {
		DC_LOG(@"Found arrray index");
		nextToken = NUMBER;
	} else if ([scanner scanCharactersFromSet:validElementnameCharacters intoString:nodeNameVar]) {
		DC_LOG(@"Found%@ element name", lastToken == ROOT_SLASH ? @" root" : @"");
		nextToken = lastToken == ROOT_SLASH ? ROOT_ELEMENT : ELEMENT;
	} else {
		// Nothing scanned so throw an error.
		DC_LOG(@"Unknown token in xpath, throwing exception.");
		@throw [NSException exceptionWithName : @"UnknownTokenInXpathException" reason :[NSString stringWithFormat:@"Not at end of xpath and could figure out next token at char index %i", scanStartIndex] userInfo : nil];
	}

	// Now check that the token combination is valid.
	if (!XPATH_TOKEN_SELECTORS[lastToken][nextToken]) {
		DC_LOG(@"Invalid xpath, throwing exception.");
		@throw [NSException exceptionWithName : @"InvalidXpathException" reason :[NSString stringWithFormat:@"Invalid xpath at index %i", scanStartIndex] userInfo : nil];
	}

	return nextToken;
}

- (id) finalResult:(NSArray *)currentNodes {
	DC_LOG(@"Sorting out what to return.");
	if ([currentNodes count] == 0) {
		DC_LOG(@"Nothing left, returning null");
		return [NSNull null];
	}
	if ([currentNodes count] == 1) {
		// One node so just return that directly.
		return [currentNodes objectAtIndex:0];
	}

	// A collection of nodes so return the array.
	return currentNodes;
}


- (void) dealloc {
	DC_DEALLOC(validElementnameCharacters);
	[super dealloc];
}

@end