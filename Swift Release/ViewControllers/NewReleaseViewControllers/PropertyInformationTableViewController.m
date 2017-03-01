//
//  PropertyInformationTableViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "PropertyInformationTableViewController.h"
#import "MBProgressHUD.h"
#import "NewReleaseViewController.h"

#import "DBManager.h"
#import "ActionSheetStringPicker.h"
#import "AudioPlayer.h"

@interface PropertyInformationTableViewController ()
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@end

@implementation PropertyInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_bEnableLocation = YES;
    [self startGeoLocation];
   
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float imgHeight = screenSize.width * 330.0f/750.0f - 8 * 2;
    self.imgPhoto.layer.cornerRadius = imgHeight / 2.0f;
    self.imgPhoto.clipsToBounds = YES;
    
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
    CGFloat height = 44.0f;
    if (row == 0)
    {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        height = screenSize.width * 330.0f/750.0f;
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

#pragma mark - imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgPhoto.image = chosenImage;
    
    NSData *imgData = UIImagePNGRepresentation(chosenImage);
    g_propertyRelease.dataProperty_photo = imgData;
    
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


#pragma mark - button events

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

- (IBAction)onLocation:(id)sender
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

- (IBAction)onDownload:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    
    UIButton *btnDownload = (UIButton*)sender;
    
    NSArray *arrProperties = [DBManager getProperties];
    if (arrProperties == nil || arrProperties.count == 0)
    {
        [self showDefaultAlert:@"No Shoot information has been recorded yet" message:@""];
        return;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrProperties = [[arrProperties sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSMutableArray *arrPropertyDescriptions = [[NSMutableArray alloc] init];
    NSMutableArray *arrPropertyIndexs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrProperties.count; i++)
    {
        Property *property = arrProperties[i];
        
        if ([arrPropertyDescriptions containsObject:property.property_description])
        {
            continue;
        }
        
        [arrPropertyDescriptions addObject:property.property_description];
        [arrPropertyIndexs addObject:[NSNumber numberWithInt:i]];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Property Descriptions" rows:arrPropertyDescriptions initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         [self setValues:arrProperties[[arrPropertyIndexs[selectedIndex] integerValue]]];
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:btnDownload];
    
}

-(void)setValues:(Property*)property
{
    self.imgPhoto.image = [UIImage imageWithData:property.property_imgPhoto];
    self.txtDescription.text = property.property_description;
    self.txtAddress.text = property.property_streetAddress;
    self.txtCity.text = property.property_city;
    self.txtState.text = property.property_state;
    self.txtCountry.text = property.property_country;
    self.txtZipCode.text = property.property_zipCode;
    
    
    [g_propertyRelease setPropertyDescription:property.property_description Photo:property.property_imgPhoto Address:property.property_streetAddress City:property.property_city State:property.property_state Country:property.property_country ZipCode:property.property_zipCode];
    
}

-(void)showAddress
{
    self.txtAddress.text = m_strStreetAddress;
    self.txtCity.text = m_strCity;
    self.txtState.text = m_strState;
    self.txtCountry.text = m_strCountry;
    self.txtZipCode.text = m_strPostalCode;
    
    [g_propertyRelease setPropertyDescription:g_propertyRelease.strProperty_description Photo:g_propertyRelease.dataProperty_photo Address:m_strStreetAddress City:m_strCity State:m_strState Country:m_strCountry ZipCode:m_strPostalCode];
    
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
    
    NSString *strDescription = self.txtDescription.text;
    NSString *strAddress = self.txtAddress.text;
    NSString *strCity = self.txtCity.text;
    NSString *strState = self.txtState.text;
    NSString *strCountry = self.txtCountry.text;
    NSString *strZipCode = self.txtZipCode.text;
    
    [g_propertyRelease setPropertyDescription:strDescription Photo:imgData Address:strAddress City:strCity State:strState Country:strCountry ZipCode:strZipCode];
    
}

-(void)resumeStatus
{
    if (g_propertyRelease.dataProperty_photo != nil && g_propertyRelease.dataProperty_photo.length != 0) {
        self.imgPhoto.image = [UIImage imageWithData:g_propertyRelease.dataProperty_photo];
    }
    self.txtDescription.text = g_propertyRelease.strProperty_description;
    self.txtAddress.text = g_propertyRelease.strProperty_address;
    self.txtCity.text = g_propertyRelease.strProperty_city;
    self.txtState.text = g_propertyRelease.strProperty_state;
    self.txtCountry.text = g_propertyRelease.strProperty_country;
    self.txtZipCode.text = g_propertyRelease.strProperty_zipCode;
    
}


@end
