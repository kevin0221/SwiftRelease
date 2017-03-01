//
//  OwnerInfoTableViewController.h
//  Swift Release
//
//  Created by beauty on 11/12/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerInfoTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnOwnerType;


@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtCorporationName;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction)onOwnerType:(id)sender;
- (IBAction)onDownload:(id)sender;

@end
