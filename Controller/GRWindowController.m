// GRWindowController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRWindowController.h"
#import <objc/runtime.h>

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
	
	horizontalSelectedFraction = 2;
	verticalSelectedFraction = 2;
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
	return horizontalSelectedFraction;
}

-(NSUInteger)verticalSelectedFraction {
	return verticalSelectedFraction;
}


-(void)moveBackward:(id)sender {
	horizontalSelectedFractionRange.location = (horizontalSelectedFractionRange.location > 0)
	?	horizontalSelectedFractionRange.location - 1
	:	0;
}

-(void)moveBackwardAndModifySelection:(id)sender {
	horizontalSelectedFractionRange.length = (horizontalSelectedFractionRange.length > 1)
	?	horizontalSelectedFractionRange.length - 1
	:	1;
}

-(void)moveForward:(id)sender {
	horizontalSelectedFractionRange.location = (NSMaxRange(self.horizontalSelectedFractionRange) < self.horizontalSelectedFraction)
	?	horizontalSelectedFractionRange.location + 1
	:	horizontalSelectedFractionRange.location;
}

-(void)moveForwardAndModifySelection:(id)sender {
	horizontalSelectedFractionRange.length = (NSMaxRange(self.horizontalSelectedFractionRange) < self.horizontalSelectedFraction)
	?	horizontalSelectedFractionRange.length + 1
	:	horizontalSelectedFractionRange.length;
}

-(void)moveUp:(id)sender {
	verticalSelectedFractionRange.location = (NSMaxRange(self.verticalSelectedFractionRange) < self.verticalSelectedFraction)
	?	verticalSelectedFractionRange.location + 1
	:	verticalSelectedFractionRange.location;
}

-(void)moveUpAndModifySelection:(id)sender {
	verticalSelectedFractionRange.length = (NSMaxRange(self.verticalSelectedFractionRange) < self.verticalSelectedFraction)
	?	verticalSelectedFractionRange.length + 1
	:	verticalSelectedFractionRange.length;
}

-(void)moveDown:(id)sender {
	verticalSelectedFractionRange.location = (verticalSelectedFractionRange.location > 0)
	?	verticalSelectedFractionRange.location - 1
	:	0;
}

-(void)moveDownAndModifySelection:(id)sender {
	verticalSelectedFractionRange.length = (verticalSelectedFractionRange.location > 1)
	?	verticalSelectedFractionRange.length - 1
	:	1;
}

-(BOOL)respondsToSelector:(SEL)selector { // hack to keep the panel from sending us moveUp: and moveDown: on ⌘↑ and ⌘↓
	BOOL result = [super respondsToSelector: selector];
	if(sel_isEqual(selector, @selector(moveDown:)) || sel_isEqual(selector, @selector(moveUp:)))
		result = NO;
	return result;
}


-(void)increaseHorizontalFractionSize:(id)sender {
	horizontalSelectedFraction = (horizontalSelectedFraction > 2)
	?	horizontalSelectedFraction - 1
	:	2;
}

-(void)decreaseHorizontalFractionSize:(id)sender {
	horizontalSelectedFraction = (horizontalSelectedFraction <= self.maximumHorizontalFractions)
	?	horizontalSelectedFraction + 1
	:	horizontalSelectedFraction;
}

-(void)increaseVerticalFractionSize:(id)sender {
	verticalSelectedFraction = (verticalSelectedFraction > 2)
	?	verticalSelectedFraction - 1
	:	2;
}

-(void)decreaseVerticalFractionSize:(id)sender {
	verticalSelectedFraction = (verticalSelectedFraction < self.maximumVerticalFractions)
	?	verticalSelectedFraction + 1
	:	verticalSelectedFraction;
}


-(void)keyDown:(NSEvent *)event {
	NSRange tempHorizontalRange = horizontalSelectedFractionRange, tempVerticalRange = verticalSelectedFractionRange;
	NSUInteger tempHorizontalFraction = horizontalSelectedFraction, tempVerticalFraction = verticalSelectedFraction;
	switch([event.charactersIgnoringModifiers characterAtIndex: 0]) {
	case NSLeftArrowFunctionKey:
		if(event.modifierFlags & NSShiftKeyMask) {
			[self moveBackwardAndModifySelection: nil];
		} else if(event.modifierFlags & NSCommandKeyMask) {
			[self decreaseHorizontalFractionSize: nil];
		} else {
			[self moveBackward: nil];
		}
		break;
	case NSRightArrowFunctionKey:
		if(event.modifierFlags & NSShiftKeyMask) {
			[self moveForwardAndModifySelection: nil];
		} else if(event.modifierFlags & NSCommandKeyMask) {
			[self increaseHorizontalFractionSize: nil];
		} else {
			[self moveForward: nil];
		}
		break;
	case NSUpArrowFunctionKey:
		if(event.modifierFlags & NSShiftKeyMask) {
			[self moveUpAndModifySelection: nil];
		} else if(event.modifierFlags & NSCommandKeyMask) {
			[self increaseVerticalFractionSize: nil];
		} else {
			[self moveUp: nil];
		}
		break;
	case NSDownArrowFunctionKey:
		if(event.modifierFlags & NSShiftKeyMask) {
			[self moveDownAndModifySelection: nil];
		} else if(event.modifierFlags & NSCommandKeyMask) {
			[self decreaseVerticalFractionSize: nil];
		} else {
			[self moveDown: nil];
		}
		break;
	}
	
	if(
		!NSEqualRanges(tempHorizontalRange, horizontalSelectedFractionRange)
	||	!NSEqualRanges(tempVerticalRange, verticalSelectedFractionRange)
	||	(tempHorizontalFraction != horizontalSelectedFraction)
	||	(tempVerticalFraction != verticalSelectedFraction)
	)
		[self.areaSelectionView setNeedsDisplay: YES];
	else
		NSBeep();
}

@end
