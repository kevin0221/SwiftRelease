//
//  NewModelStep1TableViewController.m
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "ShootInfoViewController.h"
#import "MBProgressHUD.h"

#import "NewReleaseViewController.h"
#import "DBManager.h"
#import "ActionSheetStringPicker.h"
#import "AudioPlayer.h"

@interface ShootInfoViewController ()
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@end

@implementation ShootInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    self.btnDate.clipsToBounds = YES;
    
    // set current date
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM/dd/YYYY"];
    
    NSString *strSelectedDate = [formatter1 stringFromDate:[NSDate date]];
    [self.btnDate setTitle:strSelectedDate forState:UIControlStateNormal];
    
    [self setDefaultValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setDefaultValue
{
    NSDictionary *dicPhotographerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
    self.txtPhotographerName.text = [dicPhotographerInfo objectForKey:@"name"];
    
    switch (g_releaseType) {
        case ModelType:
            {
                self.txtPhotographerName.text = g_modelRelease.strPhotoshoot_photographer;
                if (!g_isNew) {
                    [self.txtPhotographerName setEnabled:NO];
                }
                if (g_modelRelease.strPhotoshoot_photographer == nil || [g_modelRelease.strPhotoshoot_photographer isEqualToString:@""]) {
                    self.txtPhotographerName.text = [dicPhotographerInfo objectForKey:@"name"];
                }
                self.txtTitle.text = g_modelRelease.strPhotoshoot_title;
                self.txtDescription.text = g_modelRelease.strPhotoshoot_description;
                [self.btnDate setTitle:g_modelRelease.strPhotoshoot_date forState:UIControlStateNormal];
                self.txtCity.text = g_modelRelease.strPhotoshoot_city;
                self.txtState.text = g_modelRelease.strPhotoshoot_state;
                self.txtCountry.text = g_modelRelease.strPhotoshoot_country;

            }
            break;
        case PropertyType:
            {
                self.txtPhotographerName.text = g_propertyRelease.strPhotoshoot_photographer;
                if (!g_isNew) {
                    [self.txtPhotographerName setEnabled:NO];
                }
                if (g_propertyRelease.strPhotoshoot_photographer == nil || [g_propertyRelease.strPhotoshoot_photographer isEqualToString:@""]) {
                    self.txtPhotographerName.text = [dicPhotographerInfo objectForKey:@"name"];
                }
                self.txtTitle.text = g_propertyRelease.strPhotoshoot_title;
                self.txtDescription.text = g_propertyRelease.strPhotoshoot_description;
                [self.btnDate setTitle:g_propertyRelease.strPhotoshoot_date forState:UIControlStateNormal];
                self.txtCity.text = g_propertyRelease.strPhotoshoot_city;
                self.txtState.text = g_propertyRelease.strPhotoshoot_state;
                self.txtCountry.text = g_propertyRelease.strPhotoshoot_country;
            }
            break;
        default:
            break;
    }
    
    
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    currentLocation = [locations lastObject];
    
    NSLog(@"%f %f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude);

    m_bAvailableGPS = YES;
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    m_bAvailableGPS = NO;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 48.0f;
    
    NSInteger row = [indexPath row];
    NSArray *arrTitles = @[@"Photographer", @"Shoot Title", @"Shoot Description", @"Date"];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    
    switch (row)
    {
        case 2:
        case 3:
        case 4:
        {
            NSString *strContent = [dic valueForKey:arrTitles[row-1]];
            if([strContent isEqualToString:@"Off"])
                height = 0.0f;
            
        }
            break;
            
        default:
            height = 48.0f;
            break;
    }
    
    
    
    return height;
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
        
        // if ipad
        alertController.popoverPresentationController.sourceView = self.btnDate;
        alertController.popoverPresentationController.sourceRect = CGRectMake(self.btnDate.bounds.size.width - 100, 22, 1, 1);
        //////
        
        
        [alertController.view addSubview:viewDatePicker];
        
        
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

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [actionSheet addSubview:viewDatePicker];
        [actionSheet showInView:self.view];
        
    }
}


-(void)setSelectedDateInField
{
    NSLog(@"date :: %@",datePicker.date.description);
    
    
    //set Date formatter
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM/dd/YYYY"];
    
    
    NSString *strSelectedDate = [formatter1 stringFromDate:datePicker.date];
    [self.btnDate setTitle:strSelectedDate forState:UIControlStateNormal];
    
    
    
}



#pragma - button event

- (IBAction)onDownload:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    
    UIButton *btnDownload = (UIButton*)sender;
    
    NSArray *arrPhotoshoots = [DBManager getPhotoShoots];
    if (arrPhotoshoots == nil || arrPhotoshoots.count == 0)
    {
        [self showDefaultAlert:@"No Shoot information has been recorded yet" message:@""];
        return;
    }
    
    NSMutableArray *arrPhotographers = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrPhotoshoots.count; i++)
    {
        Photoshoot *photoshoot = arrPhotoshoots[i];
        NSString *str = [NSString stringWithFormat:@"%@ / %@", photoshoot.photographer, photoshoot.shootTitle];
        
        [arrPhotographers addObject:str];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"Photographer/Title" rows:arrPhotographers initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        
        [self setValues:arrPhotoshoots[selectedIndex]];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:btnDownload];
    
}

-(void)setValues:(Photoshoot*)photoshoot
{
    self.txtPhotographerName.text = photoshoot.photographer;
    self.txtTitle.text = photoshoot.shootTitle;
    self.txtDescription.text = photoshoot.shootDescription;
    [self.btnDate setTitle:photoshoot.date forState:UIControlStateNormal];
    
    self.txtCity.text = photoshoot.city;
    self.txtState.text = photoshoot.state;
    self.txtCountry.text = photoshoot.country;
    switch (g_releaseType) {
        case ModelType:
            [g_modelRelease setPhotoshoot:photoshoot];
            break;
        case PropertyType:
            [g_propertyRelease setPhotoshoot:photoshoot];
            break;
        default:
            break;
    }
    
    
}

- (IBAction)onMap:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    
    if (m_bAvailableGPS == NO) {
        [self showDefaultAlert:@"Connetion Error." message:@"Cannot get your location!"];
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

            m_strState = placemark.administrativeArea;
            m_strCountry = placemark.country;
            m_strCity = placemark.locality;
            
            NSLog(@"%@, %@, %@", m_strCity, m_strState, m_strCountry);
            
            [self showAddress];
            
            progressHUD.hidden = YES;
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
            progressHUD.hidden = YES;
            [self showDefaultAlert:@"Connection Error" message:@"Cannot get your location!"];
        }
    }];
    
}

-(void)showAddress
{
    self.txtCountry.text = m_strCountry;
    self.txtState.text = m_strState;
    self.txtCity.text = m_strCity;
}


- (IBAction)onDatePicker:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view endEditing:YES];
    [self showDatePicker:UIDatePickerModeDate];
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


#pragma mark - check datas

-(BOOL)checkInputDatas
{
    NSString *strPhotographer = self.txtPhotographerName.text;
    NSString *strTitle = self.txtTitle.text;
    NSString *strDescription = self.txtDescription.text;
    NSString *strDate = self.btnDate.titleLabel.text;
    
    NSString *strCity = self.txtCity.text;
    NSString *strState = self.txtState.text;
    NSString *strCountry = self.txtCountry.text;
    
    switch (g_releaseType) {
        case ModelType:
            [g_modelRelease setPhotoshootPhotographer:strPhotographer Title:strTitle Description:strDescription Date:strDate City:strCity State:strState Country:strCountry];
            
            break;
        case PropertyType:
            [g_propertyRelease setPhotoshootPhotographer:strPhotographer Title:strTitle Description:strDescription Date:strDate City:strCity State:strState Country:strCountry];
            break;
        default:
            break;
    }
    
    if ([strPhotographer isEqual:@""] || [strCity isEqual:@""] || [strState isEqual:@""] || [strCountry isEqual:@""])
    {
        [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
        return NO;
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    
    if ([self isEmptyWithDic:dic Title:@"Shoot Title" Content:strTitle])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:@"Shoot Description" Content:strDescription])
        return NO;
    
    if ([self isEmptyWithDic:dic Title:@"Date" Content:strDate])
        return NO;
    
    
    return YES;
}

-(BOOL)isEmptyWithDic:(NSDictionary*)dic Title:(NSString*)title Content:(NSString*)content
{
    if ([[dic valueForKey:title] isEqual:@"Required"]) {
        if ([content isEqual:@""])
        {
            [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
            return YES;
        }
    }
    return NO;
}



@end
