//
//  ImportExportDataTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "ImportExportDataTableViewController.h"

@interface ImportExportDataTableViewController ()

@end

@implementation ImportExportDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger row = [indexPath row];
     
     switch (row) {
         case 0:
         case 4:
         case 5:
         case 6:
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
             break;
             
         default:
             break;
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


@end
