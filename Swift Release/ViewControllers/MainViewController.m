//
//  MainViewController.m
//  Release
//
//  Created by beauty on 10/27/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "NewReleaseViewController.h"
#import "Model.h"
#import "Property.h"
#import "Merge.h"
#import "AppDelegate.h"
#import "ActionSheetStringPicker.h"

#import "DBManager.h"

#import "AudioPlayer.h"

#define SEARCH_TAG 100

@interface MainViewController ()
{
    BOOL isHiddenSearchBar;
    
    NSInteger selectedRow;
    NSArray *listOfPaths;
    DataModel *m_mergeModel;
}
@end

@implementation MainViewController

@synthesize arrDataModels;
@synthesize arrFilterModels;
@synthesize selectedDataModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHiddenSearchBar = YES;
    self.constraintSearchHeight.constant = 0.0f;
    
    [_dialog setHidden:YES];
  
    [self loadData];
    
    self.txtSearch.tag = SEARCH_TAG;
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
//    UISwipeGestureRecognizer *swipRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwip:)];
//    [self.tableView addGestureRecognizer:swipRecognizer];
    
    m_actionStyle = NoneStyle;
    selectedRow = arrFilterModels.count+1;
    
    g_mergeRelease = [[DataModel alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [_dialog setHidden:YES];
    
    [self loadData];
    [self.tableView reloadData];
}

-(void)loadData
{
    
    arrDataModels = [[NSMutableArray alloc] init];
    arrFilterModels = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // get model data
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", strName];
    //[fetchRequest setPredicate:pred];
    
    NSError *error;
    NSArray *arrModels = [context executeFetchRequest:fetchRequest error:&error];

    for (NSInteger i = 0; i < arrModels.count; i++)
    {
        Model *model = arrModels[i];
        DataModel *dataModel = [[DataModel alloc] initWithModel:model];
        [arrDataModels addObject:dataModel];
    }
    
    // get property data
    NSEntityDescription *entityProperty = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:entityProperty];
    NSArray *arrProperties = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSInteger i = 0; i < arrProperties.count; i++)
    {
        Property *property = arrProperties[i];
        DataModel *dataModel = [[DataModel alloc] initWithProperty:property];
        [arrDataModels addObject:dataModel];
    }
    
    // get property data
    NSEntityDescription *entityMerges = [NSEntityDescription entityForName:@"Merge" inManagedObjectContext:context];
    [fetchRequest setEntity:entityMerges];
    NSArray *arrMerges = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSInteger i = 0; i < arrMerges.count; i++)
    {
        Merge *merge = arrMerges[i];
        DataModel *dataModel = [[DataModel alloc] initWithMerge:merge];
        [arrDataModels addObject:dataModel];
    }
    
    arrFilterModels = [arrDataModels mutableCopy];
    
}


#pragma mark - tableview datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat height = screenSize.height * 130.0f / 1334.0f;
   
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFilterModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSInteger row = [indexPath row];
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
        
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float imgWidth = (screenSize.width - 33.0f) * 100/750.0f;
    cell.imgPhoto.layer.cornerRadius = imgWidth / 2.0f;
    cell.imgPhoto.clipsToBounds = YES;
    
    DataModel *dataModel = arrFilterModels[row];
    
    cell.imgPhoto.image = [UIImage imageWithData:dataModel.imgPhoto];
    
    switch (dataModel.releaseType)
    {
        case ModelType:
            cell.imgType.image = [UIImage imageNamed:@"model_release_blue"];
            break;
        case PropertyType:
            cell.imgType.image = [UIImage imageNamed:@"property_release_blue"];
            break;
        case MergeType:
            cell.imgType.image = [UIImage imageNamed:@"merged_release_blue"];
            cell.imgPhoto.image = [UIImage imageNamed:@"merged_release_image"];
            break;
        default:
            break;
    }
    
    cell.lblTitle.text = dataModel.strTitle;
    cell.lblDetail.text = dataModel.strDescription;
    
    cell.lblDate.text = dataModel.strDate;
    cell.strFileName = dataModel.strFileName;
    
    [cell.btnMerge setTag:row];
    [cell.btnMerge addTarget:self action:@selector(onMerge:) forControlEvents:UIControlEventTouchUpInside];

    if (cell.widthContraint.constant != 0.0f)
    {
        [UIView animateWithDuration:0.2f animations:^{
            cell.widthContraint.constant = 0.0f;
            cell.trailingConstraint.constant = 0.0f;
            [self.view layoutIfNeeded];
        }];
    }
    
    if (m_actionStyle == MergeStyle && row != selectedRow)
    {
        [UIView animateWithDuration:0.3f animations:^{
            cell.widthContraint.constant = 80.0f;
            cell.trailingConstraint.constant = -80.0f;
            [self.view layoutIfNeeded];
        }];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AudioPlayer playButtonEffectSound];
    
    if (m_actionStyle == MergeStyle) {
        m_actionStyle = NoneStyle;
        [tableView reloadData];
        return;
    }
    NSInteger row = [indexPath row];
    DataModel *dataModel = arrFilterModels[row];
    NSString *strFileName = dataModel.strFileName;
    switch (dataModel.releaseType)
    {
        case ModelType:
            g_releaseType = ModelType;
            g_modelRelease = [DBManager getModel:(DataModel*)dataModel];
            break;
        case PropertyType:
            g_releaseType = PropertyType;
            g_propertyRelease = [DBManager getProperty:(DataModel*)dataModel];
            break;
        case MergeType:
            g_releaseType = MergeType;
            g_mergeRelease = dataModel;
            break;
        default:
            break;
    }
    [self showPDF:strFileName];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_actionStyle == MergeStyle)
    {
        return NO;
    }
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            //insert your deleteAction here
        
        NSInteger row = [indexPath row];
                    
        DataModel *dataModel = arrFilterModels[row];
                    
        if ([DBManager removeData:dataModel.strFileName])
        {
            [AudioPlayer playDeleteEffectSound];
            
            [arrDataModels removeObject:dataModel];
            [arrFilterModels removeObject:dataModel];
                        
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        
        }
                    
    }];
    deleteAction.backgroundColor = [UIColor redColor];
                
    m_actionStyle = NoneStyle;
    
    return @[deleteAction];
  
}



- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - buttons events

- (IBAction)onDate:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    NSArray *arrStrings = @[@"Date", @"Name", @"Type"];
    [ActionSheetStringPicker showPickerWithTitle:@"Sort By" rows:arrStrings initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         [self.btnDate setTitle:arrStrings[selectedIndex] forState:UIControlStateNormal];
         
         switch (selectedIndex)
         {
             case 0:
                 [self sortByDate];
                 break;
             case 1:
                 [self sortByName];
                 break;
             case 2:
                 [self sortByType];
                 break;
             default:
                 break;
         }
         
     } cancelBlock:^(ActionSheetStringPicker *picker) {
         
     } origin:self.btnDate];
}



- (IBAction)onSearch:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [self.view layoutIfNeeded];
    
    if (isHiddenSearchBar)
    {
        isHiddenSearchBar = NO;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.constraintSearchHeight.constant = 60.0f;
            [self.view layoutIfNeeded];
        }];
        return;
    }
    else
    {
        isHiddenSearchBar = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.constraintSearchHeight.constant = 0.0f;
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (IBAction)onHelp:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.btnHelpView setHidden:NO];
}

- (IBAction)onHelpScreen:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [self.btnHelpView setHidden:YES];
}

- (IBAction)onNew:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    [_dialog setHidden:NO];
}

- (IBAction)onNewModel:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    g_releaseType = ModelType;
    g_isNew = YES;
    NewReleaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NewReleaseViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onNewProperty:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    g_releaseType = PropertyType;
    g_isNew = YES;
    NewReleaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NewReleaseViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onScreenTouch:(id)sender
{
    [self.dialog setHidden:YES];
}

- (IBAction)onClose:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    self.txtSearch.text = @"";
    [self.txtSearch resignFirstResponder];
    [self showSearchDatas:@""];
    
    
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == SEARCH_TAG)
    {
        [self showSearchDatas:textField.text ];
    }
    [textField resignFirstResponder];
    return NO;
}

// show search datas....
-(void)showSearchDatas:(NSString*)str
{
    arrFilterModels = [[NSMutableArray alloc] init];
    
    str = [str lowercaseString];
    
    for (DataModel* dataModel in arrDataModels)
    {
        if ([[dataModel.strTitle lowercaseString] containsString:str])
        {
            [arrFilterModels addObject:dataModel];
        }
    }
    
    if ([str isEqualToString:@""])
    {
        arrFilterModels = [arrDataModels mutableCopy];
    }
    
    NSString *strSortKey = self.btnDate.titleLabel.text;
    if ([strSortKey isEqualToString:@"Date"])
    {
        [self sortByDate];
    }
    else if ([strSortKey isEqualToString:@"Name"])
        [self sortByName];
    else if ([strSortKey isEqualToString:@"Type"])
        [self sortByType];
    
    //[self.tableView reloadData];
    
}

#pragma mark - sort by date, name, type
-(void)sortByDate
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"strDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrFilterModels = [[arrFilterModels sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

    [self.tableView reloadData];

}

-(void)sortByName
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"strTitle" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrFilterModels = [[arrFilterModels sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)sortByType
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseType" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrFilterModels = [[arrFilterModels sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self.tableView reloadData];

}


#pragma mark - long press gesture 

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        
        m_actionStyle = MergeStyle;
        
        CGPoint touchPoint = [pGesture locationInView:self.tableView];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        NSInteger row = [indexPath row];
        
        selectedRow = row;
        
        selectedDataModel = arrFilterModels[row];
        
        [self.tableView reloadData];

    }
    
}

-(void)onMerge:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    m_actionStyle = NoneStyle;
    selectedRow = arrFilterModels.count + 1;
    UIButton *btnMerge = (UIButton*)sender;
    NSInteger row = btnMerge.tag;
    
    DataModel *secondDataModel = arrFilterModels[row];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *firstPath = [documentDirectory stringByAppendingPathComponent:selectedDataModel.strFileName];
    NSString *secondPath = [documentDirectory stringByAppendingPathComponent:secondDataModel.strFileName];
    
    NSArray *strSeparateArray = [[NSArray alloc] init];
    strSeparateArray = [selectedDataModel.strFileName componentsSeparatedByString:@".pdf"];
    NSString *strFirstFileTitle = [strSeparateArray objectAtIndex:0];
    strSeparateArray = [secondDataModel.strFileName componentsSeparatedByString:@".pdf"];
    NSString *strSecondFileTitle = [strSeparateArray objectAtIndex:0];
    
    NSString *strMergeTitle = [NSString stringWithFormat:@"%@,%@", strFirstFileTitle, strSecondFileTitle];
    listOfPaths = @[firstPath, secondPath];

    m_mergeModel = [[DataModel alloc] init];
    m_mergeModel.releaseType = MergeType;
    m_mergeModel.strFileName = [NSString stringWithFormat:@"%@.pdf", strMergeTitle];
    m_mergeModel.strTitle = [NSString stringWithFormat:@"%@, %@", selectedDataModel.strTitle, secondDataModel.strTitle];
    m_mergeModel.strDescription = [NSString stringWithFormat:@"%@, %@", selectedDataModel.strDescription, secondDataModel.strDescription];
    m_mergeModel.imgPhoto = selectedDataModel.imgPhoto;

    
    NSString *strMessage = [NSString stringWithFormat:@"Are you sure you want merge %@ into %@?", secondDataModel.strTitle, selectedDataModel.strTitle];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self mergePDF:listOfPaths withMergeModel:m_mergeModel];
            listOfPaths = @[];
            [self loadData];
            [self.tableView reloadData];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            listOfPaths = @[];
            [self.tableView reloadData];
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil, nil];
        [alert show];
    }
    
}

- (void)mergePDF:(NSArray *)listOfFilePaths withMergeModel:(DataModel *)mergeModel
{
    
    NSString *fileName = mergeModel.strFileName; // [NSString stringWithFormat:@"%@.pdf", fileName];
    
    NSString *pdfPathOutput = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    CFURLRef pdfURLOutput = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:pdfPathOutput]);
    
    NSInteger numberOfPages = 0;
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    for (NSString *source in listOfFilePaths) {
        CFURLRef pdfURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:source]);
        
        //file ref
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL);
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        // Read the first PDF and generate the output pages
        NSLog(@"GENERATING PAGES FROM PDF 1 (%@)...", source);
        for (int i=1; i<=numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfRef, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        CGPDFDocumentRelease(pdfRef);
        CFRelease(pdfURL);
    }
    CFRelease(pdfURLOutput);
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    CGContextRelease(writeContext);

    [DBManager saveMergeData:m_mergeModel];
//    [DBManager updateFileName:selectedDataModel.strFileName newFileName:fileName];
    selectedDataModel.strFileName = fileName;
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)d clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // cancel button
            break;
        case 1:
            [self mergePDF:listOfPaths withMergeModel:m_mergeModel];
            [self loadData];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    listOfPaths = @[];
    [self.tableView reloadData];
}

#pragma mark - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    [AudioPlayer playButtonEffectSound];
}


@end
