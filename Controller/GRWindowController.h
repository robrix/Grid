// GRWindowController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"

@interface GRWindowController : NSWindowController <GRAreaSelectionViewDelegate> {
	NSScreen *screen;
	NSRange horizontalSelectedFractionRange, verticalSelectedFractionRange;
	IBOutlet GRAreaSelectionView *areaSelectionView;
}

@property (nonatomic, retain) IBOutlet GRAreaSelectionView *areaSelectionView;

+(GRWindowController *)controllerWithScreen:(NSScreen *)screen;

@property (nonatomic, retain) NSScreen *screen;

-(void)hideWindow:(id)sender;

@end