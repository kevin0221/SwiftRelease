//
//  WitnessInfoTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/2/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "WitnessInfoTableViewController.h"
#import "NewReleaseViewController.h"

#import "DBManager.h"
#import "ActionSheetStringPicker.h"
#import "AudioPlayer.h"

@interface WitnessInfoTableViewController ()

@end

@implementation WitnessInfoTableViewController

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


#pragma mark - textView delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self saveStatus];
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


#pragma mark - button events

- (IBAction)onDownload:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    
    UIButton *btnDownload = (UIButton*)sender;
    
    NSArray *arrWitnesses = [DBManager getWitnesses];
    if (arrWitnesses == nil || arrWitnesses.count == 0)
    {
        [self showDefaultAlert:@"No Witness information has been recorded yet" message:@""];
        return;
    }
    
    NSMutableArray *arrWitnessNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrWitnesses.count; i++)
    {
        Witness *witness = arrWitnesses[i];
       
        [arrWitnessNames addObject:witness.name];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Witness names" rows:arrWitnessNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         self.txtWitnessName.text = arrWitnessNames[selectedIndex];
         switch (g_releaseType) {
             case ModelType:
                 g_modelRelease.strWitness_name = arrWitnessNames[selectedIndex];
                 break;
             case PropertyType:
                 g_propertyRelease.strWitness_name = arrWitnessNames[selectedIndex];
                 break;
             default:
                 break;
         }
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:btnDownload];
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

#pragma mark - save status
-(void)saveStatus
{
    NSString *strWitnessName = self.txtWitnessName.text;
    
    switch (g_releaseType) {
        case ModelType:
            [g_modelRelease setWitnessInfoName:strWitnessName];
            break;
        case PropertyType:
            [g_propertyRelease setWitnessInfoName:strWitnessName];
            break;
        default:
            break;
    }
    
}

-(void)resumeStatus
{
    switch (g_releaseType) {
        case ModelType:
            self.txtWitnessName.text = g_modelRelease.strWitness_name;
            break;
        case PropertyType:
            self.txtWitnessName.text = g_propertyRelease.strWitness_name;
            break;
        default:
            break;
    }
    
}


@end
