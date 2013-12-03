//
//  CCViewController.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCRecordViewController.h"
#import "SongLib.h"

@interface CCRecordViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation CCRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _assHole.hidesWhenStopped = YES;
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"cicici.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL
                                           settings:recordSetting
                                              error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordClick:(id)sender
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (!recorder.recording) {
        [session setActive:YES error:nil];
        [recorder record];
        [_assHole startAnimating];
        [_recordButton setTitle:@"停止" forState:UIControlStateNormal];
        [_infoLabel setText:@"在录了哈不要急"];
    } else {
        [session setActive:NO error:nil];
        [recorder stop];
        [_assHole stopAnimating];
        [_recordButton setTitle:@"录音" forState:UIControlStateNormal];
        [_infoLabel setText:@"录完了诶"];
    }
}

- (IBAction)playButtonClick:(id)sender
{
    if (!recorder.recording) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    } else {
        [_infoLabel setText:@"人家还在录呢别瞎戳"];
    }
}

- (IBAction)volumeChanged:(id)sender {
    [player setVolume:[_volumeSlider value]];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"听够了没有"
                                                    message: @"次次次好玩不"
                                                   delegate: nil
                                          cancelButtonTitle:@"好玩!"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
