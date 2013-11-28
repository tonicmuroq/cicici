//
//  CCListenViewController.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCListenViewController.h"
#import "CCSelector.h"

@interface CCListenViewController()

@property NSArray *playList;

@end

@implementation CCListenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playList = @[@"name1", @"name2", @"name3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        CCSelector *selector = [CCSelector withPlayList:self.playList];
        NSLog(@"%@", [selector chooseOne]);
    }
}

@end
