//
//  NSObject+dUsefulStuff.h
//  dUsefulStuff
//
//  Created by Derek Clarkson on 7/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category of useful methods for all objects.
 */
@interface NSObject (dUsefulStuff)
/**
 This creates NSError objects based on the passed information. It wraps some some boiler plate code for creating better error objects.
 
 @param errorCode
 @param errorDomain the domain associated with the error.
 @param shortDescription the short description text displayed automatically in error dialogs.
 @param failureReason the more detailed text of the error.
 */
-(NSError *) errorForCode:(NSInteger) errorCode 
				  errorDomain:(NSString *) errorDomain 
			shortDescription:(NSString *) shortDescription 
				failureReason:(NSString *) failureReason; 

@end
