//
//  MainTableViewCell.h
//  SwiftRelease
//
//  Created by beauty on 10/28/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) NSString *strFileName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@property (weak, nonatomic) IBOutlet UIButton *btnMerge;

@end
