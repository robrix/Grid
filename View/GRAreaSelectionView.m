// GRAreaSelectionView.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"

@implementation GRAreaSelectionView

@synthesize delegate;

-(void)drawRect:(NSRect)rect {
	[[NSColor colorWithDeviceWhite: 1.0f alpha: 0.25f] setStroke];
	
	// inactive horizontal fractions
	NSBezierPath *path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumHorizontalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, 0)];
			[path lineToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, NSHeight(self.bounds))];
		}
	}
	[path stroke];
	
	// inactive vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumVerticalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(0, roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
			[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
		}
	}
	[path stroke];
	
	
	[[[NSColor colorForControlTint: [NSColor currentControlTint]] blendedColorWithFraction: 0.1f ofColor: [NSColor clearColor]] setFill];
	[[NSColor whiteColor] setStroke];
	
	// active horizontal fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.horizontalSelectedFraction; n++) {
		[path moveToPoint: NSMakePoint(roundf((self.bounds.size.width / self.delegate.horizontalSelectedFraction) * n) + 0.5f, 0)];
		[path lineToPoint: NSMakePoint(roundf((self.bounds.size.width / self.delegate.horizontalSelectedFraction) * n) + 0.5f, NSHeight(self.bounds))];
	}
	[path stroke];
	
	// active vertical fractions
	path = [NSBezierPath bezierPath];
	for(NSUInteger n = 1; n < self.delegate.verticalSelectedFraction; n++) {
		[path moveToPoint: NSMakePoint(0, roundf((self.bounds.size.height / self.delegate.verticalSelectedFraction) * n) + 0.5f)];
		[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((self.bounds.size.height / self.delegate.verticalSelectedFraction) * n) + 0.5f)];
	}
	[path stroke];
	
	// selected area
	NSSize fractionSize = NSMakeSize(
		self.bounds.size.width / self.delegate.horizontalSelectedFraction,
		self.bounds.size.height / self.delegate.verticalSelectedFraction
	);
	NSRange horizontalSelectedFractionRange = self.delegate.horizontalSelectedFractionRange, verticalSelectedFractionRange = self.delegate.verticalSelectedFractionRange;
	NSRect selectedArea = NSMakeRect(
		roundf(fractionSize.width * horizontalSelectedFractionRange.location) + 0.5f, roundf(fractionSize.height * verticalSelectedFractionRange.location) + 0.5f,
		roundf(fractionSize.width * horizontalSelectedFractionRange.length), roundf(fractionSize.height * verticalSelectedFractionRange.length)
	);
	path = [NSBezierPath bezierPathWithRect: selectedArea];
	[path fill];
	[path stroke];
	
	// view bounds
	[[NSBezierPath bezierPathWithRect: NSInsetRect(self.bounds, 0.5, 0.5)] stroke];
}

@end