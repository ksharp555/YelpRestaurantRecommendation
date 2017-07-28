//
//  YelpDetailViewController.h
//  YelpStudy
//
//  Created by Jiahe Chang on 7/12/17.
//  Copyright © 2017 Jiahe Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"


@interface YelpDetailViewController : UIViewController

@property (nonatomic) UIImage *imageForShare;

- (instancetype)initWithDataModel:(YelpDataModel *)dataModel;

@end
