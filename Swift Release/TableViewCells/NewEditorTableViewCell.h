//
//  NewEditorTableViewCell.h
//  SwiftRelease
//
//  Created by beauty on 10/28/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEditorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;

@end
