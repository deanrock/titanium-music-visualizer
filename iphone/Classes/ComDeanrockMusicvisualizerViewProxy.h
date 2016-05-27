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
@end
