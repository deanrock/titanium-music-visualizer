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

- (bool)play:(id)args;
@end
