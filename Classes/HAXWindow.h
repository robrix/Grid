// HAXWindow.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import <Haxcessibility/HAXElement.h>

@interface HAXWindow : HAXElement

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;

- (NSString *)title;

@end
