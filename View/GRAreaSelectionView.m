// GRAreaSelectionView.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRAreaSelectionView.h"

@implementation GRAreaSelectionView

-(CGRect)selectedAreaForBounds:(CGRect)bounds {
	NSRange horizontal = self.delegate.selectedHorizontalFractionRange, vertical = self.delegate.selectedVerticalFractionRange;
	NSSize fraction = NSMakeSize(
		NSWidth(bounds) / self.delegate.selectedHorizontalFraction,
		NSHeight(bounds) / self.delegate.selectedVerticalFraction
	);
	NSRect selectedArea = {
		.origin.x = fraction.width * horizontal.location,
		.origin.y = fraction.height * vertical.location,
		.size.width = fraction.width * horizontal.length,
		.size.height = fraction.height * vertical.length,
	};
	return NSIntegralRect(CGRectOffset(selectedArea, bounds.origin.x, bounds.origin.y));
}

-(void)drawRect:(NSRect)rect {
	[[NSColor colorWithCalibratedWhite:1 alpha:0.1] setStroke];
	
	// inactive horizontal fractions
	NSBezierPath *path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumHorizontalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / fraction) * n) + 0.5, 0)];
			[path lineToPoint: NSMakePoint(roundf((NSWidth(self.bounds) / fraction) * n) + 0.5, NSHeight(self.bounds))];
		}
	}
	[path stroke];
	
	// inactive vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumVerticalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(0, roundf((NSHeight(self.bounds) / fraction) * n) + 0.5)];
			[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((NSHeight(self.bounds) / fraction) * n) + 0.5)];
		}
	}
	[path stroke];
	
	[[NSColor whiteColor] setStroke];
	
	// active horizontal fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.selectedHorizontalFraction; n++) {
		[path moveToPoint:(NSPoint){ .x = roundf((NSWidth(self.bounds) / self.delegate.selectedHorizontalFraction) * n) + 0.5 }];
		[path lineToPoint:(NSPoint){ .x = roundf((NSWidth(self.bounds) / self.delegate.selectedHorizontalFraction) * n) + 0.5, .y = NSHeight(self.bounds) }];
	}
	[path stroke];
	
	// active vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.selectedVerticalFraction; n++) {
		[path moveToPoint:(NSPoint){ .y = roundf((NSHeight(self.bounds) / self.delegate.selectedVerticalFraction) * n) + 0.5}];
		[path lineToPoint:(NSPoint){ .x = NSWidth(self.bounds), .y = roundf((NSHeight(self.bounds) / self.delegate.selectedVerticalFraction) * n) + 0.5}];
	}
	[path stroke];
	
	// view bounds
	[[NSBezierPath bezierPathWithRect: NSInsetRect(self.bounds, 0.5, 0.5)] stroke];
	
	// selected area
	[[[NSColor alternateSelectedControlColor] colorWithAlphaComponent:0.7] set];
	CGRect selectedArea = [self selectedAreaForBounds: self.bounds];
	path = [NSBezierPath bezierPathWithRect: NSOffsetRect(selectedArea, 0.5f, 0.5f)];
	[path fill];
	[path stroke];
}

@end