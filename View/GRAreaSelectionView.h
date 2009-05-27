// GRAreaSelectionView.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

@protocol GRAreaSelectionViewDelegate;

@interface GRAreaSelectionView : NSView {
	id<GRAreaSelectionViewDelegate> delegate;
}

@property (nonatomic, assign) id<GRAreaSelectionViewDelegate> delegate;

@end


@protocol GRAreaSelectionViewDelegate <NSObject>

@property (nonatomic, readonly) NSUInteger maximumHorizontalFractions;
@property (nonatomic, readonly) NSUInteger maximumVerticalFractions;

@property (nonatomic, readonly) NSUInteger horizontalSelectedFractionIndex;
@property (nonatomic, readonly) NSUInteger verticalSelectedFractionIndex;

@property (nonatomic, readonly) NSUInteger horizontalSelectedFractionLevel;
@property (nonatomic, readonly) NSUInteger verticalSelectedFractionLevel;

@end