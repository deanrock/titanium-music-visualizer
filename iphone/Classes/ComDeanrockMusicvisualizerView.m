//
//  ComDeanrockMusicvisualizerView.m
//  music-visualizer
//
//  Created by dean on 27/05/16.
//
//

#import "ComDeanrockMusicvisualizerView.h"

@implementation ComDeanrockMusicvisualizerView
- (void)initializeState
{
    // Creates and keeps a reference to the view upon initialization
    self.waveformView = [[SCSiriWaveformView alloc] initWithFrame:[self frame]];
    [self addSubview:self.waveformView];
    
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveformView setWaveColor:[UIColor whiteColor]];
    [self.waveformView setPrimaryWaveLineWidth:3.0f];
    [self.waveformView setSecondaryWaveLineWidth:1.0];

    [super initializeState];
}

- (void)updateMeters
{
    CGFloat normalizedValue = 0;
    
    if (self.player != nil) {
        [self.player updateMeters];
        
        normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.player averagePowerForChannel:0]];
    }
    
    [self.waveformView updateWithLevel:normalizedValue];
}

-(void)dealloc
{
    // Deallocates the view
    RELEASE_TO_NIL(self.waveformView);
    RELEASE_TO_NIL(self.player);

    if (self.displaylink != nil) {
        [self.displaylink invalidate];
        RELEASE_TO_NIL(self.displaylink);
    }

    [super dealloc];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    // Sets the size and position of the view
    [TiUtils setView:self.waveformView positionRect:bounds];
}

#pragma mark public methods
- (id)load:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    
    NSLog(@"[INFO] loading audio file: %@", args);
    NSURL *url = [NSURL URLWithString:args];
    
    if (!url) {
        NSLog(@"[ERROR] malformed URL");
        return NUMBOOL(false);
    }
    
    NSError *error;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error) {
        NSLog(@"[ERROR] could not create player %@", error);
        return NUMBOOL(false);
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"[ERROR] error setting category: %@", [error description]);
        return NUMBOOL(false);
    }
    
    [self.player prepareToPlay];
    [self.player setMeteringEnabled:YES];
    
    return NUMBOOL(true);
}

- (void)play:(id)args {
    if (!self.player) {
        return;
    }
    
    [self.player play];
}

- (void)pause:(id)args
{
    if (!self.player) {
        return;
    }
    
    [self.player pause];
}

- (void)seek:(id)args
{
    ENSURE_SINGLE_ARG(args, NSNumber);

    if (!self.player) {
        return;
    }

    [self.player setCurrentTime:[args floatValue]];
}

- (id)getCurrentPosition:(id)args
{
    if (!self.player) {
        return NUMFLOAT(0);
    }
    
    return NUMFLOAT((Float64)self.player.currentTime);
}

- (id)getDuration:(id)args
{
    if (!self.player) {
        return NUMFLOAT(0);
    }
    
    return NUMFLOAT((Float64)self.player.duration);
}

-(void)setLineColor_:(id)color
{
    self.waveformView.waveColor = [[TiUtils colorValue:color] _color];
}

#pragma mark - Private

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels
{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}
@end
