// HAXWindow.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Haxcessibility/HAXElement.h>

@interface HAXWindow : HAXElement

@property (nonatomic, assign) NSPoint origin;
@property (nonatomic, assign) NSSize size;
@property (nonatomic, assign) NSRect frame;

@end
