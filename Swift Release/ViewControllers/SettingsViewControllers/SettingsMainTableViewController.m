//
//  SettingsMainTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/3/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "SettingsMainTableViewController.h"
#import "CustomizeFieldsTableViewController.h"
#import "ReleaseTypeViewController.h"
#import "SettingViewController.h"
#import "ImportExportDataTableViewController.h"
#import "PhotographerDetailsTableViewController.h"
#import "ViewController.h"
#import "AudioPlayer.h"

#import "ActionSheetStringPicker.h"

int g_settingIndex = 0;

@interface SettingsMainTableViewController ()
{
    SettingViewController *settingViewController;
}
@end

@implementation SettingsMainTableViewController

@synthesize arrLanguages;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    settingViewController = (SettingViewController*)self.navigationController.parentViewController;
    [self setNavTitle:@"Settings"];
    
    arrLanguages = @[@"English", @"Spanish", @"Russian", @"German", @"Italian", @"French", @"Finnish", @"Portuguese", @"Danish", @"Chinese", @"Korean"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:@"Settings"];
    [settingViewController.btnRefresh setHidden:YES];
    [settingViewController.btnSave setHidden:YES];
    
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        self.lblReleaseType.text = @"Custom Release";
    }
    else
    {
        self.lblReleaseType.text = @"Standard";
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AudioPlayer playButtonEffectSound];
    
    NSInteger row = [indexPath row];
    switch (row) {
        case 1: // show photographer details
            {
                g_settingIndex += 1;
                [self setNavTitle:@"Photographer Details"];
                PhotographerDetailsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotographerDetailsController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        case 2: // show customizeField page
            {
                g_settingIndex += 1;
                [self setNavTitle:@"Customize Fields"];
                CustomizeFieldsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomizeFieldsViewController"];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            break;
        case 3: // show Release Language
            {
                [self showReleaseLanguagesPicker];
            }
            break;
        case 4: // Release Type
            {
                g_settingIndex += 1;
                [self setNavTitle:@"Release Type"];
                ReleaseTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseTypeViewController"];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            break;
        case 5: // Document Type
            [self showDocumentTypePicker];
            break;
        case 7: // Import/Export Data
            {
                g_settingIndex += 1;
                [self setNavTitle:@"Import/Export Data"];
                ImportExportDataTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportExportDataTableViewController"];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            break;
        case 8: // View Intro
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"fromSettings"];
                
                ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroScrollController"];
                [[self.navigationController parentViewController].navigationController pushViewController:viewController animated:YES];
//                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case 9: // Terms of Service
            
            break;
        case 10: // About Swift Release
            
            
            
            break;
        case 11: // Contact Us
            
            break;
        case 12: // Rate This App
            
            break;
        default:
            
            break;
    }
}

#pragma mark - set nav Title
-(void)setNavTitle:(NSString*)title
{
    if (settingViewController == nil) {
        settingViewController = (SettingViewController*)self.navigationController.parentViewController;
    }
  
    settingViewController.lblTitle.text = title;
}


#pragma mark - Strings Picker

// Show Release Languages Picker
-(void)showReleaseLanguagesPicker
{
    
    [ActionSheetStringPicker showPickerWithTitle:@"Languages" rows:arrLanguages initialSelection:1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.lblLanguage.text = arrLanguages[selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.lblLanguage];
    
}

// show Document Type Picker
-(void)showDocumentTypePicker
{
    NSArray *arrTypes = @[@"PDF", @"IMAGE"];
    [ActionSheetStringPicker showPickerWithTitle:@"Document Type" rows:arrTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.lblDocumentType.text = arrTypes[selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.lblDocumentType];
}


@end
