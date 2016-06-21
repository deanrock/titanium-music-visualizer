//
//  SCSiriWaveformView.m
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 12/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCSiriWaveformView.h"

@interface SCSiriWaveformView ()

@property (nonatomic) CAShapeLayer *pathLayer1;
@property (nonatomic) CAShapeLayer *pathLayer2;
@property (nonatomic) CAShapeLayer *pathLayer3;

@end

@implementation SCSiriWaveformView {
    CGFloat random1, random2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	
	return self;
}

- (void) setWaveColor:(UIColor *) color
{
    _waveColor = color;
    
    UIColor *transparent = [color colorWithAlphaComponent:0.5];
    
    if (_pathLayer1 != nil) {
        [_pathLayer1 setStrokeColor:color.CGColor];
        [_pathLayer1 setFillColor:transparent.CGColor];
        
        [_pathLayer2 setStrokeColor:color.CGColor];
        [_pathLayer2 setFillColor:transparent.CGColor];
        
        [_pathLayer3 setStrokeColor:[UIColor clearColor].CGColor];
        [_pathLayer3 setFillColor:transparent.CGColor];
    }
}

- (void)setup
{
    random1 = (arc4random() % 100);
    random2 = (arc4random() % 100);
    
	self.backgroundColor = [UIColor clearColor];
	
    UIBezierPath *path1 = [UIBezierPath new];
    [path1 moveToPoint:CGPointMake(-50.0, 100.0)];
    [path1 addCurveToPoint:CGPointMake(self.frame.size.width+100.0, 100.0) controlPoint1:CGPointMake(self.frame.size.width/2.0+50.0, -100.0) controlPoint2:CGPointMake(self.frame.size.width/2.0+50.0, 300.0)];
    [path1 addLineToPoint:CGPointMake(self.frame.size.width+100.0, self.frame.size.height)];
    [path1 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path1 closePath];
    
    _pathLayer1 = [CAShapeLayer new];
    [_pathLayer1 setPath:path1.CGPath];
    [_pathLayer1 setLineWidth:2.0];
    [_pathLayer1 setOpacity:0.5];
    [self.layer addSublayer:_pathLayer1];
    
    UIBezierPath *path2 = [UIBezierPath new];
    [path2 moveToPoint:CGPointMake(-50.0, 100.0)];
    [path2 addCurveToPoint:CGPointMake(self.frame.size.width+100.0, 100.0) controlPoint1:CGPointMake(self.frame.size.width/2.0+50.0, -100.0) controlPoint2:CGPointMake(self.frame.size.width/2.0+50.0, 300.0)];
    [path2 addLineToPoint:CGPointMake(self.frame.size.width+100.0, self.frame.size.height)];
    [path2 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path2 closePath];
    
    _pathLayer2 = [CAShapeLayer new];
    [_pathLayer2 setPath:path2.CGPath];
    [_pathLayer2 setLineWidth:1.0];
    [_pathLayer2 setOpacity:0.5];
    [self.layer addSublayer:_pathLayer2];
    
    UIBezierPath *path3 = [UIBezierPath new];
    [path3 moveToPoint:CGPointMake(-50.0, 100.0)];
    [path3 addCurveToPoint:CGPointMake(self.frame.size.width+100.0, 100.0) controlPoint1:CGPointMake(self.frame.size.width/2.0+50.0, -100.0) controlPoint2:CGPointMake(self.frame.size.width/2.0+50.0, 300.0)];
    [path3 addLineToPoint:CGPointMake(self.frame.size.width+100.0, self.frame.size.height)];
    [path3 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path3 closePath];
    
    _pathLayer3 = [CAShapeLayer new];
    [_pathLayer3 setPath:path3.CGPath];
    [_pathLayer3 setOpacity:0.5];
    [self.layer addSublayer:_pathLayer3];
    
    [self.layer setMasksToBounds:YES];
    
    self.waveColor = [UIColor blackColor];
}

- (void)updateWithLevel:(CGFloat)level
{
    CGFloat normalizedValue = level  * 100.0;
    
    CGFloat y = self.frame.size.height/3.0*2.0;
    
    UIBezierPath *path1 = [UIBezierPath new];
    [path1 moveToPoint:CGPointMake(0.0, 100.0)];
    [path1 addCurveToPoint:CGPointMake(self.frame.size.width, 140.0) controlPoint1:CGPointMake(self.frame.size.width/2.0, y-normalizedValue*0.7) controlPoint2:CGPointMake(self.frame.size.width/2.0, y+normalizedValue*0.7)];
    [path1 addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path1 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path1 closePath];
    [_pathLayer1 setPath:path1.CGPath];
    
    
    UIBezierPath *path2 = [UIBezierPath new];
    [path2 moveToPoint:CGPointMake(-25.0, 50.0)];
    [path2 addCurveToPoint:CGPointMake(self.frame.size.width+50.0, 90.0) controlPoint1:CGPointMake(self.frame.size.width/2.0+25.0, y+normalizedValue+random1) controlPoint2:CGPointMake(self.frame.size.width/2.0+25.0, y-normalizedValue-random1)];
    [path2 addLineToPoint:CGPointMake(self.frame.size.width+50.0, self.frame.size.height)];
    [path2 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path2 closePath];
    [_pathLayer2 setPath:path2.CGPath];
    
    
    UIBezierPath *path3 = [UIBezierPath new];
    [path3 moveToPoint:CGPointMake(0.0, 170.0)];
    [path3 addCurveToPoint:CGPointMake(self.frame.size.width, 210.0) controlPoint1:CGPointMake(self.frame.size.width/2.0, y+normalizedValue-random2) controlPoint2:CGPointMake(self.frame.size.width/2.0, y+normalizedValue-random2)];
    [path3 addLineToPoint:CGPointMake(self.frame.size.width+100.0, self.frame.size.height)];
    [path3 addLineToPoint:CGPointMake(-50.0, self.frame.size.height)];
    [path3 closePath];
    [_pathLayer3 setPath:path3.CGPath];
}

@end
