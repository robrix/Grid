// HAXElement.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import <Foundation/Foundation.h>

@protocol HAXElementDelegate;

@interface HAXElement : NSObject
@property (nonatomic, weak) id<HAXElementDelegate> delegate;
@end

@protocol HAXElementDelegate <NSObject>
@optional
- (void)elementWasDestroyed:(HAXElement *)element;
@end
