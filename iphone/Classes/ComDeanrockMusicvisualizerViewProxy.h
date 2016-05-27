//
//  ComDeanrockMusicvisualizerViewProxy.h
//  music-visualizer
//
//  Created by dean on 27/05/16.
//
//
#import "TiViewProxy.h"

@interface ComDeanrockMusicvisualizerViewProxy : TiViewProxy
@property(copy) NSString* fileName;
- (void)play:(id)args;
- (void)pause:(id)args;
- (void)seek:(id)args;
- (id)getCurrentPosition:(id)args;
- (id)getDuration:(id)args;
- (id)load:(id)args;
@end
