//
//  CustomizeFieldsTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/3/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "CustomizeFieldsTableViewController.h"
#import "CustomizeFieldsTableViewCell.h"
#import "SettingViewController.h"

#import "ActionSheetStringPicker.h"

#define RequiredString @"Required"
#define OptionalString @"Optional"
#define OffString @"Off"


@interface CustomizeFieldsTableViewController ()

@end

@implementation CustomizeFieldsTableViewController

@synthesize arrTitles;
@synthesize dicCutomizeFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTitles = @[@"Photographer", @"Shoot Title", @"Shoot Description", @"Date",
                  @"Model Name", @"Date of Birth", @"Gender", @"Ethnicity", @"Street Address", @"City", @"State", @"Country", @"Email", @"Phone", @"Witness"];
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:@"CustomizeFields"];
    dicCutomizeFields = [dic mutableCopy];
    if (dicCutomizeFields == nil)
    {
        [self initWithTitles];
    }
    
    
    SettingViewController *settingViewController = (SettingViewController*)self.navigationController.parentViewController;
    settingViewController.lblTitle.text = @"Customize Fields";
    [settingViewController.btnRefresh setHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initWithTitles
{
    dicCutomizeFields = [[NSMutableDictionary alloc] init];
    for (NSString* title in arrTitles) {
        [dicCutomizeFields setObject:@"Required" forKey:title];
        
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strTitle = @"";
    switch (section) {
        case 0:
            strTitle = @"Photoshoot Fields";
            break;
        case 1:
            strTitle = @"Model Release Fields";
            break;
        case 2:
            strTitle = @"Witness Fields";
            break;
        default:
            break;
    }
    
    return strTitle;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 4;
            break;
        case 1:
            numberOfRows = 10;
            break;
        case 2:
            numberOfRows = 1;
        default:
            break;
    }
   
    return numberOfRows;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomizeFieldsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomizeFieldsTableViewCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 1) {
        row += 4;
    }
    
    if (section == 2) {
        row += 14;
    }
    
    cell.lblTitle.text = arrTitles[row];
    NSString *strContent = [dicCutomizeFields objectForKey:arrTitles[row]];
    
    cell.lblContent.text = strContent;
    if (strContent == nil || [strContent isEqual:@""]) {
        cell.lblContent.text = @"Required";
        
    }
    if ([strContent isEqualToString:RequiredString]) {
        cell.imgIcon.image = [UIImage imageNamed:@"customize_fields_blue"];
    }
    if ([strContent isEqualToString:OptionalString])
    {
        cell.imgIcon.image = [UIImage imageNamed:@"settings_optionalField.png"];
    }
    if ([strContent isEqualToString:OffString])
    {
        cell.imgIcon.image = [UIImage imageNamed:@"delete_dark"];
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if ((row == 0) && section != 2)
    {
        [self showDefaultAlert:@"Inform" message:@"This field is required"];
        return;
    }
    

    CustomizeFieldsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *arrOptions = @[@"Required", @"Optional", @"Off"];
    [ActionSheetStringPicker showPickerWithTitle:@"Set Preference" rows:arrOptions initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        cell.lblContent.text = arrOptions[selectedIndex];
        
        switch (selectedIndex)
        {
            case 0:
                cell.imgIcon.image = [UIImage imageNamed:@"customize_fields_blue"];
                [dicCutomizeFields setValue:arrOptions[0] forKey:cell.lblTitle.text];
                break;
            case 1:
                cell.imgIcon.image = [UIImage imageNamed:@"settings_optionalField.png"];
                [dicCutomizeFields setValue:arrOptions[1] forKey:cell.lblTitle.text];
                break;
            case 2:
                cell.imgIcon.image = [UIImage imageNamed:@"delete_dark"];
                [dicCutomizeFields setValue:arrOptions[2] forKey:cell.lblTitle.text];
                break;
            default:
                break;
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:cell];
    
   
}

-(void)reset
{
    [self initWithTitles];
    [self.tableView reloadData];
}

-(void)saveCurrentSettings
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dicCutomizeFields];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"CustomizeFields"];
}



#pragma mark - show default alert

-(void)showDefaultAlert:(NSString*)title message:(NSString*)message
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
