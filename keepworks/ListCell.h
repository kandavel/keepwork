//
//  ListCell.h
//  keepworks
//
//  Created by Kandavel on 19/10/16.
//  Copyright © 2016 com.base2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *listImage;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet UILabel *listVenue;
@property (weak, nonatomic) IBOutlet UILabel *listFees;

@end
