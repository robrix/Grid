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
	
	selectedHorizontalFractionRange = NSMakeRange(0, 1);
	selectedVerticalFractionRange = NSMakeRange(0, 1);
	
	selectedHorizontalFraction = 2;
	selectedVerticalFraction = 2;
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


-(NSRange)selectedHorizontalFractionRange {
	return selectedHorizontalFractionRange;
}

-(NSRange)selectedVerticalFractionRange {
	return selectedVerticalFractionRange;
}


-(NSUInteger)selectedHorizontalFraction {
	return selectedHorizontalFraction;
}

-(NSUInteger)selectedVerticalFraction {
	return selectedVerticalFraction;
}


-(void)moveBackward:(id)sender {
	selectedHorizontalFractionRange.location = (selectedHorizontalFractionRange.location > 0)
	?	selectedHorizontalFractionRange.location - 1
	:	0;
}

-(void)moveBackwardAndModifySelection:(id)sender {
	if(selectedHorizontalFractionRange.location > 0) {
		selectedHorizontalFractionRange.length += 1;
		selectedHorizontalFractionRange.location -= 1;
	} else if(selectedHorizontalFractionRange.length > 1) {
		selectedHorizontalFractionRange.length -= 1;
	}
}

-(void)moveForward:(id)sender {
	selectedHorizontalFractionRange.location = (NSMaxRange(selectedHorizontalFractionRange) < selectedHorizontalFraction)
	?	selectedHorizontalFractionRange.location + 1
	:	selectedHorizontalFractionRange.location;
}

-(void)moveForwardAndModifySelection:(id)sender {
	if(NSMaxRange(selectedHorizontalFractionRange) < selectedHorizontalFraction) {
		selectedHorizontalFractionRange.length += 1;
	} else if(selectedHorizontalFractionRange.length >= 2) {
		selectedHorizontalFractionRange.location += 1;
		selectedHorizontalFractionRange.length -= 1;
	}
}

-(void)moveUp:(id)sender {
	selectedVerticalFractionRange.location = (NSMaxRange(selectedVerticalFractionRange) < selectedVerticalFraction)
	?	selectedVerticalFractionRange.location + 1
	:	selectedVerticalFractionRange.location;
}

-(void)moveUpAndModifySelection:(id)sender {
	if(NSMaxRange(selectedVerticalFractionRange) < selectedVerticalFraction) {
		selectedVerticalFractionRange.length += 1;
	} else if(selectedVerticalFractionRange.length >= 2) {
		selectedVerticalFractionRange.location += 1;
		selectedVerticalFractionRange.length -= 1;
	}
}

-(void)moveDown:(id)sender {
	selectedVerticalFractionRange.location = (selectedVerticalFractionRange.location > 0)
	?	selectedVerticalFractionRange.location - 1
	:	0;
}

-(void)moveDownAndModifySelection:(id)sender {
	if(selectedVerticalFractionRange.location > 0) {
		selectedVerticalFractionRange.length += 1;
		selectedVerticalFractionRange.location -= 1;
	} else if(selectedVerticalFractionRange.length > 1) {
		selectedVerticalFractionRange.length -= 1;
	}
}

-(BOOL)respondsToSelector:(SEL)selector { // hack to keep the panel from sending us moveUp: and moveDown: on ⌘↑ and ⌘↓
	BOOL result = [super respondsToSelector: selector];
	if(sel_isEqual(selector, @selector(moveDown:)) || sel_isEqual(selector, @selector(moveUp:)))
		result = NO;
	return result;
}


-(void)increaseHorizontalFractionSize:(id)sender {
	selectedHorizontalFraction = (selectedHorizontalFraction > 2)
	?	selectedHorizontalFraction - 1
	:	2;
	if(NSMaxRange(selectedHorizontalFractionRange) > selectedHorizontalFraction) {
		selectedHorizontalFractionRange.length -= 1;
	}
}

-(void)decreaseHorizontalFractionSize:(id)sender {
	if(NSEqualRanges(selectedHorizontalFractionRange, NSMakeRange(0, selectedHorizontalFraction))) {
		selectedHorizontalFractionRange.length += 1;
	}
	selectedHorizontalFraction = (selectedHorizontalFraction < self.maximumHorizontalFractions)
	?	selectedHorizontalFraction + 1
	:	selectedHorizontalFraction;
}

-(void)increaseVerticalFractionSize:(id)sender {
	selectedVerticalFraction = (selectedVerticalFraction > 2)
	?	selectedVerticalFraction - 1
	:	2;
	if(NSMaxRange(selectedVerticalFractionRange) > selectedVerticalFraction) {
		selectedVerticalFractionRange.length -= 1;
	}
}

-(void)decreaseVerticalFractionSize:(id)sender {
	if(NSEqualRanges(selectedVerticalFractionRange, NSMakeRange(0, selectedVerticalFraction))) {
		selectedVerticalFractionRange.length += 1;
	}
	selectedVerticalFraction = (selectedVerticalFraction < self.maximumVerticalFractions)
	?	selectedVerticalFraction + 1
	:	selectedVerticalFraction;
}


-(void)selectAll:(id)sender {
	selectedHorizontalFractionRange = NSMakeRange(0, selectedHorizontalFraction);
	selectedVerticalFractionRange = NSMakeRange(0, selectedVerticalFraction);
	[self.areaSelectionView setNeedsDisplay: YES];
}


-(void)keyDown:(NSEvent *)event {
	NSRange tempHorizontalRange = selectedHorizontalFractionRange, tempVerticalRange = selectedVerticalFractionRange;
	NSUInteger tempHorizontalFraction = selectedHorizontalFraction, tempVerticalFraction = selectedVerticalFraction;
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
		!NSEqualRanges(tempHorizontalRange, selectedHorizontalFractionRange)
	||	!NSEqualRanges(tempVerticalRange, selectedVerticalFractionRange)
	||	(tempHorizontalFraction != selectedHorizontalFraction)
	||	(tempVerticalFraction != selectedVerticalFraction)
	)
		[self.areaSelectionView setNeedsDisplay: YES];
	else
		NSBeep();
}

@end
