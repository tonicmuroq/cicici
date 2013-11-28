//
//  CCSelector.h
//  cicici
//
//  Created by tonic on 13-11-28.
//  Copyright (c) 2013年 tonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSelector : NSObject

@property(nonatomic) NSArray *playList;

- (NSString *)chooseOne;
+ (CCSelector *)withPlayList:(NSArray *)playList;

@end
