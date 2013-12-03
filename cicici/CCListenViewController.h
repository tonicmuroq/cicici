//
//  CCListenViewController.h
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCListenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *RatioLabel;
@property (weak, nonatomic) IBOutlet UISlider *VolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *ProgressSlider;

- (IBAction)actionSliderVolume:(id)sender;
- (IBAction)actionSliderProgress:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;

@end
