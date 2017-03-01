//
//  PhotographerDetailsTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/6/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "PhotographerDetailsTableViewController.h"
#import "SignatureViewController.h"

#import "AudioPlayer.h"

@interface PhotographerDetailsTableViewController ()

@end

@implementation PhotographerDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicPhotographerInfo = [userDefaults objectForKey:@"PhotographerInfo"];
    if (dicPhotographerInfo == nil) {
        [self setDefaultPhotographerInfo];
    }
    else
    {
        [self showPhotographerInfo];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set default photographer info (if first run)..
-(void)setDefaultPhotographerInfo
{
    self.txtName.text = @"";
    self.txtEmail.text = @"";
    self.txtCompanyName.text = @"";
    self.txtCompanyPhone.text = @"";
    self.imgLogo.image = nil;
    self.imgSignature.image = nil;
    [self.btnLogoDelete setHidden:YES];
    [self.btnSignDelete setHidden:YES];
    
}

-(void)showPhotographerInfo
{
    NSDictionary *dicPhotographerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
    self.txtName.text = [dicPhotographerInfo objectForKey:@"name"];
    self.txtEmail.text = [dicPhotographerInfo objectForKey:@"email"];
    self.txtCompanyName.text = [dicPhotographerInfo objectForKey:@"companyName"];
    self.txtCompanyPhone.text = [dicPhotographerInfo objectForKey:@"companyPhone"];
    NSData *imgLogo = [dicPhotographerInfo objectForKey:@"imgLogo"];
    self.imgLogo.image = [UIImage imageWithData:imgLogo];
    NSData *imgSignature = [dicPhotographerInfo objectForKey:@"imgSignature"];
    self.imgSignature.image = [UIImage imageWithData:imgSignature];
    self.strSignDate = [dicPhotographerInfo objectForKey:@"SignDate"];
    
    if (imgLogo != nil) {
        [self.btnLogoChange setTitle:@"Change" forState:UIControlStateNormal];
        [self.btnLogoDelete setHidden:NO];
    }
    else
    {
        [self.btnLogoDelete setHidden:YES];
    }
    
    if (imgSignature != nil)
    {
        [self.btnSignatureChange setTitle:@"Change" forState:UIControlStateNormal];
        [self.btnSignDelete setHidden:NO];
    }
    else
    {
        [self.btnSignDelete setHidden:YES];
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


#pragma mark - button events

-(IBAction)onLogoChange:(id)sender
{
    [AudioPlayer playButtonEffectSound];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // if ipad
        alert.popoverPresentationController.sourceView = self.btnLogoChange;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.btnLogoChange.bounds.size.width/2.0f, self.btnLogoChange.bounds.size.height/2.0f, 1, 1);
        ///
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Take a Photo");
            [AudioPlayer playButtonEffectSound];
            [self takePhoto];
            
        }];
        [alert addAction:cameraAction];
        
        UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Get From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Get from a photo library");
            [AudioPlayer playButtonEffectSound];
            [self selectPhoto];
        }];
        [alert addAction:galleryAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo", @"Get From Photo Library", nil];
        
        [actionSheet showInView:self.view];
    }
    
}

- (IBAction)onLogoDelete:(id)sender
{
    [AudioPlayer playDeleteEffectSound];
    
    self.imgLogo.image = nil;
    [self.btnLogoChange setTitle:@"Add" forState:UIControlStateNormal];
    [self.btnLogoDelete setHidden:YES];
}


- (IBAction)onSwitchSaveSignature:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    if([self.switchSaveSignature isOn])
    {
        [self.btnSignatureChange setEnabled:YES];
        [self.btnSignDelete setEnabled:YES];
    }
    else
    {
        [self.btnSignatureChange setEnabled:NO];
        [self.btnSignDelete setEnabled:NO];
    }
        
}

- (IBAction)onSignatureChange:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    g_releaseType = NONE;
    SignatureViewController *signatureViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    signatureViewController.view.tag = 10;
    signatureViewController.delegate = self;
    signatureViewController.strSignerName = self.txtName.text;
    [self presentViewController:signatureViewController animated:YES completion:nil];
}

- (IBAction)onSignDelete:(id)sender
{
    [AudioPlayer playDeleteEffectSound];
    
    self.imgSignature.image = nil;
    [self.btnSignatureChange setTitle:@"Add" forState:UIControlStateNormal];
    [self.btnSignDelete setHidden:YES];
}

#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [AudioPlayer playDeleteEffectSound];
        [self takePhoto];
    }
    else if (buttonIndex == 1)
    {
        [AudioPlayer playDeleteEffectSound];
        [self selectPhoto];
    }
    
}

#pragma mark - imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgLogo.image = chosenImage;
    [self.btnLogoChange setTitle:@"Change" forState:UIControlStateNormal];
    [self.btnLogoDelete setHidden:NO];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)takePhoto
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        [self showDefaultAlert:nil message:@"No Camera Abailable."];
    }
}

-(void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing  = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
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

#pragma mark -  SignDelegate
- (void)didSign:(NSData *)sign date:(NSString *)strDate
{
    self.strSignDate = strDate;
    self.imgSignature.image = [UIImage imageWithData:sign];
    [self.btnSignatureChange setTitle:@"Change" forState:UIControlStateNormal];
    [self.btnSignDelete setHidden:NO];
    
}

- (void)didSignCancel
{
    
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
