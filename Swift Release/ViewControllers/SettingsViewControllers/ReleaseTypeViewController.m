//
//  ReleaseTypeViewController.m
//  Swift Release
//
//  Created by beauty on 11/9/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "ReleaseTypeViewController.h"
#import "SettingViewController.h"
#import "SettingsMainTableViewController.h"
#import "DBManager.h"
#import "ActionSheetStringPicker.h"

#import "AudioPlayer.h"

@interface ReleaseTypeViewController ()

@end

@implementation ReleaseTypeViewController

@synthesize m_arrTitles;
@synthesize m_arrCustomTexts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_arrTitles = [[NSMutableArray alloc] init];
    [m_arrTitles addObject:@"Standard"];

    SettingViewController *settingViewController = (SettingViewController*)self.navigationController.parentViewController;
    settingViewController.lblTitle.text = @"Release Type";
    [settingViewController.btnSave setHidden:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.contentWidth.constant = screenSize.width;
    self.contentHeight.constant = screenSize.height;
    
    m_arrCustomTexts = [DBManager getCustomTexts];
    for (CustomText *customText in m_arrCustomTexts)
    {
        [m_arrTitles addObject:customText.title];
    }
    
    
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        NSString *strTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomTextTitle"];
        [self.btnReleaseType setTitle:strTitle forState:UIControlStateNormal];
        self.txtCustomTextTitle.text = strTitle;
        
        for (CustomText *customTextInfo in m_arrCustomTexts)
        {
            if ([customTextInfo.title isEqualToString:strTitle])
            {
                self.txtCustomText.text = customTextInfo.content;
                break;
            }
        }
    }
    else{
        [self.btnReleaseType setTitle:@"Standard" forState:UIControlStateNormal];
        self.txtCustomTextTitle.text = @"Standard";
        
        NSString *strLegalPath = [[NSBundle mainBundle] pathForResource:@"LegalText" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:strLegalPath];
        self.txtCustomText.text = [[dic objectForKey:@"ModelLegalText"] objectForKey:@"english"];
    }
    
    
}


-(NSString*)getContentFromTitle:(NSString*)strTitle
{
    if ([strTitle isEqualToString:@"Standard"])
    {
        
        NSString *strLegalPath = [[NSBundle mainBundle] pathForResource:@"LegalText" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:strLegalPath];
        NSString *strLegalText = [[dic objectForKey:@"ModelLegalText"] objectForKey:@"english"];
        return strLegalText;
    }
    
    for (CustomText *customText in m_arrCustomTexts)
    {
        NSString *strContent = customText.content;
        if ([strTitle isEqualToString:customText.title])
        {
            return strContent;
        }
    }
    
    return nil;
}

#pragma mark - set title
-(void)setNavTitle:(NSString*)title
{
    SettingViewController *settingsViewController = (SettingViewController*)[self.navigationController parentViewController];
    settingsViewController.lblTitle.text = title;
}

#pragma mark - when keyboard appear...


-(void)keyboardWillShow:(NSNotification *)notification {
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f",height);
    
    self.bottomMargin.constant = height+1;
    
}

-(void)keyboardWillHide:(NSNotification *)notification {
    self.bottomMargin.constant = 0;
}


#pragma mark - touch event

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.txtCustomText resignFirstResponder];
}


- (IBAction)onAdd:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    self.txtCustomTextTitle.text = @"";
    [self.txtCustomTextTitle setEnabled:YES];
    
    self.txtCustomText.text = @"";
    [self.txtCustomText setEditable:YES];
}

- (IBAction)onTitle:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Title" rows:m_arrTitles initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        [self.btnReleaseType setTitle:m_arrTitles[selectedIndex] forState:UIControlStateNormal];
        self.txtCustomTextTitle.text = m_arrTitles[selectedIndex];
        self.txtCustomText.text = [self getContentFromTitle:m_arrTitles[selectedIndex]];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.btnReleaseType];
    
}

- (IBAction)onDelete:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    if (![self.btnReleaseType.titleLabel.text isEqualToString:@"Standard"])
    {
        [DBManager removeCustomTextWithTitle:self.txtCustomTextTitle.text];
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"CustomRelease"];
        
        [self viewWillAppear:YES];
    }
    else
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"error" message:@"You cannot delete standard legal text." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"You cannot delete standard legal text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

-(void)onSave
{
    
    SettingsMainTableViewController *mainController = (SettingsMainTableViewController*)self.navigationController.childViewControllers[0];
    if ([self.txtCustomTextTitle.text isEqualToString:@"Standard"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"CustomRelease"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CustomTextTitle"];
        mainController.lblReleaseType.text = @"Standard";
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"CustomRelease"];
        [[NSUserDefaults standardUserDefaults] setValue:self.txtCustomTextTitle.text forKey:@"CustomTextTitle"];
        
        if(![DBManager addCustomTextWithTitle:self.txtCustomTextTitle.text withContent:self.txtCustomText.text])
        {
            NSLog(@"Save Error");
        }
        
        mainController.lblReleaseType.text = @"Custom Release";

    }
    
    [self setNavTitle:@"Settings"];
    g_settingIndex -= 1;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
