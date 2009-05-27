// GRAreaSelectionView.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"

@implementation GRAreaSelectionView

@synthesize delegate;

-(void)drawRect:(NSRect)rect {
	[[NSColor colorWithDeviceWhite: 1.0f alpha: 0.25f] setStroke];
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumHorizontalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, 0)];
			[path lineToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, NSHeight(self.bounds))];
		}
	}
	[path stroke];
	
	path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= self.delegate.maximumVerticalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(0, roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
			[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
		}
	}
	[path stroke];
	
	path = [NSBezierPath bezierPathWithRect: NSInsetRect(self.bounds, 0.5, 0.5)];
	[path stroke];
	
	[[[NSColor colorForControlTint: [NSColor currentControlTint]] blendedColorWithFraction: 0.1f ofColor: [NSColor clearColor]] setFill];
	[[[[NSColor colorForControlTint: [NSColor currentControlTint]] blendedColorWithFraction: 0.1f ofColor: [NSColor clearColor]] blendedColorWithFraction: 0.5f ofColor: [NSColor whiteColor]] setStroke];
	
	NSSize fractionSize = NSMakeSize(
		roundf(self.bounds.size.width / self.delegate.horizontalSelectedFraction) + 0.5f,
		roundf(self.bounds.size.height / self.delegate.verticalSelectedFraction) + 0.5f
	);
	NSRange horizontalSelectedFractionRange = self.delegate.horizontalSelectedFractionRange, verticalSelectedFractionRange = self.delegate.verticalSelectedFractionRange;
	NSRect selectedArea = NSMakeRect(
		fractionSize.width * horizontalSelectedFractionRange.location, fractionSize.height * verticalSelectedFractionRange.location,
		fractionSize.width * horizontalSelectedFractionRange.length, fractionSize.height * verticalSelectedFractionRange.length
	);
	path = [NSBezierPath bezierPathWithRect: selectedArea];
	[path fill];
	[path stroke];
}

@end