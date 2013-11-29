//
//  CCSelector.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCSelector.h"

static CCSelector *_selector;

@implementation CCSelector

- (CCSelector *)initWithPlayList:(NSArray *)playList
{
    _playList = playList;
    return self;
}

- (void)shuffle
{
    NSMutableArray *results = [NSMutableArray arrayWithArray:_playList];
    NSUInteger total = [results count];
    while(--total > 0) {
        int j = rand() % (total+1);
        [results exchangeObjectAtIndex:total withObjectAtIndex:j];
    }
    _playList = [NSArray arrayWithArray:results];
}

- (id)chooseOne
{
    [self shuffle];
    return [_playList firstObject];
}

+ (CCSelector *)withPlayList:(NSArray *)playList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _selector = [[CCSelector alloc] init];
    });
    return [_selector initWithPlayList:playList];
}

@end
