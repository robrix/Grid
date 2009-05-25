// GRAreaSelectionView.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

@protocol GRAreaSelectionViewDelegate;

@interface GRAreaSelectionView : NSView {
	id<GRAreaSelectionViewDelegate> delegate;
	NSRange horizontalSelectedRange;
	NSRange verticalSelectedRange;
	NSUInteger maximumHorizontalFractions;
	NSUInteger maximumVerticalFractions;
}

@property (nonatomic, assign) id<GRAreaSelectionViewDelegate> delegate;

@end


@protocol GRAreaSelectionViewDelegate <NSObject>

@property (nonatomic, readonly) NSRange horizontalSelectedRange;
@property (nonatomic, readonly) NSRange verticalSelectedRange;

@property (nonatomic, readonly) NSUInteger maximumHorizontalFractions;
@property (nonatomic, readonly) NSUInteger maximumVerticalFractions;

@end