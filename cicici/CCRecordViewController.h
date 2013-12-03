//
//  CCViewController.h
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CCRecordViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *assHole;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

- (IBAction)recordClick:(id)sender;
- (IBAction)playButtonClick:(id)sender;
- (IBAction)volumeChanged:(id)sender;
@end
