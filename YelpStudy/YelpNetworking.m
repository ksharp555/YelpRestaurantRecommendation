//
//  YelpNetworking.m
//  YelpStudy
//
//  Created by Jiahe Chang on 7/4/17.
//  Copyright © 2017 Jiahe Chang. All rights reserved.
//

#import "YelpNetworking.h"
#import "YelpDataModel.h"
#import "YelpDataStore.h"


static NSString const * kGrantType = @"client_credentials";
static NSString const * kClient_id = @"9AqJIUxyuqlM1OmIfv0nuw";
static NSString const * kClient_secret = @"dxVc4pmsdANIj2q5RFeNvmrwKXyEOu7sXWBjLvBqxUH3DQOpWYAEcoIPhsfnB1nM";
static NSString const * kTokenEndPoint = @"https://api.yelp.com/oauth2/token";

typedef void (^TokenPendingTask)(NSString *token);

@interface YelpNetworking ()

@property (nonatomic, copy) NSString *token;

@end

@implementation YelpNetworking

+ (YelpNetworking *)sharedInstance {
    static YelpNetworking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ //
        _sharedInstance = [[YelpNetworking alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]){
        [self fetchTokenWithTokenPendingTask:nil];
    }
    return self;
}



- (void)fetchTokenWithTokenPendingTask:(TokenPendingTask)tokenPendingTask
{
    NSURL *url = [NSURL URLWithString:kTokenEndPoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@", kGrantType, kClient_id,kClient_secret];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        self.token = dict[@"access_token"];
        if (tokenPendingTask) {
            tokenPendingTask(self.token);
        }
    }];
    [postDataTask resume];
}


- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock {
    
    TokenPendingTask tokenTask = ^(NSString *token) {
        NSString *string = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%.6f&longitude=%.6f",term, location.coordinate.latitude, location.coordinate.longitude];
        NSURL *url = [NSURL URLWithString:string];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSString *headerToken = [NSString stringWithFormat:@"Bearer %@",token];
        
        [request addValue:headerToken forHTTPHeaderField:@"Authorization"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NULL error:nil];
            // we update here
            if (!error) {
                NSArray<YelpDataModel *> *dataModelArray = [YelpDataModel buildDataModelArrayFromDictionaryArray:dict[@"businesses"]];
                [YelpDataStore sharedInstance].dataModels = dataModelArray;
                
                completionBlock(dataModelArray);
            }

        }];
        [dataTask resume];
    };
    if (self.token) {
        tokenTask(self.token);
    } else {
        [self fetchTokenWithTokenPendingTask:tokenTask];
    }
}

@end
