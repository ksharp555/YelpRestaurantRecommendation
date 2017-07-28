//
//  YelpDataStore.m
//  YelpStudy
//
//  Created by Jiahe Chang on 7/10/17.
//  Copyright © 2017 Jiahe Chang. All rights reserved.
//

#import "YelpDataStore.h"
@implementation YelpDataStore

+ (YelpDataStore *)sharedInstance {
    static YelpDataStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpDataStore alloc] init];
    });
    return _sharedInstance;
}
@end
