//
//  OwnerInfoTableViewController.m
//  Swift Release
//
//  Created by beauty on 11/12/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "OwnerInfoTableViewController.h"
#import "NewReleaseViewController.h"

#import "DBManager.h"
#import "ActionSheetStringPicker.h"
#import "AudioPlayer.h"

@interface OwnerInfoTableViewController ()

@end

@implementation OwnerInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resumeStatus];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove Separator inset
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


#pragma mark - button event

- (IBAction)onOwnerType:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ownership Type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        /****** if ipad ***********************/
        alert.popoverPresentationController.sourceView = self.btnOwnerType;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.btnOwnerType.bounds.size.width - 80, self.btnOwnerType.bounds.size.height / 2.0f, 1, 1);
        /**********************/
        
        UIAlertAction *individualAction = [UIAlertAction actionWithTitle:@"Individual Owner" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.btnOwnerType setTitle:@"Individual Owner" forState:UIControlStateNormal];
            
        }];
        [alert addAction:individualAction];
        
        UIAlertAction *corporateAction = [UIAlertAction actionWithTitle:@"Corporate Owner" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.btnOwnerType setTitle:@"Corporate Owner" forState:UIControlStateNormal];
            
        }];
        [alert addAction:corporateAction];
        
        UIAlertAction *authorizedAction = [UIAlertAction actionWithTitle:@"Authorized Representative" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.btnOwnerType setTitle:@"Authorized Representative" forState:UIControlStateNormal];
            
        }];
        [alert addAction:authorizedAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Ownership Information" delegate:(id<UIActionSheetDelegate>)self.btnOwnerType cancelButtonTitle:nil destructiveButtonTitle:@"Individual Owner" otherButtonTitles:@"Corporate Owner", @"Authorized Representative", nil];
        [actionSheet showInView:self.view];
    }
    
    
}

- (IBAction)onDownload:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    UIButton *btnDownload = (UIButton*)sender;
    
    NSArray *arrOwners = [DBManager getProperties];
    if (arrOwners == nil || arrOwners.count == 0)
    {
        [self showDefaultAlert:@"No Owner information has been recorded yet" message:@""];
        return;
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrOwners = [[arrOwners sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSMutableArray *arrOwnerInfos = [[NSMutableArray alloc] init];
    NSMutableArray *arrOwnerIndexs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrOwners.count; i++)
    {
        Property *property = arrOwners[i];
    
        if ([arrOwnerInfos containsObject:property.property_individualOwnerName])
        {
            continue;
        }
        [arrOwnerInfos addObject:property.property_individualOwnerName];
        [arrOwnerIndexs addObject:[NSNumber numberWithInt:i]];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Owner names" rows:arrOwnerInfos initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         
         [self setValues:arrOwners[[arrOwnerIndexs[selectedIndex] integerValue]]];
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:btnDownload];
}

-(void)setValues:(Property*)property
{
    OwnershipType ownerType = (OwnershipType)[property.property_ownerType integerValue];
    switch (ownerType)
    {
        case IndividualOwner:
            [self.btnOwnerType setTitle:@"Individual Owner" forState:UIControlStateNormal];
            break;
        case CorporateOwner:
            [self.btnOwnerType setTitle:@"Corporate Owner" forState:UIControlStateNormal];
            break;
        case AuthorizedRepresentative:
            [self.btnOwnerType setTitle:@"Authorized Representative" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.txtName.text = property.property_individualOwnerName;
    self.txtCorporationName.text = property.property_coporationName;
    self.txtTitle.text = property.property_authorizedTitle;
    
    self.txtPhone.text = property.property_tel;
    self.txtEmail.text = property.property_email;
    
    [g_propertyRelease setOwnershipType:ownerType PropertyName:property.property_individualOwnerName CorporationName:property.property_coporationName AuthorizedTitle:property.property_authorizedTitle Phone:property.property_tel Email:property.property_email];
}

// show alert
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




#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [self.btnOwnerType setTitle:@"Individual Owner" forState:UIControlStateNormal];
    }
    else if (buttonIndex == 1)
    {
        [self.btnOwnerType setTitle:@"Corporate Owner" forState:UIControlStateNormal];
        
    }
    else if (buttonIndex == 2)
    {
        [self.btnOwnerType setTitle:@"Authorized Representative" forState:UIControlStateNormal];
        
    }
    
}


#pragma mark - textView delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == textField.text.length && [string isEqualToString:@" "])
    {
        textField.text = [textField.text stringByAppendingString:@"\u00a0"];
        return NO;
    }
    return YES;
}

#pragma mark - save status
-(void)saveStatus
{
    OwnershipType ownershipType = IndividualOwner;
    NSString *strType = self.btnOwnerType.titleLabel.text;
    if ([strType isEqualToString:@"Individual Owner"])
    {
        ownershipType = IndividualOwner;
    }
    else if ([strType isEqualToString:@"Corporate Owner"])
    {
        ownershipType = CorporateOwner;
    }
    else if ([strType isEqualToString:@"Authorized Representative"])
    {
        ownershipType = AuthorizedRepresentative;
    }
    
    NSString *strName = self.txtName.text;
    NSString *strCorporationName = self.txtCorporationName.text;
    NSString *strTitle = self.txtTitle.text;
    
    NSString *strTel = self.txtPhone.text;
    NSString *strEmail = self.txtEmail.text;
    
  
    [g_propertyRelease setOwnershipType:ownershipType PropertyName:strName CorporationName:strCorporationName AuthorizedTitle:strTitle Phone:strTel Email:strEmail];
    
}

-(void)resumeStatus
{
    NSString *strType = @"Individual Owner";
    switch (g_propertyRelease.property_ownershipType)
    {
        case IndividualOwner:
            strType = @"Individual Owner";
            break;
        case CorporateOwner:
            strType = @"Corporate Owner";
            break;
        case AuthorizedRepresentative:
            strType = @"Authorized Representative";
            break;
        default:
            break;
    }
    
    [self.btnOwnerType setTitle:strType forState:UIControlStateNormal];
    
    self.txtName.text = g_propertyRelease.strProperty_Name;
    self.txtCorporationName.text = g_propertyRelease.strProperty_corporationName;
    self.txtTitle.text = g_propertyRelease.strProperty_authorizedTitle;
    self.txtPhone.text = g_propertyRelease.strProperty_phone;
    self.txtEmail.text = g_propertyRelease.strProperty_email;   
    
}



@end
