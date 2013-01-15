// GRAreaSelectionView.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRAreaSelectionView.h"

@implementation GRAreaSelectionView

@synthesize delegate;

-(CGRect)selectedAreaForBounds:(CGRect)bounds {
	NSRange selectedHorizontalFractionRange = self.delegate.selectedHorizontalFractionRange, selectedVerticalFractionRange = self.delegate.selectedVerticalFractionRange;
	NSSize fractionSize = NSMakeSize(
		NSWidth(bounds) / self.delegate.selectedHorizontalFraction,
		NSHeight(bounds) / self.delegate.selectedVerticalFraction
	);
	NSRect selectedArea;
	selectedArea.origin = NSMakePoint(
		roundf(fractionSize.width * selectedHorizontalFractionRange.location),
		roundf(fractionSize.height * selectedVerticalFractionRange.location)
	);
	selectedArea.size = NSMakeSize(
		roundf((fractionSize.width * selectedHorizontalFractionRange.location) + (fractionSize.width * selectedHorizontalFractionRange.length) - selectedArea.origin.x),
		roundf((fractionSize.height * selectedVerticalFractionRange.location) + (fractionSize.height * selectedVerticalFractionRange.length) - selectedArea.origin.y)
	); // this is done this absurd way to avoid rounding errors (and thus the boundaries of the selection area being drawn one pixel too high or low)
	return selectedArea;
}

-(void)drawRect:(NSRect)rect {
	[[NSColor colorWithDeviceWhite: 1.0f alpha: 0.10f] setStroke];
	
	// inactive horizontal fractions
	NSBezierPath *path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumHorizontalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / fraction) * n) + 0.5f, 0)];
			[path lineToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / fraction) * n) + 0.5f, NSHeight(self.bounds))];
		}
	}
	[path stroke];
	
	// inactive vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumVerticalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(0, roundf((NSHeight(self.bounds) / fraction) * n) + 0.5f)];
			[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((NSHeight(self.bounds) / fraction) * n) + 0.5f)];
		}
	}
	[path stroke];
	
	
	[[[NSColor colorForControlTint: [NSColor currentControlTint]] blendedColorWithFraction: 0.1f ofColor: [NSColor clearColor]] setFill];
	[[NSColor whiteColor] setStroke];
	
	// active horizontal fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.selectedHorizontalFraction; n++) {
		[path moveToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / self.delegate.selectedHorizontalFraction) * n) + 0.5f, 0)];
		[path lineToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / self.delegate.selectedHorizontalFraction) * n) + 0.5f, NSHeight(self.bounds))];
	}
	[path stroke];
	
	// active vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.selectedVerticalFraction; n++) {
		[path moveToPoint: NSMakePoint(0, roundf((NSHeight(self.bounds) / self.delegate.selectedVerticalFraction) * n) + 0.5f)];
		[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((NSHeight(self.bounds) / self.delegate.selectedVerticalFraction) * n) + 0.5f)];
	}
	[path stroke];
	
	// selected area
	CGRect selectedArea = [self selectedAreaForBounds: self.bounds];
	path = [NSBezierPath bezierPathWithRect: NSOffsetRect(selectedArea, 0.5f, 0.5f)];
	[path fill];
	[path stroke];
	
	// view bounds
	[[NSBezierPath bezierPathWithRect: NSInsetRect(self.bounds, 0.5, 0.5)] stroke];
}

@end