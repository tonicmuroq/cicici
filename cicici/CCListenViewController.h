//
//  CCListenViewController.h
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCListenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

- (IBAction)actionSliderVolume:(id)sender;
- (IBAction)actionSliderProgress:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;

@end
