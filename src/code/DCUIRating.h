//
//  DCUIRating.h
//  dUsefulStuff
//
//  Created by Derek Clarkson on 23/03/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <UIKit/UIControl.h>
#import "DCUIBubble.h"

/**
 * What type of scale the control uses.
 */
enum DCScaleEnum {
	DC_SCALE_0_TO_5,
	// 0, 1, 2, 3 ... 5

	DC_SCALE_0_TO_5_WITH_HALVES,
	// 0, 0.5, 1, 1.5, ... 5

	DC_SCALE_0_TO_10
	// 0, 1, 2, 3, ... 10
};
typedef enum DCScaleEnum DCRATINGSCALE;

/**
 * This control provides a rating display similar to that seen in iTunes for rating songs. It draws a set of 5 icons across the display which the user can use to select a rating from 0 to 5.
 * The user can select a rating value by either taping the control at the rating they want, or swiping their finger back and forwards to adjust the rating. However they must start the swipe inside the control.
 *
 * There are three options for the value of the rating. Like iTunes the default is a value from 0 - 5. Each icon from left to right represents 1 rating value, so tapping the second icon from the right will choose a rating of 4 out of 5. However you can also select to using ratings from 0 to 10 or 0 - 5 with half values. This is represented by the control drawing half stars for either the odd numbers or half values.
 *
 * The developer can also choose to display a popup bubble above the rating controller. This bubble tracks the
 * users touch and displays the value during the touch operation. It appears at the first touch and disappears when
 * the touch leaves. This bubble can be configured with an image background (setting this causes the bubble to be displayed), font, text colour and text position.
 */
@interface DCUIRating : UIControl {
	@private

	// Public interface variables.
	UIImage *offRatingImage;
	UIImage *onRatingImage;
	UIImage *halfRatingImage;
	DCRATINGSCALE scaleType;
	float rating;
	DCUIBubble *bubble;
	NSNumberFormatter *decimalFormatter;

	// Internal use for display and layout.
	int offsetPixels;
	int segmentSize;
	float fuzzFactor;
	int lastTouchX;
}

/** \name Properties */

/**
 * Defines the range of values that the control will produce. There are three options:
 * \li DC_SCALE_0_TO_5 - produces 0, 1, 2, 3, 5
 * \li DC_SCALE_0_TO_5_WITH_HALVES - produces 0, 0.5, 1, 1.5, ... 5
 * \li DC_SCALE_0_TO_10 - produces 0, 1, 2, 3, ... 10
 */
@property (nonatomic) DCRATINGSCALE scaleType;

/**
 * The current value of the control. This value depends on the current setting of the scaleType; Set this value to have the control light up the necessary rating images.
 */
@property (nonatomic) float rating;

/** \name Icons */
/**
 * The image to use for when a rating is on.
 */
@property (nonatomic, retain) UIImage *onRatingImage;

/**
 * The image to use for when a rating is off.
 */
@property (nonatomic, retain) UIImage *offRatingImage;

/**
 * If the scale type is 0 - 10 or 0 - 5 with halves, then this image is used to display the half/odd values.
 */
@property (nonatomic, retain) UIImage *halfRatingImage;

@property (nonatomic,retain) DCUIBubble * bubble;

@end
