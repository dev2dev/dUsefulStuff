//
// DCUIRating.m
// dUsefulStuff
//
// Created by Derek Clarkson on 23/03/10.
// Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCUIRating.h"
#import "DCCommon.h"
#import "DCUIRatingScaleStrategy.h"
#import "DCUIRatingScaleWholeStrategy.h"
#import "DCUIRatingScaleHalfStrategy.h"
#import "DCUIRatingScaleDoubleStrategy.h"

/**
 private interface
 */
@interface DCUIRating ()
- (void) setDefaults;
- (void) calculateRatingAtX:(float) x;
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender;
- (IBAction)swipeGesture:(UIPanGestureRecognizer *)sender;
@end

@implementation DCUIRating

@dynamic rating;
@dynamic offRatingImage;
@dynamic onRatingImage;
@dynamic halfRatingImage;

@synthesize iconCount;
@synthesize bubble;
@synthesize delegate;
@synthesize scale;

//@synthesize enabled;

#pragma mark Dynamic properties

- (void) setRating:(float) aRating {
	
	//Check that the rating is not above the scale/iconCount maximum value.
	int maxValue = iconCount * (scale == DCRatingScaleDouble ? 2: 1);
	if (aRating > maxValue) {
		DC_LOG(@"Passed rating %f greater than max rating %i, resetting to max.", aRating, maxValue);
		aRating = maxValue;
	} else if (aRating < 0) {
		//Check that the rating is not below zero.
		DC_LOG(@"Passed rating %f less than  zero, resetting to zero.", aRating);
		aRating = 0;
	}
	
	[scaleStrategy setRating:aRating];
	DC_LOG(@"Triggering a refresh");
	[self setNeedsDisplay];
}

- (float) rating {
	return [scaleStrategy rating];
}

- (void) setOffRatingImage:(UIImage *) image {
	scaleStrategy.offImage = image;
	[self sizeToFit];
}

- (UIImage *) offRatingImage {
	return scaleStrategy.offImage;
}

- (void) setOnRatingImage:(UIImage *) image {
	scaleStrategy.onImage = image;
}

- (UIImage *) onRatingImage {
	return scaleStrategy.onImage;
}

- (void) setHalfRatingImage:(UIImage *) image {
	scaleStrategy.halfOnImage = image;
}

- (UIImage *) halfRatingImage {
	return scaleStrategy.halfOnImage;
}

#pragma mark -
#pragma mark Property setter overrides

- (void) setIconCount:(int) count {
	
	// Fast exit.
	if (count == iconCount ) {
		return;
	}
	
	// Range check.
	if (count < 3 || count > 5) {
		NSException * myException = [NSException
											  exceptionWithName:@"IconCountOutOfBoundsException"
											  reason:@"An attempt was made to set iconCount to a value <3 or >5."
											  userInfo:nil];
		@throw myException;
	}
	
	iconCount = count;
	[self sizeToFit];
}

- (void) setScale:(DCRatingScale) aScale {
	
	//Store
	scale = aScale;
	
	// Get the new strategy.
	NSObject<DCUIRatingScaleStrategy> * newStrategy = nil;
	switch (aScale) {
		case DCRatingScaleWhole:
			newStrategy = [[DCUIRatingScaleWholeStrategy alloc] init];
			break;
		case DCRatingScaleHalf:
			newStrategy = [[DCUIRatingScaleHalfStrategy alloc] init];
			break;
		default:
			newStrategy = [[DCUIRatingScaleDoubleStrategy alloc] init];
	}
	
	// Transfer properties.
	newStrategy.offImage = scaleStrategy.offImage;
	newStrategy.onImage = scaleStrategy.onImage;
	newStrategy.halfOnImage = scaleStrategy.halfOnImage;
	[newStrategy setRating:scaleStrategy.rating];
	
	DC_DEALLOC(scaleStrategy);
	scaleStrategy = newStrategy;
}

#pragma mark -
#pragma mark Constructors

- (id) initWithFrame:(CGRect) frame {
	DC_LOG(@"initWithFrame:");
	self = [super initWithFrame:frame];
	if (self) {
		[self setDefaults];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *) decoder {
	DC_LOG(@"initWithCoder:");
	self = [super initWithCoder:decoder];
	if (self) {
		[self setDefaults];
	}
	return self;
}

- (void) setDefaults {
	DC_LOG(@"Setting defaults");
	scaleStrategy = [[DCUIRatingScaleWholeStrategy alloc] init];
	self.iconCount = 5;
	
	DC_LOG(@"Adding gesture recognisers");
	UITapGestureRecognizer * tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
	[self addGestureRecognizer:tapRecogniser];
	[tapRecogniser release];
	UIPanGestureRecognizer * swipeRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
	[self addGestureRecognizer:swipeRecogniser];
	[swipeRecogniser release];
}

#pragma mark -
#pragma mark Internal messages

- (CGSize) sizeThatFits:(CGSize) size {
	CGSize newSize = CGSizeMake(self.offRatingImage.size.width * self.iconCount, self.offRatingImage.size.height);
	DC_LOG(@"sizeThatFits: returning %f x %f", newSize.width, newSize.height);
	return newSize;
}

- (void) calculateRatingAtX:(float) x {
	DC_LOG(@"x: %f", x);
	
	// Store the current touch X and handle when it's out of the controls range.
	lastTouchX = (int) x;
	lastTouchX = fmin(self.frame.size.width - 1, lastTouchX);
	lastTouchX = fmax(0, lastTouchX);
	DC_LOG(@"lastTouchX: %i", lastTouchX);
	
	float oldRating = [scaleStrategy rating];
	float newRating = [scaleStrategy calcNewRatingFromTouchX:lastTouchX];
	
	// Only trigger display updates if the rating has changed.
	if (oldRating != newRating) {
		[self setNeedsDisplay];
		
		// Notify the delegate.
		if (self.delegate != nil) {
			DC_LOG(@"Notifying delegate that rating has changed");
			[self.delegate ratingDidChange:self];
		}
	}
	
}

#pragma mark -
#pragma mark Interactions

- (IBAction) tapGesture:(UITapGestureRecognizer *)sender {
	DC_LOG(@"Tap gesture handler firing");
	[self calculateRatingAtX:[sender locationInView:self].x];
}

- (IBAction) swipeGesture:(UIPanGestureRecognizer *)sender {
	DC_LOG(@"Swipe gesture handler firing, state: %i", sender.state);
	
	// Switch based on the state.
	[self calculateRatingAtX:[sender locationInView:self].x];
	[self.bubble setValue:[scaleStrategy formattedRating]];
	switch (sender.state) {
			
		case UIGestureRecognizerStateBegan:
			DC_LOG(@"Starting touch event");
			[self.bubble positionAtView:sender.view offset:[sender locationInView:self].x];
			self.bubble.hidden = NO;
			break;
		case UIGestureRecognizerStateChanged:
			DC_LOG(@"Continuing touch event");
			[self.bubble positionAtView:sender.view offset:[sender locationInView:self].x];
			break;
		default:
			// Ended.
			DC_LOG(@"Ending touch event");
			self.bubble.hidden = YES;
			break;
	}
	
}

#pragma mark -
#pragma mark Drawing

- (void) drawRect:(CGRect) rect {                                       
	DC_LOG(@"Drawing rating control: %@", self);
	for (int i = 0; i < self.iconCount; i++) {
		[scaleStrategy drawImageAtIndex:i];
	}
}

- (void) dealloc {
	self.offRatingImage = nil;
	self.onRatingImage = nil;
	self.halfRatingImage = nil;
	self.delegate = nil;
	DC_DEALLOC(bubble);
	DC_DEALLOC(scaleStrategy);
	[super dealloc];
}

@end
