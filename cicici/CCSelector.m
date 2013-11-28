//
//  CCSelector.m
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import "CCSelector.h"

@implementation CCSelector

- (CCSelector *)initWithPlayList:(NSArray *)playList
{
    self.playList = playList;
    return self;
}

- (void)shuffle
{
    NSMutableArray *results = [NSMutableArray arrayWithArray:self.playList];
    NSUInteger total = [results count];
    while(--total > 0) {
        int j = rand() % (total+1);
        [results exchangeObjectAtIndex:total withObjectAtIndex:j];
    }
    self.playList = [NSArray arrayWithArray:results];
}

- (NSString *)chooseOne
{
    [self shuffle];
    return [self.playList firstObject];
}

+ (CCSelector *)withPlayList:(NSArray *)playList
{
    return [[CCSelector alloc] initWithPlayList:playList];
}

@end
