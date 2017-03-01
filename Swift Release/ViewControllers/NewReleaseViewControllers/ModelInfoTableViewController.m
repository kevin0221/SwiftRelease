//
//  ModelInfoTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 10/30/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "ModelInfoTableViewController.h"
#import "MBProgressHUD.h"
#import "ActionSheetStringPicker.h"

#import "DBManager.h"
#import "AudioPlayer.h"

@interface ModelInfoTableViewController ()
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@end

@implementation ModelInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initial
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float imgHeight = screenSize.width * 330.0f/750.0f - 8 * 2;
    self.imgPhoto.layer.cornerRadius = imgHeight / 2.0f;
    self.imgPhoto.clipsToBounds = YES;
    
    m_bEnableLocation = YES;
    [self startGeoLocation];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    CGFloat height = 48.0f;
    if (row == 0)
    {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        height = screenSize.width * 330.0f/750.0f;
    }
    
    if (row == 6 || row == 7) {
        if ([self getIsChild] == NO) {
            height = 0.01f;
        }
        else
        {
            height = 48.0f;
        }
    }
    
    NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    NSString *strTemp = @"";
    switch (row)
    {
        case 4:
            strTemp = [dicCustomizeFields valueForKey:str_Gender];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 5:
            strTemp = [dicCustomizeFields valueForKey:str_Ethnicity];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 10:
            strTemp = [dicCustomizeFields valueForKey:str_City];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 11:
            strTemp = [dicCustomizeFields valueForKey:str_State];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 12:
            strTemp = [dicCustomizeFields valueForKey:str_Country];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 15:
            strTemp = [dicCustomizeFields valueForKey:str_Email];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        case 16:
            strTemp = [dicCustomizeFields valueForKey:str_Phone];
            if ([strTemp isEqual:@"Off"])
                height = 0.0f;
            break;
        default:
            break;
    }
    return height;
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



#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [self takePhoto];
    }
    else if (buttonIndex == 1)
    {
        [self selectPhoto];
    }
    
}

#pragma mark - imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgPhoto.image = chosenImage;
    NSData *imgData = UIImagePNGRepresentation(chosenImage);
    g_modelRelease.dataModel_photo = imgData;
    
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

#pragma mark - datePicker

-(void)showDatePicker:(UIDatePickerMode)modeDatePicker
{
    UIView *viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [viewDatePicker setBackgroundColor:[UIColor clearColor]];
    
    // Make a frame for the picker & then create the picker
    CGRect pickerFrame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    datePicker.datePickerMode = modeDatePicker;
    datePicker.hidden = NO;
    [viewDatePicker addSubview:datePicker];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [datePicker setFrame:CGRectMake(0, 0, 300, 200)];
        [viewDatePicker setFrame:CGRectMake(0, 0, 300, 200)];
    }
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController.view addSubview:viewDatePicker];
        
        // if ipad
        alertController.popoverPresentationController.sourceView = self.btnDateOfBirth;
        alertController.popoverPresentationController.sourceRect = CGRectMake(self.btnDateOfBirth.bounds.size.width - 100, 22, 1, 1);
        //////

        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         //Detect particular click by tag and do some thing here
                                         
                                        [self setSelectedDateInField];
                                         NSLog(@"OK action");
                                         
                                     }];
        [alertController addAction:doneAction];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [actionSheet addSubview:viewDatePicker];
        [actionSheet showInView:self.view];
        
    }
}


-(void)setSelectedDateInField
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    
    //set Date formatter
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/YYYY"];
    
    NSString *strSelectedDate = [defaultFormatter stringFromDate:datePicker.date];
    [self.btnDateOfBirth setTitle:strSelectedDate forState:UIControlStateNormal];
    g_modelRelease.strModel_birth = strSelectedDate;
    
    [self.tableView reloadData];
    
}

-(BOOL)getIsChild
{
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    
    [defaultFormatter setDateFormat:@"YYYY"];
    NSInteger currentYear = [[defaultFormatter stringFromDate:[NSDate date]] integerValue];
    
    NSString *strBirth = g_modelRelease.strModel_birth;
    
    strBirth = [strBirth substringFromIndex:strBirth.length - 4];
    NSInteger birthYear = [strBirth integerValue];
    
    if (currentYear - birthYear < 18) {
        NSLog(@"under 18 years old");
        self.b_isChild = YES;
        return YES;
    }
    else
    {
        NSLog(@"older than 18 years old");
        self.b_isChild = NO;
        return NO;
    }
    return NO;
}

#pragma mark - Start GeoLocation

-(void)startGeoLocation
{
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    currentLocation = [locations lastObject];
    
    NSLog(@"%f %f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude);
    
    m_bEnableLocation = YES;
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    NSLog(@"%@", error.debugDescription);
    
    m_bEnableLocation = NO;
}


#pragma mark - button event

- (IBAction)onCamera:(id)sender
{
    [AudioPlayer playButtonEffectSound];
 
    [self.view endEditing:YES];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // if ipad
        alert.popoverPresentationController.sourceView = self.btnCamera;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.btnCamera.bounds.size.width/2.0f, self.btnCamera.bounds.size.height/2.0f, 1, 1);
        ///
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Take a Photo");
            
            [self takePhoto];
            
        }];
        [alert addAction:cameraAction];
        
        UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Get From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Get from a photo library");
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


- (IBAction)onDownload:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [self.view endEditing:YES];
    
    UIButton *btnDownload = (UIButton*)sender;
    
    NSArray *arrModels = [DBManager getModels];
    if (arrModels == nil || arrModels.count == 0)
    {
        [self showDefaultAlert:@"No Model information has been recorded yet" message:@""];
        return;
    }
    
    NSMutableArray *arrModelNames = [[NSMutableArray alloc] init];
    NSMutableArray *arrModelIndexs = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrModels = [[arrModels sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    NSLog(@"%@", arrModels);
    
    for (NSInteger i = 0; i < arrModels.count; i++)
    {
        Model *model = arrModels[i];
        
        if ([arrModelNames containsObject:model.model_name])
        {
            
            continue;
        }
        
        [arrModelNames addObject:model.model_name];
        [arrModelIndexs addObject:[NSNumber numberWithInteger:i]];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Model names" rows:arrModelNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         
         [self setValues:arrModels[[arrModelIndexs[selectedIndex] integerValue]]];
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:btnDownload];
}

-(void)setValues:(Model*)model
{
    self.imgPhoto.image = [UIImage imageWithData:model.model_imgPhoto];
    self.txtModelName.text = model.model_name;
    [self.btnDateOfBirth setTitle:model.model_birth forState:UIControlStateNormal];
    if ([model.model_gender isEqual:[NSNumber numberWithBool:YES]])
    {
        [self.segGender setSelectedSegmentIndex:1];
    }
    else
        [self.segGender setSelectedSegmentIndex:0];
    
    self.txtEthnicity.text = model.model_ethnicity;
    self.txtParentName.text = model.model_parent;
    
    self.txtStreetAddress.text = model.model_streetAdress;
    self.txtCity.text = model.model_city;
    self.txtState.text = model.model_state;
    self.txtCountry.text = model.model_country;
    self.txtPostalCode.text = model.model_zipCode;
    
    self.txtEmail.text = model.model_email;
    self.txtPhone.text = model.model_phone;
    
    [g_modelRelease setModel:model];
    
}

-(void)showAddress
{
    self.txtStreetAddress.text = m_strStreetAddress;
    self.txtCity.text = m_strCity;
    self.txtState.text = m_strState;
    self.txtCountry.text = m_strCountry;
    self.txtPostalCode.text = m_strPostalCode;
    
}

- (IBAction)onSelectLocation:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [self.view endEditing:YES];
    
    if (m_bEnableLocation == NO)
    {
        [self showDefaultAlert:@"Connection Error" message:@"Cannot get your address!"];
        return;
    }
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.dimBackground = YES;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            
            //NSString *latitude, *longitude, *state, *country;
            
            m_strLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
            m_strLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
            
            m_strStreetAddress = placemark.subLocality;
            m_strState = placemark.administrativeArea;
            m_strCity = placemark.locality;
            m_strCountry = placemark.country;
            m_strPostalCode = placemark.postalCode;
            
            NSLog(@"%@, %@, %@", m_strCountry, m_strState, placemark.thoroughfare);
            
            [self showAddress];
            
            progressHUD.hidden = YES;
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
            progressHUD.hidden = YES;
            
            [self showDefaultAlert:@"Connection Error" message:@"Cannot get your address!"];
            
        }
    }];
}

- (IBAction)onBirth:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    [self showDatePicker:UIDatePickerModeDate];
}

- (IBAction)onSegGender:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    
    if (self.segGender.selectedSegmentIndex == 1)
    {
        // male
        self.imgPhoto.image = [UIImage imageNamed:@"male.png"];
    }
    else // if female
    {
        self.imgPhoto.image = [UIImage imageNamed:@"female.png"];
    }
    
    
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

#pragma mark - save status
-(void)saveStatus
{
    NSData *imgData = UIImagePNGRepresentation(self.imgPhoto.image);
    
    NSString *strModelName = self.txtModelName.text;
    NSString *strBirth = self.btnDateOfBirth.titleLabel.text;
    NSString *strGender = @"Female";
    if (self.segGender.selectedSegmentIndex == 1) {
        strGender = @"Male";
    }
    NSString *strEthnicity = self.txtEthnicity.text;
    NSString *strParentName = self.txtParentName.text;
    NSString *strStreetAddress = self.txtStreetAddress.text;
    NSString *strCity = self.txtCity.text;
    NSString *strState = self.txtState.text;
    NSString *strCountry = self.txtCountry.text;
    NSString *strZipCode = self.txtPostalCode.text;
    NSString *strEmail = self.txtEmail.text;
    NSString *strPhone = self.txtPhone.text;
    
    [g_modelRelease setModelPhoto:imgData Name:strModelName Birthday:strBirth Gender:strGender Ethnicity:strEthnicity ParentName:strParentName];
    [g_modelRelease setModelStreetAddress:strStreetAddress City:strCity State:strState Country:strCountry Zipcode:strZipCode Email:strEmail Phone:strPhone];
    
}

-(void)resumeStatus
{
    if (g_modelRelease.dataModel_photo != nil && g_modelRelease.dataModel_photo.length != 0) {
        self.imgPhoto.image = [UIImage imageWithData:g_modelRelease.dataModel_photo];
    }
    self.txtModelName.text = g_modelRelease.strModel_name;
    
    if (!g_isNew) {
        [self.txtModelName setEnabled:NO];
    }
    
    if (g_modelRelease.strModel_birth != nil && ![g_modelRelease.strModel_birth isEqualToString:@""])
    {
        [self.btnDateOfBirth setTitle:g_modelRelease.strModel_birth forState:UIControlStateNormal];
    }
    else{
        NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
        [defaultFormatter setDateFormat:@"MM/dd/YYYY"];
        
        NSString *strSelectedDate = [defaultFormatter stringFromDate:[NSDate date]];
        [self.btnDateOfBirth setTitle:strSelectedDate forState:UIControlStateNormal];
        g_modelRelease.strModel_birth = strSelectedDate;
    }
    
    if ([g_modelRelease.strModel_gender isEqual:@"Male"])
        [self.segGender setSelectedSegmentIndex:1];
    else
        [self.segGender setSelectedSegmentIndex:0];
    
    self.txtEthnicity.text = g_modelRelease.strModel_ethnicity;
    self.txtParentName.text = g_modelRelease.strModel_parentName;
    self.txtStreetAddress.text = g_modelRelease.strModel_streetAddress;
    self.txtCity.text = g_modelRelease.strModel_city;
    self.txtState.text = g_modelRelease.strModel_state;
    self.txtCountry.text = g_modelRelease.strModel_country;
    self.txtPostalCode.text = g_modelRelease.strModel_zipCode;
    self.txtEmail.text = g_modelRelease.strModel_email;
    self.txtPhone.text = g_modelRelease.strModel_phone;
    
}

-(BOOL)checkModelDatas
{
    
    NSData *imgData = UIImagePNGRepresentation(self.imgPhoto.image);
    
    NSString *strModelName = self.txtModelName.text;
    NSString *strBirth = self.btnDateOfBirth.titleLabel.text;
    NSString *strGender = @"Female";
    if (self.segGender.selectedSegmentIndex == 1) {
        strGender = @"Male";
    }
    NSString *strEthnicity = self.txtEthnicity.text;
    NSString *strParentName = self.txtParentName.text;
    NSString *strStreetAddress = self.txtStreetAddress.text;
    NSString *strCity = self.txtCity.text;
    NSString *strState = self.txtState.text;
    NSString *strCountry = self.txtCountry.text;
    NSString *strZipCode = self.txtPostalCode.text;
    NSString *strEmail = self.txtEmail.text;
    NSString *strPhone = self.txtPhone.text;
    
    if ([strModelName isEqual:@""])
    {
        [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
        return NO;
    }
    
    
    if ([self getIsChild] == YES && [strParentName isEqual:@""]) {
        [self showDefaultAlert:@"Missing Information" message:@"If under 18 years old, Please include the Parent Name befor continuing"];
        return NO;
    }
    else if ([self getIsChild] == NO)
    {
        strParentName = @"";
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    
    if ([self isEmptyWithDic:dic Title:str_Gender Content:strGender])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_Ethnicity Content:strEthnicity])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_StreetAddress Content:strStreetAddress])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_City Content:strCity])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_State Content:strState])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_Country Content:strCountry])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_Email Content:strEmail])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:str_Phone Content:strPhone])
        return NO;
    
    [g_modelRelease setModelPhoto:imgData Name:strModelName Birthday:strBirth Gender:strGender Ethnicity:strEthnicity ParentName:strParentName];
    [g_modelRelease setModelStreetAddress:strStreetAddress City:strCity State:strState Country:strCountry Zipcode:strZipCode Email:strEmail Phone:strPhone];
    
    return YES;
}

-(BOOL)isEmptyWithDic:(NSDictionary*)dic Title:(NSString*)title Content:(NSString*)content
{
    if ([[dic valueForKey:title] isEqual:@"Required"]) {
        if ([title isEqualToString:str_Email])
        {
            if (![self validateEmailWithString:content]) {
                [self showDefaultAlert:@"Invalid email" message:@"Email address is not formatted correctly."];
                return YES;
            }
        }
        
        if ([content isEqual:@""])
        {
            [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
            return YES;
        }
    }
    return NO;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
