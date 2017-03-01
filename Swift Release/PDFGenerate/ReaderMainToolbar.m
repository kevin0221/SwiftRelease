//
//	ReaderMainToolbar.m
//	Reader v2.5.4
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import "AudioPlayer.h"
#import <MessageUI/MessageUI.h>

@implementation ReaderMainToolbar

#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 20.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 40.0f
#define BUTTON_WIDTH 40.0f

#define THUMBS_BUTTON_WIDTH 52.0f
#define PRINT_BUTTON_WIDTH 52.0f
#define EMAIL_BUTTON_WIDTH 52.0f

#define TITLE_HEIGHT 40.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	return [self initWithFrame:frame document:nil];
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	assert(object != nil); // Check

	if ((self = [super initWithFrame:frame]))
	{
        
        CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;

        
        CAGradientLayer *layer = (CAGradientLayer *)self.layer;
        
        UIColor *liteColor = [UIColor colorWithRed:0/255.0f green:125/255.0f blue:255/255.0f alpha:1.0f];
        UIColor *darkColor = [UIColor colorWithRed:0/255.0f green:125/255.0f blue:255/255.0f alpha:1.0f];
        layer.colors = [NSArray arrayWithObjects:(id)liteColor.CGColor, (id)darkColor.CGColor, nil];
        
        UIImage *imgBack = [UIImage imageNamed:@"back_white"];
        
		CGFloat titleX = BUTTON_X;
        CGFloat titleWidth = (viewWidth - (titleX + titleX));

		CGFloat leftButtonX = BUTTON_X; // Left button start X position

#if (READER_STANDALONE == FALSE) // Option

		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];

		doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setImage:imgBack forState:UIControlStateNormal];
        [doneButton setImage:nil forState:UIControlStateHighlighted];
        
		doneButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:doneButton]; leftButtonX += (BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_STANDALONE Option

		CGFloat rightButtonX = viewWidth; // Right button start X position

        /* delete button */
        rightButtonX -= (BUTTON_WIDTH + BUTTON_SPACE);
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        deleteButton.frame = CGRectMake(rightButtonX, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
        [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *imgDelete = [UIImage imageNamed:@"delete_white"];
        
        [deleteButton setImage:imgDelete forState:UIControlStateNormal];
        [deleteButton setImage:nil forState:UIControlStateHighlighted];
        
        //UIEdgeInsets insets = UIEdgeInsetsMake(5, 12, 5, 12);
        //[deleteButton setImageEdgeInsets:insets];
        
        [self addSubview:deleteButton];
        
        titleWidth -= (BUTTON_WIDTH + BUTTON_SPACE);
        
        //markButton = deleteButton; markButton.enabled = NO; markButton.tag = NSIntegerMin;
        
        markImageN = [UIImage imageNamed:@"Reader-Mark-N.png"]; // N image
        markImageY = [UIImage imageNamed:@"Reader-Mark-Y.png"]; // Y image

        /* end of delete button */

        /********* show title **************************/
        
		//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);

			UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            titleLabel.textAlignment = NSTextAlignmentCenter;
			titleLabel.font = [UIFont systemFontOfSize:20.0f];
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
			titleLabel.shadowColor = [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
            [titleLabel setMinimumScaleFactor:14.0f/[UIFont labelFontSize]];
			titleLabel.text = [object.fileName stringByDeletingPathExtension];

			[self addSubview:titleLabel]; 
        }
	}
    

	return self;
}

- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	markButton = nil;

	markImageN = nil;
	markImageY = nil;

}

- (void)setBookmarkState:(BOOL)state
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
    [AudioPlayer playButtonEffectSound];
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self doneButton:button];
}

- (void)thumbsButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self thumbsButton:button];
}


-(void)deleteButtonTapped:(UIButton *)button
{
    [AudioPlayer playButtonEffectSound];
    [delegate tappedInToolbar:self deleteButton:button];
}

@end
