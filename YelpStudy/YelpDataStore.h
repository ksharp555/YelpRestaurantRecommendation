//
//  YelpDataStore.h
//  YelpStudy
//
//  Created by Jiahe Chang on 7/10/17.
//  Copyright © 2017 Jiahe Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import CoreLocation;
@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

+ (YelpDataStore *)sharedInstance;
@end

