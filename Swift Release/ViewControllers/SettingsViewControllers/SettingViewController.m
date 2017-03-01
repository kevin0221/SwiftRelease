//
//  SettingViewController.m
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingSingleTableViewCell.h"
#import "CustomizeFieldsTableViewController.h"
#import "PhotographerDetailsTableViewController.h"
#import "ReleaseTypeViewController.h"

#import "AudioPlayer.h"

extern int g_settingIndex;

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize settingNavigationController;
@synthesize containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settingNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingNavigationController"];
    
    [self addChildViewController:settingNavigationController];
    settingNavigationController.view.frame = [containerView bounds];
    [containerView addSubview:settingNavigationController.view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button event

- (IBAction)onBack:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    NSLog(@"%d", g_settingIndex);
    if (g_settingIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (g_settingIndex > 0) {
        
        if ([self.lblTitle.text isEqual:@"Photographer Details"])
        {
            if (![self savePhotographerInfo]) {
                return;
            }
            
        }else if ([self.lblTitle.text isEqual:@"Customize Fields"])
        {
            [self saveCustomizeField];
        }
        
        g_settingIndex -= 1;
        if (g_settingIndex == 0) {
            self.lblTitle.text = @"Settings";
        }
        
        [settingNavigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)onRefresh:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    CustomizeFieldsTableViewController* customizeFieldsController = (CustomizeFieldsTableViewController*)settingNavigationController.visibleViewController;
    [customizeFieldsController reset];
}

- (IBAction)onSave:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    ReleaseTypeViewController *vc = (ReleaseTypeViewController *)settingNavigationController.visibleViewController;
    [vc onSave];
}


// save PhotographerInfo
-(BOOL)savePhotographerInfo
{
    PhotographerDetailsTableViewController *photographerInfoController = (PhotographerDetailsTableViewController*)settingNavigationController.visibleViewController;
    NSMutableDictionary *dicPhotographerInfo = [[NSMutableDictionary alloc] init];
    
    NSString *strEmail = photographerInfoController.txtEmail.text;
    if (![strEmail isEqual:@""]) {
        if (![self validateEmailWithString:strEmail]) {
            [self showDefaultAlert:@"Invalid email" message:@"Email address is not formatted correctly."];
            return NO;
        }
    }
    [dicPhotographerInfo setValue:photographerInfoController.txtName.text forKey:@"name"];
    [dicPhotographerInfo setValue:strEmail forKey:@"email"];
    [dicPhotographerInfo setValue:photographerInfoController.txtCompanyName.text forKey:@"companyName"];
    [dicPhotographerInfo setValue:photographerInfoController.txtCompanyPhone.text forKey:@"companyPhone"];
    NSData *imgLogo = UIImagePNGRepresentation(photographerInfoController.imgLogo.image);
    [dicPhotographerInfo setValue:imgLogo forKey:@"imgLogo"];
    NSData *imgSignature = UIImagePNGRepresentation(photographerInfoController.imgSignature.image);
    [dicPhotographerInfo setValue:imgSignature forKey:@"imgSignature"];
    [dicPhotographerInfo setValue:photographerInfoController.strSignDate forKey:@"SignDate"];

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dicPhotographerInfo];
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"PhotographerInfo"];
    return YES;
}

// save Customize Fields
-(void) saveCustomizeField
{
    CustomizeFieldsTableViewController *controller = (CustomizeFieldsTableViewController*)settingNavigationController.visibleViewController;
    [controller saveCurrentSettings];
}


-(void)showDefaultAlert:(NSString*)title message:(NSString*)message
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
