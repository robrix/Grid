// GRAreaSelectionView.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"

@implementation GRAreaSelectionView

@synthesize delegate;

-(void)setDelegate:(id<GRAreaSelectionViewDelegate>)newDelegate {
	delegate = newDelegate;
	horizontalSelectedRange = delegate.horizontalSelectedRange;
	verticalSelectedRange = delegate.verticalSelectedRange;
	maximumHorizontalFractions = delegate.maximumHorizontalFractions;
	maximumVerticalFractions = delegate.maximumVerticalFractions;
}

-(void)drawRect:(NSRect)rect {
	[[NSColor whiteColor] setStroke];
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= maximumHorizontalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, 0)];
			[path lineToPoint: NSMakePoint(roundf((self.bounds.size.width / fraction) * n) + 0.5f, NSHeight(self.bounds))];
		}
	}
	[path stroke];
	
	path = [NSBezierPath bezierPath];
	for(NSUInteger fraction = 1; fraction <= maximumVerticalFractions; fraction++) {
		for(NSUInteger n = 1; n < fraction; n++) {
			[path moveToPoint: NSMakePoint(0, roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
			[path lineToPoint: NSMakePoint(NSWidth(self.bounds), roundf((self.bounds.size.height / fraction) * n) + 0.5f)];
		}
	}
	[path stroke];
}

@end