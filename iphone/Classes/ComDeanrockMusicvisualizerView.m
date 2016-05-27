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
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
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
    [super dealloc];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    // Sets the size and position of the view
    [TiUtils setView:self.waveformView positionRect:bounds];
}

#pragma mark public methods
- (bool)play:(id)args {
    NSError *error;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"mp3"] error:&error];
    if(error) {
        NSLog(@"[ERROR] could not create player %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"[ERROR] error setting category: %@", [error description]);
        return;
    }
    
    [self.player prepareToPlay];
    [self.player setMeteringEnabled:YES];
    [self.player play];
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
