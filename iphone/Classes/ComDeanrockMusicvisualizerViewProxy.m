//
//  ComDeanrockMusicvisualizerViewProxy.m
//  music-visualizer
//
//  Created by dean on 27/05/16.
//
//

#import "ComDeanrockMusicvisualizerViewProxy.h"

#ifndef USE_VIEW_FOR_UI_METHOD
#define USE_VIEW_FOR_UI_METHOD(methodname)\
-(void)methodname:(id)args\
{\
[self makeViewPerformSelector:@selector(methodname:) withObject:args createIfNeeded:YES waitUntilDone:NO];\
}
#endif

@implementation ComDeanrockMusicvisualizerViewProxy
USE_VIEW_FOR_UI_METHOD(play)
@end
