//
//  DCXpathExcutor.h
//  dXml
//
//  Created by Derek Clarkson on 24/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlNode.h"

/**
 * This class processes xpaths. The Xpath capability is not a complete implementation. However it proves the basic set of instructions needed to be able to locate DCDMNode instances. 
 * 
 * The processing follows the w3school standard (Although I found it a bit hard to follow!) as near as I can. The reference I used 
 * can be found at http://www.w3schools.com/XPath/xpath_syntax.asp Basically what happens is that unless there is a starting slash in the 
 * path, navigation starts with the xml element that you send the request to. If there is a starting slash then the processing of the path
 * starts from the root of the document model.
 *
 * Xpath processing is designed to return multiple nodes if they exist. So specifying something like abc/[2] will bring back the secod sub element from all occurances of the abc element. Not just the first. 
 * 
 * Here is a list of the elements you can use in the xpaths and how they are processed.
 * 
 * - <b>//<i>element-name</i></b> - returns all occurances of <i>element-name</i> from the current point in the document model and below. This 
 * is regardless of where they occur.
 * - <b>/</b> - delimiter between nodes of the xpath. <b>Note:</b> If this occurs at the start of the xpath then it causes the path to be regarded as an absolute path which starts from the root of the document.
 * - <b>..</b> - refers back up to the parent of each of the current set of nodes. 
 * - <b>.</b> - refers to the current node so doesn't really do anything as such, but is here for completeness. Allows xpaths like "./abc"
 * - <b>[nn]</b> - This depends on how it is used. Combined with a element name it selects the nth element by that name. However, if used by itself, it selects the nth DCDMNode under the current nodes.
 * 
 * A note about exceptions and errors. Exceptions are thrown by the executeXpath:errorVar: method if there is a syntactical issues with the xpath. i.e. the developer got it wrong and should have picked it up during developement. Alternatively I got it wrong :-) However if there is an error during the processing of a document model, then the errorVar variable is populated instead. The reasoning is that this is a likely event caused by incomplete (but valid xml) being processed. Or the xml is simply not what was expected by the xpath. A good example might be a xpath that tries to find sub nodes of a text node.
 * 
 */
@interface DCXPathExecutor : NSObject {
	@private
	DCXmlNode *document;
	NSMutableCharacterSet *validElementnameCharacters;
}

/**
 * Reference to the document to be processed.
 */
@property (retain, nonatomic) DCXmlNode *document;

/**
 * Default constructor.
 * \param aDocument A document model. Notice it is only required to have a single DCXmlNode as the root node. This allows document models which do not have a DCXmlDocument as the root to be processed.
 */
- (DCXPathExecutor *) initWithDocument:(DCXmlNode *)aDocument;

/**
 * Executes the passed xpath and returns whatever it finds.
 * The results can be any of the following:
 * \li [NSNull null] indicating that there was no matching xml.
 * \li A single DCTextNode or DCXmlNode.
 * \li A NSArray containing any combination of DCTextNodes and DCXmlNodes.
 * \li A nil which indicates that the errorVar contains an error.
 *
 * \param aXPath This is the xpath string to be executed.
 * \param aErrorVar A reference to a variable which will be populated with an NEError should there be an issue with processing the xpath against the current document model.
 * \exception NSException if there is a fault in the xpath syntax.
 */
- (id) executeXPath:(NSString *)aXPath errorVar:(NSError **)aErrorVar;

@end

