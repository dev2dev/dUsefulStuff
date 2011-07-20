//
//  NSObject+dUsefulStuff.m
//  dUsefulStuff
//
//  Created by Derek Clarkson on 7/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "NSObject+dUsefulStuff.h"

@implementation NSObject (dUsefulStuff)

-(NSError *) errorForCode:(NSInteger) errorCode 
				  errorDomain:(NSString *) errorDomain 
			shortDescription:(NSString *) shortDescription 
				failureReason:(NSString *) failureReason; {
	NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
								 shortDescription, NSLocalizedDescriptionKey, 
								 failureReason, NSLocalizedFailureReasonErrorKey, 
								 nil];
	return [NSError errorWithDomain:errorDomain code:errorCode userInfo:dic];
}

@end
