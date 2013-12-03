//
//  CCListenViewController.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCListenViewController.h"
#import "SongLib.h"
#import "CCSelector.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"


static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface Track : NSObject <DOUAudioFile>
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;
@end

@implementation Track
- (NSURL *)audioFileURL
{
    return [self url];
}
@end

@interface CCListenViewController() {
@private
    DOUAudioStreamer *_streamer;
    NSArray *_tracks;
    NSUInteger _currentIndex;
}
@end

@implementation CCListenViewController

+ (void)load
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self _tracks];
    });
    
    [DOUAudioStreamer setOptions:[DOUAudioStreamer options] | DOUAudioStreamerRequireSHA256];
}

+ (NSArray *)_tracks
{
    static NSArray *tracks = nil;
    static dispatch_once_t onceToken;
    NSArray *songs = @[OLD_YELLOW_BRICKS, DIPLOMATS_SON, ARMY_DREAMERS, CHANCES, UNKNOWN];
    dispatch_once(&onceToken, ^{
        NSMutableArray *allTracks = [NSMutableArray array];
        for (NSString *song in songs) {
            Track *track = [[Track alloc] init];
            [track setArtist:@"高压锅"];
            [track setTitle:@"次次次"];
            [track setUrl:[NSURL URLWithString:song]]; // 我知道这不是次次次, 但是我找不到次次次了T^T
            [allTracks addObject:track];
        }
        tracks = [allTracks copy];
    });
    
    return tracks;
}

- (void)_resetStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
    
    CCSelector *selector = [CCSelector withPlayList:_tracks];
    Track *track = [selector chooseOne];
    NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
    [_TitleLabel setText:title];
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    [_streamer addObserver:self forKeyPath:@"status"
                   options:NSKeyValueObservingOptionNew
                   context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration"
                   options:NSKeyValueObservingOptionNew
                   context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio"
                   options:NSKeyValueObservingOptionNew
                   context:kBufferingRatioKVOKey];
    [_streamer play];
    [self _updateBufferingStatus];
    [self _setupHintForStreamer];
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = _currentIndex + 1;
    if (nextIndex >= [_tracks count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [_ProgressSlider setValue:0.0f
                             animated:NO];
    } else {
        [_ProgressSlider setValue:[_streamer currentTime] / [_streamer duration]
                             animated:YES];
    }
}

- (void)_updateStatus
{
    // do nothing
}

- (void)_updateBufferingStatus
{
    [_RatioLabel setText:[NSString stringWithFormat:@"%.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tracks = [[self class] _tracks];
    _currentIndex = 0;
    [self _resetStreamer];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(_timerAction:)
                                   userInfo:nil
                                    repeats:YES];
    [_VolumeSlider setValue:[DOUAudioStreamer volume]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self _resetStreamer];
    }
}

- (IBAction)actionSliderVolume:(id)sender
{
    [DOUAudioStreamer setVolume:[_VolumeSlider value]];
}

- (IBAction)actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [_ProgressSlider value]];
}

- (IBAction)stopButtonPressed:(id)sender
{
    [_streamer stop];
}
@end
