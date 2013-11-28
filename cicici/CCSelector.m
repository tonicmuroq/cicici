//
//  CCSelector.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCSelector.h"

@implementation CCSelector

@synthesize playList = _playList;

- (CCSelector *)initWithPlayList:(NSArray *)playList
{
    self.playList = playList;
    return self;
}

- (void)printPlayList
{
    for (int i=0; i < self.playList.count; i++) {
        NSLog(@"%@", [self.playList objectAtIndex:i]);
    }
}

+ (CCSelector *)withPlayList:(NSArray *)playList
{
    return [[CCSelector alloc] initWithPlayList:playList];
}

@end
