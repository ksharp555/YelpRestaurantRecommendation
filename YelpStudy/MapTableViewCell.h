//
//  MapTableViewCell.h
//  YelpStudy
//
//  Created by Jiahe Chang on 7/12/17.
//  Copyright © 2017 Jiahe Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"

@interface MapTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
