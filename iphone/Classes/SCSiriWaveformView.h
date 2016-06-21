//
//  SCSiriWaveformView.h
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 12/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SCSiriWaveformView : UIView

/*
 * Tells the waveform to redraw itself using the given level (normalized value)
 */
- (void)updateWithLevel:(CGFloat)level;

/*
 * Color to use when drawing the waves
 * Default: white
 */
@property (nonatomic, strong) IBInspectable UIColor *waveColor;

@end
