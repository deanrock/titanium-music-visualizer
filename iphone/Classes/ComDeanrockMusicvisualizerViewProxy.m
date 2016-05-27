//
//  ComDeanrockMusicvisualizerViewProxy.m
//  music-visualizer
//
//  Created by dean on 27/05/16.
//
//

#import "ComDeanrockMusicvisualizerViewProxy.h"
#import "ComDeanrockMusicvisualizerView.h"

#ifndef USE_VIEW_FOR_UI_METHOD
#define USE_VIEW_FOR_UI_METHOD(methodname)\
-(void)methodname:(id)args\
{\
[self makeViewPerformSelector:@selector(methodname:) withObject:args createIfNeeded:YES waitUntilDone:NO];\
}
#endif

@implementation ComDeanrockMusicvisualizerViewProxy
USE_VIEW_FOR_UI_METHOD(play)
USE_VIEW_FOR_UI_METHOD(pause)
USE_VIEW_FOR_UI_METHOD(seek)

- (id)getCurrentPosition:(id)args {
    return [(ComDeanrockMusicvisualizerView*)[self view] getCurrentPosition:args];
}

- (id)getDuration:(id)args {
    return [(ComDeanrockMusicvisualizerView *)[self view] getDuration:args];
}

- (id)load:(id)args {
    return [(ComDeanrockMusicvisualizerView *)[self view] load:args];
}
@end
