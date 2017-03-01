//
//  PhotographerDetailsTableViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/6/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureViewController.h"

@interface PhotographerDetailsTableViewController : UITableViewController <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, SignDelegate>

@property (strong, nonatomic) NSString *strSignDate;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyPhone;

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogoDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnLogoChange;

@property (weak, nonatomic) IBOutlet UIButton *btnSignDelete;
@property (weak, nonatomic) IBOutlet UISwitch *switchSaveSignature;

@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UIButton *btnSignatureChange;

- (IBAction)onLogoChange:(id)sender;
- (IBAction)onLogoDelete:(id)sender;

- (IBAction)onSwitchSaveSignature:(id)sender;

- (IBAction)onSignatureChange:(id)sender;
- (IBAction)onSignDelete:(id)sender;

@end
