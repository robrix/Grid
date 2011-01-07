// HAXWindowElement.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Haxery/HAXElement.h>

@interface HAXWindowElement : HAXElement

@property (nonatomic, assign) NSPoint origin;
@property (nonatomic, assign) NSSize size;
@property (nonatomic, assign) NSRect frame;

@end
