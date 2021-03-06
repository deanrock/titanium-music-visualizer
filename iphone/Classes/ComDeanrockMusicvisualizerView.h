//
//  ComDeanrockMusicvisualizerView.h
//  music-visualizer
//
//  Created by dean on 27/05/16.
//
//
#import <AVFoundation/AVFoundation.h>
#import "TiUIView.h"

#import "SCSiriWaveformView.h"

@interface ComDeanrockMusicvisualizerView : TiUIView
@property (nonatomic, strong) SCSiriWaveformView *waveformView;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) CADisplayLink *displaylink;

- (void)play:(id)args;
- (void)pause:(id)args;
- (void)seek:(id)args;
- (void)setVolume:(id)args;
- (id)getCurrentPosition:(id)args;
- (id)getDuration:(id)args;
- (id)load:(id)args;
@end
