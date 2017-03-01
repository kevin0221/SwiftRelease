//
//  PopupViewController.h
//  Swift Release
//
//  Created by beauty on 12/11/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import "ReaderDocument.h"


@protocol PopupDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInEmailButton:(UIButton *)button withEmail:(NSString *)email;
- (void)tappedInPrintButton:(UIButton *)button;
- (void)tappedInGalleryButton:(UIButton *)button;

@end


@interface PopupViewController : UIViewController 
{
@private
    ReaderDocument *document;
}

@property (nonatomic, unsafe_unretained, readwrite) id <PopupDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnPhotographer;
@property (weak, nonatomic) IBOutlet UIButton *btnModel;
@property (weak, nonatomic) IBOutlet UIButton *btnGallery;
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;

- (void) setDocument:(ReaderDocument *)object;

- (IBAction)onSendEmailToPhotographer:(id)sender;
- (IBAction)onSendEmailToModel:(id)sender;
- (IBAction)onSaveToGallery:(id)sender;
- (IBAction)onPrintRelease:(id)sender;

- (IBAction)onCancel:(id)sender;



@end
