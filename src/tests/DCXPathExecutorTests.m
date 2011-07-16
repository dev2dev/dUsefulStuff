//
//  DCXmlNode+XpathTests.m
//  dXml
//
//  Created by Derek Clarkson on 21/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXmlDocument.h"
#import "DCXmlParser.h"
#import "DCXPathExecutor.h"
#import <dUsefulStuff/DCCommon.h>

@interface DCXPathExecutorTests : GHTestCase {
	@private
	DCXmlDocument *document;
	DCXmlNode *def1;
	DCXPathExecutor *executor;
	NSError *error;
}
@end

@implementation DCXPathExecutorTests

- (void) setUp {
	NSString *testXml =
	   @"<abc>"
	   @"   <def>"
	   @"      <ghi>lmn</ghi>"
	   @"   </def>"
	   @"   <def>"
	   @"      <ghi>xyz</ghi>"
	   @"   </def>"
	   @"   <opq />"
	   @"</abc>";
	DCXmlParser *parser = [[DCXmlParser alloc] initWithXml:testXml];
	document = [[parser parse:NULL] retain];
	[parser release];
	def1 = [document xmlNodeWithName:@"def"];
	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	DC_DEALLOC(error);
}

- (void) tearDown {
	DC_DEALLOC(document);
	DC_DEALLOC(executor);
	DC_DEALLOC(error);
}

- (void) testInvalidXPathTriggersException {
	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	@try {
		[executor executeXPath:@"/[[" errorVar:&error];
		GHFail(@"Exception not thrown");
	}
	@catch (NSException *e) {
		GHAssertEqualStrings([e name], @"InvalidXpathException", @"Incorrect exception thrown");
	}
}

- (void) testPathRunsOutOfNodesReturnsNSNull {
	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results =    [executor executeXPath:@"//x" errorVar:&error];
	GHAssertEquals([NSNull null], results, @"Null not returned");
}

- (void) testRootReference {

	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results = [executor executeXPath:@"/" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlDocument class]], @"Document not returned");
	DCXmlDocument *returnedObj = (DCXmlDocument *)results;
	GHAssertEqualStrings(returnedObj.name, @"abc", @"Incorrect node returned");
}

- (void) testRootElementReference {

	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results = [executor executeXPath:@"/abc" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlDocument class]], @"Document not returned");
	DCXmlDocument *returnedObj = (DCXmlDocument *)results;
	GHAssertEqualStrings(returnedObj.name, @"abc", @"Incorrect node returned");
}

- (void) testIncorrectRootElementReferenceReturnsNSNull {

	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results = [executor executeXPath:@"/xyz" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertEquals(results, [NSNull null], @"Expected NSNull returned.");
}

- (void) testTooLongPathReturnsNSNull {
	
	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results = [executor executeXPath:@"//abc/def/ghi/lmn/opq" errorVar:&error];
	
	GHAssertNil(error, @"Error returned");
	GHAssertEquals(results, [NSNull null], @"Expected NSNull returned.");
}

- (void) testParentReference {

	executor = [[DCXPathExecutor alloc] initWithDocument:def1];
	id results = [executor executeXPath:@".." errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlDocument class]], @"Document not returned");
	DCXmlDocument *returnedObj = (DCXmlDocument *)results;
	GHAssertEqualStrings(returnedObj.name, @"abc", @"Incorrect node returned");
}

- (void) testSelfReference {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"." errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlDocument class]], @"Document not returned");
	DCXmlDocument *returnedObj = (DCXmlDocument *)results;
	GHAssertEqualStrings(returnedObj.name, @"abc", @"Incorrect node returned");
}

- (void) testElementNameArray {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"def" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Array not returned");

	NSArray *elements = (NSArray *)results;
	GHAssertEquals((int)[elements count], 2, @"Should be only two elements");
	for (DCDMNode *element in elements) {
		GHAssertTrue([element isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
		GHAssertEqualStrings([(DCXmlNode *)element name], @"def", @"Incorrect node returned");
	}
}

- (void) testRootToElement {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"/abc/def/ghi" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Array not returned");

	NSArray *elements = (NSArray *)results;
	GHAssertEquals((int)[elements count], 2, @"Should be only two elements");

	DCDMNode *node = (DCDMNode *)[elements objectAtIndex:0];
	GHAssertTrue([node isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)node name], @"ghi", @"Incorrect node returned");
	GHAssertEqualStrings([(DCXmlNode *)node value], @"lmn", @"Incorrect node returned");

	node = (DCDMNode *)[elements objectAtIndex:1];
	GHAssertTrue([node isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)node name], @"ghi", @"Incorrect node returned");
	GHAssertEqualStrings([(DCXmlNode *)node value], @"xyz", @"Incorrect node returned");
}

- (void) testArrayIndex {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"[1]" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)results name], @"def", @"Incorrect node returned");
	GHAssertEqualStrings([(DCXmlNode *)results xmlNodeWithName:@"ghi"].value, @"lmn", @"Incorrect node returned");

	results = [executor executeXPath:@"[2]" errorVar:&error];

	GHAssertTrue([results isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)results name], @"def", @"Incorrect node returned");
	GHAssertEqualStrings([(DCXmlNode *)results xmlNodeWithName:@"ghi"].value, @"xyz", @"Incorrect node returned");

}

- (void) testElementNameAndArrayIndex {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"def[2]" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)results name], @"def", @"Incorrect node returned");
	GHAssertEqualStrings([(DCXmlNode *)results xmlNodeWithName:@"ghi"].value, @"xyz", @"Incorrect node returned");

}

- (void) testElementNameAndSubNodeArrayIndex {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"def[2]/[1]" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertEqualStrings([(DCXmlNode *)results name], @"ghi", @"Incorrect node returned");

}

- (void) testElementNameAndMultipleSubNodeArrayIndex {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"def/ghi[1]" errorVar:&error];

	GHAssertNil(error, @"Error returned");
	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Array not returned");

	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Should be a NSArray");
	NSArray *elements = (NSArray *)results;
	GHAssertEquals((int)[elements count], 2, @"Should be only two elements");
	GHAssertTrue([[elements objectAtIndex:0] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertTrue([[elements objectAtIndex:1] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	DCXmlNode *n1 = (DCXmlNode *)[elements objectAtIndex:0];
	DCXmlNode *n2 = (DCXmlNode *)[elements objectAtIndex:1];
	GHAssertEqualStrings(n1.value, @"lmn", @"Incorrect node");
	GHAssertEqualStrings(n2.value, @"xyz", @"Incorrect node");

}

- (void) testSubtreeFindsNode {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"//def" errorVar:&error];

	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Should be a NSArray");
	NSArray *elements = (NSArray *)results;

	GHAssertEquals((int)[elements count], 2, @"Should be only two elements");
	GHAssertTrue([[elements objectAtIndex:0] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertTrue([[elements objectAtIndex:1] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	DCXmlNode *n1 = (DCXmlNode *)[elements objectAtIndex:0];
	DCXmlNode *n2 = (DCXmlNode *)[elements objectAtIndex:1];
	GHAssertEqualStrings(n1.name, @"def", @"Incorrect node");
	GHAssertEqualStrings(n2.name, @"def", @"Incorrect node");
	GHAssertNotEqualObjects(n1, n2, @"Should be different def nodes.");

}

- (void) testSubtreeFindsNthNode {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"//def[2]" errorVar:&error];

	GHAssertTrue([results isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	DCXmlNode *element = (DCXmlNode *)results;
	GHAssertEqualStrings([element xmlNodeWithName:@"ghi"].value, @"xyz", @"Incorrect def element returned");

}

- (void) testSubtreeThenArraySelectorFindsNodes {

	executor = [[DCXPathExecutor alloc] initWithDocument:document];
	id results = [executor executeXPath:@"//def/[1]" errorVar:&error];

	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Should be a NSArray");
	NSArray *elements = (NSArray *)results;

	GHAssertEquals((int)[elements count], 2, @"Should be only two elements");
	GHAssertTrue([[elements objectAtIndex:0] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	GHAssertTrue([[elements objectAtIndex:1] isKindOfClass:[DCXmlNode class]], @"Should be a DCXmlNode");
	DCXmlNode *n1 = (DCXmlNode *)[elements objectAtIndex:0];
	DCXmlNode *n2 = (DCXmlNode *)[elements objectAtIndex:1];
	GHAssertEqualStrings(n1.value, @"lmn", @"Incorrect node");
	GHAssertEqualStrings(n2.value, @"xyz", @"Incorrect node");

}

@end
