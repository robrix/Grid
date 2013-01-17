// GRWindowController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRWindowController.h"
#import <objc/runtime.h>

NSString * const GRSelectedHorizontalFractionKey = @"GRSelectedHorizontalFractionKey";
NSString * const GRSelectedHorizontalFractionRangeKey = @"GRSelectedHorizontalFractionRangeKey";
NSString * const GRSelectedVerticalFractionKey = @"GRSelectedVerticalFractionKey";
NSString * const GRSelectedVerticalFractionRangeKey = @"GRSelectedVerticalFractionRangeKey";

@interface GRWindowController ()

@property (nonatomic, assign) NSRange selectedHorizontalFractionRange;
@property (nonatomic, assign) NSRange selectedVerticalFractionRange;
@property (nonatomic, assign) NSUInteger selectedHorizontalFraction;
@property (nonatomic, assign) NSUInteger selectedVerticalFraction;

@end

@implementation GRWindowController

@synthesize areaSelectionView = _areaSelectionView;
@synthesize screen = _screen;
@synthesize delegate = _delegate;


+(void)initialize {
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{
	 GRSelectedHorizontalFractionKey: @(2),
	 GRSelectedVerticalFractionKey: @(2),
	 GRSelectedHorizontalFractionRangeKey: NSStringFromRange(NSMakeRange(0, 1)),
	 GRSelectedVerticalFractionRangeKey: NSStringFromRange(NSMakeRange(0, 1)),
	 }];
}


+(GRWindowController *)controllerWithScreen:(NSScreen *)s {
	GRWindowController *controller = [[[self alloc] initWithWindowNibName: @"GRWindow"] autorelease];
	[controller loadWindow];
	controller.screen = s;
	return controller;
}

-(void)dealloc {
	[_areaSelectionView release];
	[_screen release];
	
	[super dealloc];
}


-(void)awakeFromNib {
	[self.window setExcludedFromWindowsMenu: NO];
	[self.window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.selectedHorizontalFractionRange = NSRangeFromString([defaults stringForKey:GRSelectedHorizontalFractionRangeKey]);
	self.selectedVerticalFractionRange = NSRangeFromString([defaults stringForKey:GRSelectedVerticalFractionRangeKey]);
	
	self.selectedHorizontalFraction = [defaults integerForKey:GRSelectedHorizontalFractionKey];
	self.selectedVerticalFraction = [defaults integerForKey:GRSelectedVerticalFractionKey];
}


-(void)activate {
	self.window.alphaValue = 0;
	
	NSRect contentFrame = self.screen.visibleFrame;
	contentFrame.size.width /= 4.0f;
	contentFrame.size.height /= 4.0f;
	contentFrame.origin.x += contentFrame.size.width * 1.5f - 20.0f;
	contentFrame.origin.y += contentFrame.size.height * 1.5f - 20.0f;
	contentFrame.size.width += 40.0f;
	contentFrame.size.height += 40.0f;
	[self.window setFrame: [self.window contentRectForFrameRect: contentFrame] display: YES];
	
	[self.window makeKeyAndOrderFront: self];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.1f];
	[self.window.animator setAlphaValue: 1.0];
	[NSAnimationContext endGrouping];
}

-(void)deactivate {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.1f];
	[self.window.animator setAlphaValue: 0];
	[NSAnimationContext endGrouping];
	
	[self.window performSelector: @selector(orderOut:) withObject: self afterDelay: 0.1f];
}


-(void)setSelectedHorizontalFraction:(NSUInteger)selectedHorizontalFraction {
	_selectedHorizontalFraction = selectedHorizontalFraction;
	
	[[NSUserDefaults standardUserDefaults] setInteger:selectedHorizontalFraction forKey:GRSelectedHorizontalFractionKey];
}

-(void)setSelectedVerticalFraction:(NSUInteger)selectedVerticalFraction {
	_selectedVerticalFraction = selectedVerticalFraction;
	
	[[NSUserDefaults standardUserDefaults] setInteger:selectedVerticalFraction forKey:GRSelectedVerticalFractionKey];
}

-(void)setSelectedHorizontalFractionRange:(NSRange)selectedHorizontalFractionRange {
	_selectedHorizontalFractionRange = selectedHorizontalFractionRange;
	
	[[NSUserDefaults standardUserDefaults] setObject:NSStringFromRange(selectedHorizontalFractionRange) forKey:GRSelectedHorizontalFractionRangeKey];
}

-(void)setSelectedVerticalFractionRange:(NSRange)selectedVerticalFractionRange {
	_selectedVerticalFractionRange = selectedVerticalFractionRange;
	
	[[NSUserDefaults standardUserDefaults] setObject:NSStringFromRange(selectedVerticalFractionRange) forKey:GRSelectedVerticalFractionRangeKey];
}


-(NSUInteger)maximumHorizontalFractions {
	return 8;
}

-(NSUInteger)maximumVerticalFractions {
	return 4;
}


-(void)moveBackward:(id)sender {
	NSRange range = self.selectedHorizontalFractionRange;
	range.location = (range.location > 0)?
		range.location - 1
	:	0;
	self.selectedHorizontalFractionRange = range;
}

-(void)moveBackwardAndModifySelection:(id)sender {
	NSRange range = self.selectedHorizontalFractionRange;
	if(range.location > 0) {
		range.length += 1;
		range.location -= 1;
	} else if(range.length > 1) {
		range.length -= 1;
	}
	self.selectedHorizontalFractionRange = range;
}

-(void)moveForward:(id)sender {
	NSRange range = self.selectedHorizontalFractionRange;
	range.location = (NSMaxRange(range) < self.selectedHorizontalFraction)?
		range.location + 1
	:	range.location;
	self.selectedHorizontalFractionRange = range;
}

-(void)moveForwardAndModifySelection:(id)sender {
	NSRange range = self.selectedHorizontalFractionRange;
	if(NSMaxRange(range) < self.selectedHorizontalFraction) {
		range.length += 1;
	} else if(range.length >= 2) {
		range.location += 1;
		range.length -= 1;
	}
	self.selectedHorizontalFractionRange = range;
}

-(void)moveUp:(id)sender {
	NSRange range = self.selectedVerticalFractionRange;
	range.location = (NSMaxRange(range) < self.selectedVerticalFraction)?
		range.location + 1
	:	range.location;
	self.selectedVerticalFractionRange = range;
}

-(void)moveUpAndModifySelection:(id)sender {
	NSRange range = self.selectedVerticalFractionRange;
	if(NSMaxRange(range) < self.selectedVerticalFraction) {
		range.length += 1;
	} else if(range.length >= 2) {
		range.location += 1;
		range.length -= 1;
	}
	self.selectedVerticalFractionRange = range;
}

-(void)moveDown:(id)sender {
	NSRange range = self.selectedVerticalFractionRange;
	range.location = (range.location > 0)?
		range.location - 1
	:	0;
	self.selectedVerticalFractionRange = range;
}

-(void)moveDownAndModifySelection:(id)sender {
	NSRange range = self.selectedVerticalFractionRange;
	if(range.location > 0) {
		range.length += 1;
		range.location -= 1;
	} else if(range.length > 1) {
		range.length -= 1;
	}
	self.selectedVerticalFractionRange = range;
}

-(BOOL)respondsToSelector:(SEL)selector { // hack to keep the panel from sending us moveUp: and moveDown: on ⌘↑ and ⌘↓
	BOOL result = [super respondsToSelector: selector];
	if(sel_isEqual(selector, @selector(moveDown:)) || sel_isEqual(selector, @selector(moveUp:)))
		result = NO;
	return result;
}


-(void)increaseHorizontalFractionSize:(id)sender {
	self.selectedHorizontalFraction = (self.selectedHorizontalFraction > 2)?
		self.selectedHorizontalFraction - 1
	:	2;
	NSRange range = self.selectedHorizontalFractionRange;
	if(range.location == self.selectedHorizontalFraction) {
		range.location -= 1;
	}
	if(NSMaxRange(range) > self.selectedHorizontalFraction) {
		range.length -= 1;
	}
	self.selectedHorizontalFractionRange = range;
}

-(void)decreaseHorizontalFractionSize:(id)sender {
	NSRange range = self.selectedHorizontalFractionRange;
	if(NSEqualRanges(range, NSMakeRange(0, self.selectedHorizontalFraction))) {
		range.length += 1;
	}
	self.selectedHorizontalFractionRange = range;
	self.selectedHorizontalFraction = (self.selectedHorizontalFraction < self.maximumHorizontalFractions)?
		self.selectedHorizontalFraction + 1
	:	self.selectedHorizontalFraction;
}

-(void)increaseVerticalFractionSize:(id)sender {
	self.selectedVerticalFraction = (self.selectedVerticalFraction > 2)?
		self.selectedVerticalFraction - 1
	:	2;
	NSRange range = self.selectedVerticalFractionRange;
	if(range.location == self.selectedVerticalFraction) {
		range.location -= 1;
	}
	if(NSMaxRange(range) > self.selectedVerticalFraction) {
		range.length -= 1;
	}
	self.selectedVerticalFractionRange = range;
}

-(void)decreaseVerticalFractionSize:(id)sender {
	NSRange range = self.selectedVerticalFractionRange;
	if(NSEqualRanges(range, NSMakeRange(0, self.selectedVerticalFraction))) {
		range.length += 1;
	}
	self.selectedVerticalFractionRange = range;
	self.selectedVerticalFraction = (self.selectedVerticalFraction < self.maximumVerticalFractions)?
		self.selectedVerticalFraction + 1
	:	self.selectedVerticalFraction;
}


-(void)selectAll:(id)sender {
	self.selectedHorizontalFractionRange = NSMakeRange(0, self.selectedHorizontalFraction);
	self.selectedVerticalFractionRange = NSMakeRange(0, self.selectedVerticalFraction);
	self.areaSelectionView.needsDisplay = YES;
}


-(CGRect)selectedArea {
	CGRect selectedArea = [self.areaSelectionView selectedAreaForBounds: self.screen.visibleFrame];
	selectedArea.origin.x += self.screen.visibleFrame.origin.x;
	selectedArea.origin.y += self.screen.visibleFrame.origin.y;
	return selectedArea;
}


-(void)resizeActiveWindowToSelectedFraction {
	[self.delegate windowController: self didSelectArea: self.selectedArea];
	
	[self.delegate deactivate];
}


-(void)windowDidResignKey:(NSNotification *)notification {
	// [self deactivate];
}


-(void)cancel:(id)sender {
	[self.delegate deactivate];
}


-(void)keyDown:(NSEvent *)event {
	NSRange tempHorizontalRange = self.selectedHorizontalFractionRange, tempVerticalRange = self.selectedVerticalFractionRange;
	NSUInteger tempHorizontalFraction = self.selectedHorizontalFraction, tempVerticalFraction = self.selectedVerticalFraction;
	switch([event.charactersIgnoringModifiers characterAtIndex: 0]) {
	case NSCarriageReturnCharacter:
	case NSEnterCharacter:
		[self resizeActiveWindowToSelectedFraction];
		return;
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
		!NSEqualRanges(tempHorizontalRange, self.selectedHorizontalFractionRange)
	||	!NSEqualRanges(tempVerticalRange, self.selectedVerticalFractionRange)
	||	(tempHorizontalFraction != self.selectedHorizontalFraction)
	||	(tempVerticalFraction != self.selectedVerticalFraction)
	)
		self.areaSelectionView.needsDisplay = YES;
	else
		NSBeep();
}

@end
