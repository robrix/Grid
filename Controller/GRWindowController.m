// GRWindowController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRWindowController.h"

@implementation GRWindowController

+(GRWindowController *)controllerWithScreen:(NSScreen *)s {
	GRWindowController *controller = [[self alloc] initWithWindowNibName: @"GRWindow"];
	[controller loadWindow];
	controller.screen = s;
	return controller;
}

@synthesize screen;
@synthesize areaSelectionView;

-(void)awakeFromNib {
	[self.window setExcludedFromWindowsMenu: NO];
	[self.window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
	
	horizontalSelectedFractionRange = NSMakeRange(0, 1);
	verticalSelectedFractionRange = NSMakeRange(0, 1);
}


-(void)showWindow:(id)sender {
	self.window.alphaValue = 0;
	[self.window setFrameOrigin: NSMakePoint(NSMinX(self.screen.visibleFrame), self.window.frame.origin.y)];
	[super showWindow: sender];
	[self.window center];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.15];
	[self.window.animator setAlphaValue: 1.0];
	[NSAnimationContext endGrouping];
}

-(void)hideWindow:(id)sender {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.15];
	[self.window.animator setAlphaValue: 0];
	[NSAnimationContext endGrouping];
}


-(NSUInteger)maximumHorizontalFractions {
	return 6;
}

-(NSUInteger)maximumVerticalFractions {
	return 3;
}


-(NSRange)horizontalSelectedFractionRange {
	return horizontalSelectedFractionRange;
}

-(NSRange)verticalSelectedFractionRange {
	return verticalSelectedFractionRange;
}


-(NSUInteger)horizontalSelectedFraction {
	return 4;
}

-(NSUInteger)verticalSelectedFraction {
	return 2;
}


-(void)keyDown:(NSEvent *)event {
	NSRange tempHorizontalRange = horizontalSelectedFractionRange, tempVerticalRange = verticalSelectedFractionRange;
	if((event.modifierFlags & NSAlternateKeyMask) || (event.modifierFlags & NSCommandKeyMask) || (event.modifierFlags & NSControlKeyMask)) {
		NSBeep();
	} else {
		switch([event.charactersIgnoringModifiers characterAtIndex: 0]) {
		case NSLeftArrowFunctionKey:
			if(event.modifierFlags & NSShiftKeyMask) {
				horizontalSelectedFractionRange.length = (horizontalSelectedFractionRange.length > 1)
				?	horizontalSelectedFractionRange.length - 1
				:	1;
			} else {
				horizontalSelectedFractionRange.location = (horizontalSelectedFractionRange.location > 0)
				?	horizontalSelectedFractionRange.location - 1
				:	0;
			}
			break;
		case NSRightArrowFunctionKey:
			if(event.modifierFlags & NSShiftKeyMask) {
				horizontalSelectedFractionRange.length = (NSMaxRange(self.horizontalSelectedFractionRange) < self.horizontalSelectedFraction)
				?	horizontalSelectedFractionRange.length + 1
				:	horizontalSelectedFractionRange.length;
			} else {
				horizontalSelectedFractionRange.location = (NSMaxRange(self.horizontalSelectedFractionRange) < self.horizontalSelectedFraction)
				?	horizontalSelectedFractionRange.location + 1
				:	horizontalSelectedFractionRange.location;
			}
			break;
		case NSUpArrowFunctionKey:
			if(event.modifierFlags & NSShiftKeyMask) {
				verticalSelectedFractionRange.length = (NSMaxRange(self.verticalSelectedFractionRange) < self.verticalSelectedFraction)
				?	verticalSelectedFractionRange.length + 1
				:	verticalSelectedFractionRange.length;
			} else {
				verticalSelectedFractionRange.location = (NSMaxRange(self.verticalSelectedFractionRange) < self.verticalSelectedFraction)
				?	verticalSelectedFractionRange.location + 1
				:	verticalSelectedFractionRange.location;
			}
			break;
		case NSDownArrowFunctionKey:
			if(event.modifierFlags & NSShiftKeyMask) {
				verticalSelectedFractionRange.length = (verticalSelectedFractionRange.location > 1)
				?	verticalSelectedFractionRange.length - 1
				:	1;
			} else {
				verticalSelectedFractionRange.location = (verticalSelectedFractionRange.location > 0)
				?	verticalSelectedFractionRange.location - 1
				:	0;
			}
			break;
		}
	}
	
	if(!NSEqualRanges(tempHorizontalRange, horizontalSelectedFractionRange) || !NSEqualRanges(tempVerticalRange, verticalSelectedFractionRange))
		[self.areaSelectionView setNeedsDisplay: YES];
	else
		NSBeep();
}

@end