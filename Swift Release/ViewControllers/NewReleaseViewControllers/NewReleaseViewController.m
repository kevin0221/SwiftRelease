//
//  NewModelViewController.m
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "NewReleaseViewController.h"
#import "ShootInfoViewController.h"
#import "ModelInfoTableViewController.h"
#import "PropertyInformationTableViewController.h"
#import "WitnessInfoTableViewController.h"
#import "OwnerInfoTableViewController.h"
#import "TermsViewController.h"
#import "SignatureViewController.h"

#import "DBManager.h"
#import "AudioPlayer.h"

#define kLetterWidth 2550
#define kLetterHeight 3000
#define kPadding 150



ReleaseType g_releaseType;
ModelRelease *g_modelRelease;
PropertyRelease *g_propertyRelease;
DataModel *g_mergeRelease;
BOOL g_isNew;

@interface NewReleaseViewController ()
{
    int pageNumber;
    UIViewController *activeViewController;
    UINavigationController *containerNavigationController;
    
    BOOL b_photographerSigned;
    BOOL b_modelSigned;
    BOOL b_PropertySigned;
    BOOL b_witnessSigned;
    CGSize _pageSize;
}
@end

@implementation NewReleaseViewController
@synthesize containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 0;
    
    b_photographerSigned = NO;
    b_modelSigned = NO;
    b_PropertySigned = NO;
    b_witnessSigned = NO;
    
    
    // show title
    switch (g_releaseType) {
        case ModelType:
            if (g_isNew) {
                self.lblTitle.text = @"New Model Release";
                g_modelRelease = [[ModelRelease alloc] init];
            } else {
                self.lblTitle.text = @"Update Model Release";
            }
            break;
        case PropertyType:
            
            if ([UIScreen mainScreen].bounds.size.height < 667) {
                [self.btnCancel setTitle:@"" forState:UIControlStateNormal];
                [self.btnCancel setImage:[UIImage imageNamed:@"cancel_white"] forState:UIControlStateNormal];
                UIEdgeInsets edgeInsets = {10, 22, 2, 2};
                [self.btnCancel setImageEdgeInsets:edgeInsets];
            }
            if (g_isNew) {
                self.lblTitle.text = @"New Property Release";
                g_propertyRelease = [[PropertyRelease alloc]init];
            } else {
                self.lblTitle.text = @"Update Property Release";
            }
            
            break;
        default:
            break;
    }
    
    // Shoot Info view show
    containerNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewReleaseNavigationController"];
    [self updateActiveViewController:containerNavigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pageNumber < 1) {
        [self.btnBack setEnabled:NO];
    }
    
    if (b_witnessSigned == YES)
    {
        [self gotoWitnessSignViewPage];
    }
    
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - button event

- (IBAction)onCancel:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomLayoutContraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];

    if([self.btnNext.titleLabel.text isEqualToString:@"Agree >"])
    {
        switch (g_releaseType)
        {
            case ModelType:
                [self gotoModelSignature];
                break;
            case PropertyType:
                [self gotoPropertySignPage];
                break;
            default:
                break;
        }
        //pageNumber += 1;
        return;
    }
    
    switch (pageNumber) {
        case 0:
            {
                NSDictionary *dicPhotographerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
                NSData *dataPhotographerSign = [dicPhotographerInfo objectForKey:@"imgSignature"];
                NSString *signDate = [dicPhotographerInfo objectForKey:@"SignDate"];
                if (dataPhotographerSign == nil || dataPhotographerSign.length == 0)
                {
                    [self gotoPhotographerSignature];
                }
                else
                {
                    switch (g_releaseType)
                    {
                        case ModelType:
                            g_modelRelease.imgPhotoshoot_signature = dataPhotographerSign;
                            g_modelRelease.strPhotoshoot_signDate = signDate;
                            break;
                        case PropertyType:
                            g_propertyRelease.imgPhotoshoot_signature = dataPhotographerSign;
                            g_propertyRelease.strPhotoshoot_signDate = signDate;
                        default:
                            break;
                    }
                    ShootInfoViewController* shootInfoViewController = (ShootInfoViewController *)containerNavigationController.visibleViewController;
                    
                    if ([shootInfoViewController checkInputDatas] == NO)
                        return;
                    
                    [self gotoModelOrPropertyInfoPage];
                }
                
            }
            break;
        case 1:
            switch (g_releaseType) {
                case ModelType:
                    {
                        ModelInfoTableViewController *modelInfoController = (ModelInfoTableViewController*)containerNavigationController.visibleViewController;
                        if ([modelInfoController checkModelDatas] == NO )
                        {
                            return;
                        }
                        [self gotoWitnessInfoPage];
                    }
                    break;
                case PropertyType:
                    [self gotoOwnershipInfoPage];
                    break;
                default:
                    break;
            }
            
            break;
        case 2:
            switch (g_releaseType) {
                case ModelType:
                    {
                        WitnessInfoTableViewController *witnessInfoViewController = (WitnessInfoTableViewController*)containerNavigationController.visibleViewController;
                        NSString *strWitnessName = witnessInfoViewController.txtWitnessName.text;
                        
                        NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
                        NSString *strWitness = [dicCustomizeFields valueForKey:str_Witness];
                        
                        if ([strWitnessName isEqual:@""] && [strWitness isEqualToString:@"Required"])
                        {
                            [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
                            return;
                        }
                        [g_modelRelease setWitnessInfoName:strWitnessName];
                        [self gotoTermsViewPage];
                    }
                    break;
                case PropertyType:
                    if (![self checkOwnershipInfoDatas]) {
                        return;
                    }
                    [self gotoWitnessInfoPage];
                    break;
                default:
                    break;
            }
            
            break;
        case 3:
            switch (g_releaseType) {
                case ModelType:
                    
                    break;
                case PropertyType:
                    {
                        WitnessInfoTableViewController *witnessInfoViewController = (WitnessInfoTableViewController*)containerNavigationController.visibleViewController;
                        
                        NSString *strWitnessName = witnessInfoViewController.txtWitnessName.text;
                        
                        NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
                        NSString *strWitness = [dicCustomizeFields valueForKey:str_Witness];
                        
                        if ([strWitnessName isEqual:@""] && [strWitness isEqualToString:@"Required"])
                        {
                            [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
                            return;
                        }
                        [g_propertyRelease setWitnessInfoName:strWitnessName];
                        
                        [self gotoTermsViewPage];
                        
                    }
                    
                    break;
                default:
                    break;
            }
            
            break;
        
        default:
            break;
    }
    
    self.lblStep.text = [NSString stringWithFormat:@"Step%d", pageNumber+1];
    if (pageNumber < 1) {
        [self.btnBack setEnabled:NO];
    }
    else
        [self.btnBack setEnabled:YES];
    
}

- (IBAction)onBack:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomLayoutContraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    if (pageNumber < 1)
    {
        
        return;
    }
    
    if (pageNumber == 3) {
        [self.btnNext setTitle:@"Next >" forState:UIControlStateNormal];
    }
    
    [containerNavigationController popViewControllerAnimated:YES];
    pageNumber -= 1;
    self.lblStep.text = [NSString stringWithFormat:@"Step%d", pageNumber+1];
    
    if (pageNumber == 0)
    {
        [self.btnBack setEnabled:NO];
    }
    
}


// go to photograher's signature page
-(void)gotoPhotographerSignature
{
    ShootInfoViewController* shootInfoViewController = (ShootInfoViewController *)containerNavigationController.visibleViewController;
    
    if ([shootInfoViewController checkInputDatas] == NO)
        return;
    
    b_photographerSigned = YES;
    SignatureViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    signViewController.view.tag = 10;
    signViewController.delegate = self;
    signViewController.strTitle = @"Phtographer Signature";
    switch (g_releaseType) {
        case ModelType:
            signViewController.strSignerName = g_modelRelease.strPhotoshoot_photographer;
            break;
        case PropertyType:
            signViewController.strSignerName =g_propertyRelease.strPhotoshoot_photographer;
        default:
            break;
    }
    
    [self presentViewController:signViewController animated:YES completion:nil];
    
}

// goto Model Info Page (Step1 -> Step2)
-(void)gotoModelOrPropertyInfoPage
{
    
    
    switch (g_releaseType) {
        case ModelType:
            {
                pageNumber += 1;
                ModelInfoTableViewController *modelInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModelInfoViewController"];
                [containerNavigationController pushViewController:modelInfoController animated:YES];
                
            }
            break;
        case PropertyType:
            {
                
                pageNumber += 1;
                PropertyInformationTableViewController *propertyInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"PropertyInfoViewController"];
                [containerNavigationController pushViewController:propertyInfoController animated:YES];
            }
            break;
        default:
            break;
    }
    

}

// goto Model Sign Page
-(void)gotoModelSignature
{
    
    b_modelSigned = YES;
    SignatureViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    signViewController.view.tag = 10;
    signViewController.delegate = self;
    signViewController.strTitle = @"Model Signature";
    signViewController.strSignerName = g_modelRelease.strModel_name;
    [self presentViewController:signViewController animated:YES completion:nil];
}

// goto Property Signature page
-(void)gotoPropertySignPage
{
    
    b_PropertySigned = YES;
    SignatureViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    signViewController.view.tag = 10;
    signViewController.delegate = self;
    signViewController.strTitle = @"Property Signature";
    signViewController.strSignerName = g_propertyRelease.strProperty_Name;
    [self presentViewController:signViewController animated:YES completion:nil];
}

// goto Ownership Info page(Step2 -> Step3) // if releaseType == PropertyType
-(void)gotoOwnershipInfoPage
{
    if ([self checkPropertyDatas] == NO) {
        return;
    }
    
    pageNumber += 1;
    OwnerInfoTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OwnerInfoViewController"];
    [containerNavigationController pushViewController:controller animated:YES];
}

// goto Witness Info page
-(void)gotoWitnessInfoPage
{
    
    NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    NSString *strWitness = [dicCustomizeFields valueForKey:str_Witness];
    if ([strWitness isEqualToString:@"Off"])
    {
        [self.btnNext setTitle:@"Agree >" forState:UIControlStateNormal];
        pageNumber += 1;
        TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        [containerNavigationController pushViewController:termsViewController animated:YES];
        return;
    }
    
    
    WitnessInfoTableViewController *witnessInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"WitnessInfoViewController"];
    [containerNavigationController pushViewController:witnessInfoController animated:YES];
    pageNumber += 1;
    
    self.lblStep.text = [NSString stringWithFormat:@"Step%d", pageNumber+1];
}



-(BOOL)checkPropertyDatas
{
    PropertyInformationTableViewController *propertyInfoViewController = (PropertyInformationTableViewController*)containerNavigationController.visibleViewController;
    
    NSData *imgData = UIImagePNGRepresentation(propertyInfoViewController.imgPhoto.image);
    
    NSString *strDescription = propertyInfoViewController.txtDescription.text;
    NSString *strAddress = propertyInfoViewController.txtAddress.text;
    NSString *strCity = propertyInfoViewController.txtCity.text;
    NSString *strState = propertyInfoViewController.txtState.text;
    NSString *strCountry = propertyInfoViewController.txtCountry.text;
    NSString *strZipCode = propertyInfoViewController.txtZipCode.text;
    
    
    if ([strDescription isEqual:@""] || [strCity isEqual:@""] || [strState isEqual:@""] || [strCountry isEqual:@""] || [strZipCode isEqual:@""])
    {
        [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
        return NO;
    }
    
    
    
    [g_propertyRelease setPropertyDescription:strDescription Photo:imgData Address:strAddress City:strCity State:strState Country:strCountry ZipCode:strZipCode];
    
    return YES;
}

-(BOOL)checkOwnershipInfoDatas
{
    OwnerInfoTableViewController *ownerInfoController = (OwnerInfoTableViewController*)containerNavigationController.visibleViewController;
    
    OwnershipType ownershipType = IndividualOwner;
    NSString *strType = ownerInfoController.btnOwnerType.titleLabel.text;
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
    
    NSString *strName = ownerInfoController.txtName.text;
    NSString *strCorporationName = ownerInfoController.txtCorporationName.text;
    NSString *strTitle = ownerInfoController.txtTitle.text;
    
    NSString *strTel = ownerInfoController.txtPhone.text;
    NSString *strEmail = ownerInfoController.txtEmail.text;
    
    if ([strTel isEqual:@""] || [strEmail isEqual:@""])
    {
        [self showDefaultAlert:@"Missing Information" message:@"Please include all required information before continuing."];
        return NO;
    }
    if (![self validateEmailWithString:strEmail]) {
        [self showDefaultAlert:@"Invalid email" message:@"Email address is not formatted correctly."];
        return NO;
    }
    
    [g_propertyRelease setOwnershipType:ownershipType PropertyName:strName CorporationName:strCorporationName AuthorizedTitle:strTitle Phone:strTel Email:strEmail];
    
    return YES;
}

// sign view page
-(void)gotoWitnessSignViewPage
{
    
    NSString *strWitnessName = @"";
    switch (g_releaseType)
    {
        case ModelType:
            strWitnessName = g_modelRelease.strWitness_name;
            break;
        case PropertyType:
            strWitnessName = g_propertyRelease.strWitness_name;
            break;
        default:
            break;
    }
    b_witnessSigned = YES;
    SignatureViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
    signViewController.view.tag = 10;
    signViewController.delegate = self;
    signViewController.strTitle = @"Witness Signature";
    signViewController.strSignerName = strWitnessName;
    [self presentViewController:signViewController animated:YES completion:nil];
}

// if witness is enable, goto terms view page.
-(void)gotoTermsViewPage
{
    
    [self.btnNext setTitle:@"Agree >" forState:UIControlStateNormal];
    pageNumber += 1;
    TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [containerNavigationController pushViewController:termsViewController animated:YES];
    
    
}

#pragma mark - email validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - keyboard appears and disappears notification

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3f animations:^{
        
        self.bottomLayoutContraint.constant = keyboardSize.height;
        [self.view layoutIfNeeded];
    }];
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomLayoutContraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
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

///////////Container change/////////
#pragma mark - container change

-(void)updateActiveViewController:(UIViewController*)viewController
{
    [self removeInactiveViewController];
    if (viewController != nil)
    {
        activeViewController = viewController;
        [self addChildViewController:activeViewController];
        activeViewController.view.frame = containerView.bounds;
        [containerView addSubview:activeViewController.view];
        
        [activeViewController didMoveToParentViewController:self];
        
    }
}

-(void) removeInactiveViewController
{
    if (activeViewController != nil)
    {
        [activeViewController willMoveToParentViewController:nil];
        [activeViewController.view removeFromSuperview];
        
        [activeViewController removeFromParentViewController];
    }
}

#pragma mark -  SignDelegate
- (void)didSign:(NSData *)sign date:(NSString *)strDate
{
    // if Photographer signature
    if (b_photographerSigned == YES)
    {
        b_photographerSigned = NO;
        switch (g_releaseType) {
            case ModelType:
                g_modelRelease.imgPhotoshoot_signature = sign;
                g_modelRelease.strPhotoshoot_signDate = strDate;
                break;
            case PropertyType:
                g_propertyRelease.imgPhotoshoot_signature = sign;
                g_propertyRelease.strPhotoshoot_signDate = strDate;
                break;
            default:
                break;
        }
        
        [self gotoModelOrPropertyInfoPage];
        
        self.lblStep.text = [NSString stringWithFormat:@"Step%d", pageNumber+1];
        if (pageNumber > 0)
            [self.btnBack setEnabled:YES];
        else
            [self.btnBack setEnabled:NO];
        
        return;
    
    }

    // if Model Signature
    if (b_modelSigned == YES)
    {
        b_modelSigned = NO;
        
        [g_modelRelease setModelSignImgData:sign withDate:strDate];
        
        NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
        NSString *strWitness = [dicCustomizeFields valueForKey:str_Witness];
        if ([strWitness isEqualToString:@"Off"] || ([strWitness isEqualToString:@"Optional"] && [g_modelRelease.strWitness_name isEqual:@""]))
        {
            [self showModelRelease];
            return;
        }
        else
        {
            b_witnessSigned = YES;
        }
        return;
    }
    
    // if Property signature
    if (b_PropertySigned == YES)
    {
        b_PropertySigned = NO;
        
        [g_propertyRelease setPropertySignImgData:sign date:strDate];
        NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
        NSString *strWitness = [dicCustomizeFields valueForKey:str_Witness];
        if ([strWitness isEqualToString:@"Off"] || ([strWitness isEqualToString:@"Optional"] && [g_propertyRelease.strWitness_name isEqual:@""]))
        {
            [self showPropertyRelease];
            return;
        }
        else
        {
            b_witnessSigned = YES;
            [self gotoWitnessSignViewPage];
        }
        return;
    }
    
    // if Witness signature
    if (b_witnessSigned == YES) {
        b_witnessSigned = NO;
        switch (g_releaseType)
        {
            case ModelType:
                g_modelRelease.imgWitness_signature = sign;
                g_modelRelease.strWitness_signDate = strDate;
                [self showModelRelease];
                break;
            case PropertyType:
                g_propertyRelease.imgWitness_signature = sign;
                g_propertyRelease.strWitness_signDate = strDate;
                [self showPropertyRelease];
                break;
            default:
                break;
        }
        
        return;
    }
    
    
}

-(void)didSignCancel
{
    b_witnessSigned = NO;
}

#pragma mark - create and show Release(PDF)

-(void)showModelRelease
{
    int counter = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MR"] intValue];
    NSString *strCounter = [NSString stringWithFormat:@"%04d", counter+1];
    [[NSUserDefaults standardUserDefaults] setValue:strCounter forKey:@"MR"];
    NSString *filename = [NSString stringWithFormat:@"MR%@", strCounter];
    
    [self setupPDFDocumentNamed:filename Width:kLetterWidth Height:kLetterHeight];
    [self drawPDFPage:filename];
    [self finishPDF];
    filename = [NSString stringWithFormat:@"%@.pdf", filename];
    [self showPDF:filename];
    g_modelRelease.strFileName = filename;
    
}

-(void)showPropertyRelease
{
    
    int counter = [[[NSUserDefaults standardUserDefaults] valueForKey:@"PR"] intValue];
    NSString *strCounter = [NSString stringWithFormat:@"%04d", counter+1];
    [[NSUserDefaults standardUserDefaults] setValue:strCounter forKey:@"PR"];
    NSString *filename = [NSString stringWithFormat:@"PR%@", strCounter];
    
    [self setupPDFDocumentNamed:filename Width:kLetterWidth Height:kLetterHeight];
    [self drawPDFPage:filename];
    [self finishPDF];
    filename = [NSString stringWithFormat:@"%@.pdf", filename];
    [self showPDF:filename];
    
    g_propertyRelease.strFileName = filename;
    
}

#pragma mark - PDF CREATE

-(void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height
{
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
}


-(void)drawPDFPage:(NSString*)filename
{
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
    
    
    UIColor *defaultColor = [UIColor blackColor];
    
    NSDictionary *dicPhotographerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
    
    // initialize
    CGRect rect = CGRectMake(0, 0, 0, 150);
    float width = 0.0f;
    
    // company logo image
    NSString *strCompanyName = [dicPhotographerInfo valueForKey:@"companyName"];
    NSData *dataLogo = [dicPhotographerInfo valueForKey:@"imgLogo"];
    
    if (dataLogo != nil && dataLogo.length > 0)
    {
        UIImage *logoImage = [UIImage imageWithData:[dicPhotographerInfo objectForKey:@"imgLogo"]];
        rect = [self addImage:logoImage withFrame:CGRectMake(kPadding, kPadding, 300, 200)];
    }
    
    if (strCompanyName != nil && strCompanyName.length > 0)
    {
        // Company Info
        float offsetX = kPadding + rect.size.width;
        float offsetY = kPadding;
        width = kLetterWidth / 2 - kPadding - offsetX;
        CGRect rectTmp = rect;
        if (rect.size.height == 200)
        {
            offsetX += 70;
        }
        rect = [self addText:strCompanyName withFrame:CGRectMake(offsetX, offsetY, width, 100) fontSize:52.0f weight:0.5f color:defaultColor];
        NSString *strCompanyPhone = [dicPhotographerInfo objectForKey:@"companyPhone"];
        if (strCompanyPhone.length > 0)
            rect = [self addText:strCompanyPhone withFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 30, width, 100) fontSize:36.0f weight:0.2f color:defaultColor];
        NSString *strEmail = [dicPhotographerInfo objectForKey:@"email"];
        if (strEmail.length > 0)
            rect = [self addText:strEmail withFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 30, width, 100) fontSize:36.0f weight:0.2f color:defaultColor];
        
        if (rectTmp.size.height == 200)
        {
            rect = CGRectMake(kPadding, kPadding, 300, 200);
        }
        
    }
    
    /***************** Release Information *************************/
    // Release Title
    
    width = (kLetterWidth - kPadding * 3)/2;
    NSString *strReleaseTitle = @"Model Release";
    if (g_releaseType == PropertyType) {
        strReleaseTitle = @"Property Release";
    }
    rect = [self addText:strReleaseTitle withFrame:CGRectMake(kPadding, rect.origin.y + rect.size.height + 30, width, 100) fontSize:80.0f weight:0.5f color:defaultColor];
    
    
    // Legal Text
    NSString *strLegal = @"";
    
    switch (g_releaseType)
    {
        case ModelType:
            strLegal = g_modelRelease.strLegalText;
            
            break;
        case PropertyType:
            strLegal = g_propertyRelease.strLegalText;
            break;
        default:
            strLegal = @"english";
            break;
    }
   
    [self addText:strLegal withFrame:CGRectMake(kPadding, rect.origin.y+rect.size.height + 30, width, kLetterHeight - rect.origin.y - kPadding - 100) fontSize:34.0f weight:0.15f color:defaultColor];
    
    // copywrite
    NSString *strLegalTitle = @"Standard Release(English)";
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        strLegalTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomTextTitle"];
    }
    NSString *strCopywrite = [NSString stringWithFormat:@"%@, Reference ID# %@ \nCreated by Swift Release for iOS version 1.02", strLegalTitle, filename];
    [self addText:strCopywrite withFrame:CGRectMake(kPadding, kLetterHeight - kPadding - 80, width, 100) fontSize:36.0f weight:0.2f color:defaultColor];
    
    
    switch (g_releaseType) {
        case ModelType:
            [self drawModelRightPanel];
            break;
        case PropertyType:
            [self drawPropertyRightPanel];
            break;
        default:
            break;
    }
    
}

-(void)drawModelRightPanel
{
    UIColor *defaultColor = [UIColor blackColor];
    
    NSDictionary *dicCustomizeFields = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    
    float panelWidth = (kLetterWidth - kPadding * 3)/2;
    /****** Model Information ************/
    UIColor *titleColor = [UIColor colorWithRed:28/255.0f green:118/255.0f blue:235/255.0f alpha:1.0f];
    // Title
    float offsetX = kPadding * 2.0f + panelWidth;
    float offsetY = kPadding;
    float imageHeight = 550;
    // Model Info title
    CGRect rect = [self addText:@"Model Information" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:52.0f weight:0.5f color:titleColor];
    // model photo
    UIImage *imgPhoto = [UIImage imageWithData:g_modelRelease.dataModel_photo];
    [imgPhoto drawInRect:CGRectMake(offsetX+500, kPadding, imageHeight, imageHeight)];
    // name
    offsetY += rect.size.height + 40;
    rect = [self addText:@"Name:" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    
    offsetY += rect.size.height;
    rect = [self addText:g_modelRelease.strModel_name withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Date of Birth
    offsetY += rect.size.height + 40;
    rect = [self addText:@"Date of Birth:" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    offsetY += rect.size.height;
    rect = [self addText:@"(mm/dd/yyyy)" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:34.0f weight:0.15f color:[UIColor grayColor]];
    offsetY += rect.size.height;
    rect = [self addText:g_modelRelease.strModel_birth withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Gender
    NSString *strGender = [dicCustomizeFields valueForKey:str_Gender];
    if (![strGender isEqual:@"Off"])
    {
        offsetY += rect.size.height + 30;
        rect = [self addText:@"Gender:" withFrame:CGRectMake(offsetX, offsetY, 200, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        [self addText:g_modelRelease.strModel_gender withFrame:CGRectMake(offsetX + rect.size.width + 20, offsetY, 200, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        
    }
    
    // Ethnicity
    NSString *strEthnicity = [dicCustomizeFields valueForKey:str_Ethnicity];
    if (![strEthnicity isEqual:@"Off"] && (g_modelRelease.strModel_ethnicity.length > 0))
    {
        offsetY += rect.size.height + 30;
        rect = [self addText:@"Ethnicity" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        offsetY += rect.size.height;
        rect = [self addText:g_modelRelease.strModel_ethnicity withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        
        // detail
        offsetY = kPadding + imageHeight + 30;
        NSString *str = @"Ethnicity information is requested for descriptive purposes only, and serves as a means of providing more accuracy in assigning search words.";
        rect = [self addText:str withFrame:CGRectMake(offsetX, offsetY, panelWidth, 150) fontSize:34.0f weight:0.15f color:[UIColor grayColor]];
    }
    
    // address
    offsetY += rect.size.height + 50;
    rect = [self addText:@"Address:" withFrame:CGRectMake(offsetX, offsetY, 500, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_modelRelease.strModel_streetAddress withFrame:CGRectMake(offsetX + rect.size.width + 20, offsetY, 500, 100) fontSize:36.0f weight:0.15f color:defaultColor];

    NSString *strLocation = [self getLocationStringWithCity:g_modelRelease.strModel_city state:g_modelRelease.strModel_state country:g_modelRelease.strModel_country];
    offsetY += rect.size.height;
    rect = [self addText:strLocation withFrame:CGRectMake(offsetX, offsetY, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Phone
    NSString *strPhone = [dicCustomizeFields valueForKey:str_Phone];
    if (![strPhone isEqual:@"Off"])
    {
        offsetY += rect.size.height;
        rect = [self addText:@"Tel:" withFrame:CGRectMake(offsetX, offsetY, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_modelRelease.strModel_phone withFrame:CGRectMake(offsetX + rect.size.width + 20, offsetY, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    
    
    // Email
    NSString *strEmail = [dicCustomizeFields valueForKey:str_Email];
    if (![strEmail isEqual:@"Off"])
    {
        offsetY += rect.size.height;
        rect = [self addText:@"Email:" withFrame:CGRectMake(offsetX, offsetY, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_modelRelease.strModel_email withFrame:CGRectMake(offsetX + rect.size.width + 20, offsetY, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    
    // Signature
    offsetY += rect.size.height + 30;
    UIImage *imgSignature_bg = [UIImage imageNamed:@"signature_bg.png"];
    [imgSignature_bg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
    rect = [self addText:@"Signature:" withFrame:CGRectMake(offsetX + 30, offsetY + 100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
    UIImage *imgSignature = [UIImage imageWithData:g_modelRelease.imgModel_signatureData];
    [imgSignature drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
    
    rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX + panelWidth/3.0f, offsetY + 200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
    rect = [self addText:g_modelRelease.strModel_signDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    /*********** Shoot Information *************************/
    // title
    rect = [self addText:@"Shoot Information" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height +50, panelWidth, 100) fontSize:52.0f weight:0.5f color:titleColor];
    
    // photographer
    rect = [self addText:@"Photographer, Filmmaker: " withFrame:CGRectMake(offsetX, rect.origin.y +rect.size.height + 20, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_modelRelease.strPhotoshoot_photographer withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    // Date
    if (![[dicCustomizeFields valueForKey:str_Date] isEqual:@"Off"])
    {
        rect = [self addText:@"Date" withFrame:CGRectMake(offsetX, rect.origin.y+rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
        rect = [self addText:g_modelRelease.strPhotoshoot_date withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    
    // Shoot Title
    if (![[dicCustomizeFields valueForKey:str_ShootTitle] isEqual:@"Off"]) {
        rect = [self addText:@"Shoot Title: " withFrame:CGRectMake(offsetX, rect.origin.y+rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_modelRelease.strPhotoshoot_title withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    // Shoot Description
    if (![[dicCustomizeFields valueForKey:str_ShootDescription] isEqual:@"Off"]) {
        rect = [self addText:@"Shoot Description: " withFrame:CGRectMake(offsetX, rect.origin.y+rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_modelRelease.strPhotoshoot_description withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    // Location
    rect = [self addText:@"Location: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    NSString *strShootLocation = [self getLocationStringWithCity:g_modelRelease.strPhotoshoot_city state:g_modelRelease.strPhotoshoot_state country:g_modelRelease.strPhotoshoot_country];
    rect = [self addText:strShootLocation withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Signature
    offsetY = rect.origin.y + rect.size.height + 20;
    UIImage *imgShootSignBg = [UIImage imageNamed:@"signature_bg.png"];
    [imgShootSignBg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
    rect = [self addText:@"Signature:" withFrame:CGRectMake(offsetX+30, offsetY+100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
    
    //NSDictionary *dicPhotographerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
    //UIImage *imgPhotographerSign = [UIImage imageWithData:[dicPhotographerInfo objectForKey:@"imgSignature"]];
    UIImage *imgPhotographerSign = [UIImage imageWithData:g_modelRelease.imgPhotoshoot_signature];
    [imgPhotographerSign drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
    
    rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX+panelWidth/3, offsetY+200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
    //NSString *strShootSignDate = [dicPhotographerInfo valueForKey:@"SignDate"];
    NSString *strShootSignDate = g_modelRelease.strPhotoshoot_signDate;
    rect = [self addText:strShootSignDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    /********************* Witness Information ************************************/
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    NSString *strWitness = [dic valueForKey:str_Witness];
    if ((strWitness == nil || ![strWitness isEqualToString:@"Off"]) && ![g_modelRelease.strWitness_name isEqual:@""])
    {
        // title
        rect = [self addText:@"Witness Information" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height +50, panelWidth, 100) fontSize:52.0f weight:0.5f color:titleColor];
        
        NSString *strWitnessDetail = @"All persons signing and witnessing must be legal age and capacity in the area in which this Release is signed. A person cannot witness their own release.";
        rect = [self addText:strWitnessDetail withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth, 300) fontSize:36.0f weight:0.15f color:defaultColor];
        // Name
        rect = [self addText:@"Name: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_modelRelease.strWitness_name withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        
        // Signature
        offsetY = rect.origin.y + rect.size.height + 20;
        UIImage *imgWitnessSignBg = [UIImage imageNamed:@"signature_bg.png"];
        [imgWitnessSignBg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
        rect = [self addText:@"Signature:" withFrame:CGRectMake(offsetX+30, offsetY+100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
    
        UIImage *imgWitnessSign = [UIImage imageWithData:g_modelRelease.imgWitness_signature];
        [imgWitnessSign drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
        
        
        rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX+panelWidth/3, offsetY+200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
        rect = [self addText:g_modelRelease.strWitness_signDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    
    
}


-(void)drawPropertyRightPanel
{
    UIColor *defaultColor = [UIColor blackColor];
    UIColor *titleColor = [UIColor colorWithRed:28/255.0f green:118/255.0f blue:235/255.0f alpha:1.0f];
    float panelWidth = (kLetterWidth - kPadding * 3)/2;
    
    /****** Shoot Information ************/
    // Title
    float offsetX = kPadding * 2.0f + panelWidth;
    float offsetY = kPadding;
    float imageHeight = 550;
    // model photo
    UIImage *imgPhoto = [UIImage imageWithData:g_propertyRelease.dataProperty_photo];
    [imgPhoto drawInRect:CGRectMake(kLetterWidth - kPadding - imageHeight, kPadding, imageHeight, imageHeight)];
    
    // Shoot Info title
    CGRect rect = [self addText:@"Shoot Information" withFrame:CGRectMake(offsetX, offsetY, panelWidth-550, 100) fontSize:52.0f weight:0.5f color:titleColor];
   
    // photographer
    rect = [self addText:@"Photographer, Filmmaker:" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 30, panelWidth-550, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strPhotoshoot_photographer withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth-550, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Date of Birth
    rect = [self addText:@"Date" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth-550, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:@"(mm/dd/yyyy):" withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth-550, 100) fontSize:34.0f weight:0.15f color:[UIColor grayColor]];
    rect = [self addText:g_propertyRelease.strPhotoshoot_date withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth-550, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    // Shoot Title
    rect = [self addText:@"Shoot Title:" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth - 550, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strPhotoshoot_title withFrame:CGRectMake(offsetX, rect.origin.y+rect.size.height, panelWidth-550, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Shoot Description
    rect = [self addText:@"Shoot Description:" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth - 550, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strPhotoshoot_description withFrame:CGRectMake(offsetX, rect.origin.y+rect.size.height, panelWidth-550, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    // Location
    rect = [self addText:@"Location:" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth - 550, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    NSString *strShootLocation = [self getLocationStringWithCity:g_propertyRelease.strPhotoshoot_city state:g_propertyRelease.strPhotoshoot_state country:g_propertyRelease.strPhotoshoot_country];
    rect = [self addText:strShootLocation withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth - 550, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    // Signature
    offsetY = kPadding + imageHeight + 60;
    UIImage *imgSignature_bg = [UIImage imageNamed:@"signature_bg.png"];
    [imgSignature_bg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
    rect = [self addText:@"Signature:" withFrame:CGRectMake(offsetX + 30, offsetY + 100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
    
    UIImage *imgPhotographerSign = [UIImage imageWithData:g_propertyRelease.imgPhotoshoot_signature];
    [imgPhotographerSign drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
    
    rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX + panelWidth/3.0f, offsetY + 200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
    NSString *strPhotographerSignDate = g_propertyRelease.strPhotoshoot_signDate;
    rect = [self addText:strPhotographerSignDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    /************ Property Information ******************/
    
    // title
    rect = [self addText:@"Property Information" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 50, panelWidth, 100) fontSize:52.0f weight:0.5f color:titleColor];
    
    rect = [self addText:@"Description: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 30, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_description withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Address: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_address withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"City: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_city withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"State/Province: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_state withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Zip/Postal Code: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_zipCode withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    /*********** Owner Information *************************/
    // title
    rect = [self addText:@"Owner Information" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height +50, panelWidth, 100) fontSize:52.0f weight:0.5f color:titleColor];
    
    rect = [self addText:@"Individual or Employee Name: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 30, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_Name withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Corporation Name: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_corporationName withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Title: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_authorizedTitle withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Tel: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_phone withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    rect = [self addText:@"Email: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
    rect = [self addText:g_propertyRelease.strProperty_email withFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    // Signature
    offsetY = rect.origin.y + rect.size.height + 20;
    UIImage *imgShootSignBg = [UIImage imageNamed:@"signature_bg.png"];
    [imgShootSignBg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
    [self addText:@"Signature:" withFrame:CGRectMake(offsetX+30, offsetY+100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
    UIImage *imgShootSignature = [UIImage imageWithData:g_propertyRelease.imgProperty_signature];
    [imgShootSignature drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
    
    rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX+panelWidth/3, offsetY+200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
    rect = [self addText:g_propertyRelease.strProperty_signDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    
    
    /********************* Witness Information ************************************/
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomizeFields"];
    NSString *strWitness = [dic valueForKey:str_Witness];
    if ((strWitness == nil || ![strWitness isEqualToString:@"Off"]) && ![g_propertyRelease.strWitness_name isEqual:@""])
    {
        // title
        rect = [self addText:@"Witness Information" withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height +50, panelWidth, 100) fontSize:52.0f weight:0.5f color:titleColor];
        
        NSString *strWitnessDetail = @"All persons signing and witnessing must be legal age and capacity in the area in which this Release is signed. A person cannot witness their own release.";
        rect = [self addText:strWitnessDetail withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth, 300) fontSize:36.0f weight:0.15f color:defaultColor];
        // Name
        rect = [self addText:@"Name: " withFrame:CGRectMake(offsetX, rect.origin.y + rect.size.height + 20, panelWidth, 100) fontSize:36.0f weight:0.5f color:defaultColor];
        rect = [self addText:g_propertyRelease.strWitness_name withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        
        // Signature
        offsetY = rect.origin.y + rect.size.height + 50;
        UIImage *imgWitnessSignBg = [UIImage imageNamed:@"signature_bg.png"];
        [imgWitnessSignBg drawInRect:CGRectMake(offsetX, offsetY, panelWidth, 180)];
        rect = [self addText:@"Signature:" withFrame:CGRectMake(offsetX+30, offsetY+100, panelWidth, 100) fontSize:36.0f weight:0.1f color:defaultColor];
        
        UIImage *imgWitnessSign = [UIImage imageWithData:g_propertyRelease.imgWitness_signature];
        [imgWitnessSign drawInRect:CGRectMake(offsetX + rect.size.width + 30, offsetY+10, panelWidth - rect.size.width - 30, 160)];
    
        rect = [self addText:@"Date Signed" withFrame:CGRectMake(offsetX+panelWidth/3, offsetY+200, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
        rect = [self addText:@"(mm/dd/yyyy): " withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:[UIColor grayColor]];
        rect = [self addText:g_propertyRelease.strWitness_signDate withFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, panelWidth, 100) fontSize:36.0f weight:0.15f color:defaultColor];
    }
    
    
    
}

-(NSString*)getLocationStringWithCity:(NSString*)city state:(NSString*)state country:(NSString*)country
{
    NSString *strLocation = city;
    NSString *strTmp = @"";
    if ([city isEqual:@""] || [state isEqual:@""])
    {
        if (![city isEqual:@""])
        {
            strTmp = city;
        }
        if (![state isEqual:@""]) {
            strTmp = state;
        }
        
        if (![strTmp isEqual:@""]) {
            strLocation = [NSString stringWithFormat:@"%@, %@", strTmp, country];
        }
    }
    else
        strLocation = [NSString stringWithFormat:@"%@, %@, %@", city, state, country];
   
    
    return strLocation;
}

-(CGRect)addImage:(UIImage*)img withFrame:(CGRect)frame
{
    
    [img drawInRect:frame];
    return frame;
}


-(CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize weight:(CGFloat)weight color:(UIColor*)color
{
    
    UIFont *font = [UIFont systemFontOfSize:fontSize weight:weight];

    CGRect renderingRect = [text boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    
    renderingRect = CGRectMake(frame.origin.x, frame.origin.y, renderingRect.size.width, renderingRect.size.height);
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:color};
    
    [text drawInRect:renderingRect withAttributes:textAttributes];
    
    return renderingRect;
}



-(void)finishPDF
{
    UIGraphicsEndPDFContext();
}


// OPEN PDF
- (void)showPDF:(NSString*)PDFfileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentDirectory stringByAppendingPathComponent:PDFfileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pdfPath])
    {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            
            [self.navigationController pushViewController:readerViewController animated:YES];
        }
    }
    
}

#pragma mark - ReaderViewController delegate

-(void)dismissReaderViewController:(ReaderViewController *)viewController
{
    switch (g_releaseType)
    {
        case ModelType:
            [DBManager saveModelData:g_modelRelease];
            break;
        case PropertyType:
            [DBManager savePropertyData:g_propertyRelease];
            break;
        default:
            break;
    }
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
