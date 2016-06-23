//
//  SCSiriWaveformView.m
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 12/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCSiriWaveformView.h"

static const CGFloat kDefaultFrequency          = 1.0f;
static const CGFloat kDefaultAmplitude          = 5.0f;
static const CGFloat kDefaultIdleAmplitude      = 0.07f;
static const CGFloat kDefaultNumberOfWaves      = 3.0f;
static const CGFloat kDefaultPhaseShift         = -0.1f;
static const CGFloat kDefaultDensity            = 2.0f;
static const CGFloat kDefaultPrimaryLineWidth   = 0.5f;
static const CGFloat kDefaultSecondaryLineWidth = 0.5f;

@interface SCSiriWaveformView ()

@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;
@property (nonatomic, assign) CGFloat idleAmplitude;
@property (nonatomic, assign) CGFloat numberOfWaves;
@property (nonatomic, assign) CGFloat density;
@property (nonatomic, assign) CGFloat primaryWaveLineWidth;
@property (nonatomic, assign) CGFloat secondaryWaveLineWidth;
@property (nonatomic, strong) NSArray* frequencyForWaves;
@property (nonatomic, strong) NSArray* phaseShiftForWaves;
@property (strong, nonatomic) UIColor *waveFillColor;
@property (strong, nonatomic) UIColor *waveStrokeColor;

@end

@implementation SCSiriWaveformView

-(instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.waveColor = [UIColor colorWithRed:85.0/255.0 green:209.0/255.0 blue:196.0/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    
    self.frequencyForWaves = @[@(kDefaultFrequency),@(kDefaultFrequency*0.5),@(kDefaultFrequency*1.3)];
    
    self.amplitude = kDefaultAmplitude;
    self.idleAmplitude = kDefaultIdleAmplitude;
    
    self.numberOfWaves = kDefaultNumberOfWaves;
    self.phaseShiftForWaves = @[@(kDefaultPhaseShift),@(kDefaultPhaseShift*0.8),@(kDefaultPhaseShift*1.3)];
    self.density = kDefaultDensity;
    
    self.primaryWaveLineWidth = kDefaultPrimaryLineWidth;
    self.secondaryWaveLineWidth = kDefaultSecondaryLineWidth;
}

-(void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    self.waveStrokeColor = waveColor;
    self.waveFillColor = [waveColor colorWithAlphaComponent:0.3];
}

-(void)updateWithLevel:(CGFloat)level {
    self.phase += kDefaultPhaseShift;
    self.amplitude = fmax(level, self.idleAmplitude);
    [self setNeedsDisplay];
}

-(CGFloat)normalizedPowerLevelFromDecibels:(CGFloat)decibels{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
    // We draw multiple sinus waves, with equal phases but altered amplitudes, multiplied by a parable function.
    for (int i = 0; i < self.numberOfWaves; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, (i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth));
        
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat halfHeight = height / 2.0f + 30.0*i;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat mid = width / 2.0f;
        
        const CGFloat maxAmplitude = halfHeight - 4.0f; // 4 corresponds to twice the stroke width
        
        
        CGFloat progress = 0.9 - ((CGFloat)i)/self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - 0.5f) * self.amplitude * 1.2;
        
        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
        if (i == 1) {
            [[UIColor clearColor] set];
        }
        else {
            [[self.waveStrokeColor colorWithAlphaComponent:multiplier] set];
        }
        [[self.waveFillColor colorWithAlphaComponent:multiplier] setFill];
        
        for (CGFloat x = 0; x<width +6.0 + self.density; x += self.density) {
            // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
            
            CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * [self.frequencyForWaves[i]floatValue] + self.phase) + halfHeight;
            
            if (x == 0) {
                CGContextMoveToPoint(context, -3.0, y);
            } else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
        CGContextAddLineToPoint(context, width+3.0, height+3.0);
        CGContextAddLineToPoint(context, -3.0, height+3.0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
