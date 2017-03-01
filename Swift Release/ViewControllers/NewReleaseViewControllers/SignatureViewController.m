//
//  SignatureViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "SignatureViewController.h"

#import "AudioPlayer.h"

@interface SignatureViewController ()
{
    CGSize _pageSize;
}
@end

@implementation SignatureViewController

@synthesize signImage;
@synthesize lastContactPoint1, lastContactPoint2, currentPoint;
@synthesize imageFrame;
@synthesize fingerMoved;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.strSignerName = @"";
    self.strTitle = @"";
    switch (g_releaseType) {
        case NONE:
            self.lblTitle.text = @"Photographer Signature";
            self.lblSignerName.text = self.strSignerName;
            break;
        
        case PropertyType:
            switch (g_propertyRelease.property_ownershipType)
            {
                case IndividualOwner:
                    self.lblTitle.text = @"Individual Owner Signatures";
                    self.lblSignerName.text = g_propertyRelease.strProperty_Name;
                    break;
                case CorporateOwner:
                    self.lblTitle.text = @"Corporate Owner Signatures";
                    self.lblSignerName.text = g_propertyRelease.strProperty_corporationName;
                    break;
                case AuthorizedRepresentative:
                    self.lblTitle.text = @"Authorized Representative Signature";
                    self.lblSignerName.text = g_propertyRelease.strProperty_authorizedTitle;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    
    // set current date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    
    NSString *strSelectedDate = [formatter stringFromDate:[NSDate date]];
    self.lblCurrentDate.text = strSelectedDate;
    
    self.imgSignData = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    imageFrame = [signImage bounds];
    
    [signImage.layer setBorderWidth:5];
    signImage.layer.cornerRadius = 10.0f;
    signImage.layer.borderColor = [UIColor grayColor].CGColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.strSignerName isEqual:@""]) {
        self.lblSignerName.text = self.strSignerName;
    }
    
    if (![self.strTitle isEqual:@""])
    {
        self.lblTitle.text = self.strTitle;
    }
    
}

#pragma mark - touch event
//when one or more fingers touch down in a view or window
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //did our finger moved yet?
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    //we need 3 points of contact to make our signature smooth using quadratic bezier curve
    currentPoint = [touch locationInView:signImage];
    lastContactPoint1 = [touch previousLocationInView:signImage];
    lastContactPoint2 = [touch previousLocationInView:signImage];
    
}


//when one or more fingers associated with an event move within a view or window
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //well its obvious that our finger moved on the screen
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    //save previous contact locations
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:signImage];
    //save current location
    currentPoint = [touch locationInView:signImage];
    
    //find mid points to be used for quadratic bezier curve
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    //create a bitmap-based graphics context and makes it the current context
    UIGraphicsBeginImageContext(imageFrame.size);
    
    //draw the entire image in the specified rectangle frame
    [signImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //begin a new new subpath at this point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    //create quadratic Bézier curve from the current point using a control point and an end point
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    //set the miter limit for the joins of connected lines in a graphics context
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //set the image based on the contents of the current bitmap-based graphics context
    signImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
    //lastContactPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //if the finger never moved draw a point
    if(!fingerMoved) {
        UIGraphicsBeginImageContext(imageFrame.size);
        [signImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        signImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

//calculate midpoint between two points
- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

#pragma mark - button events

- (IBAction)onBack:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    self.view.tag = 0;
    [self.delegate didSignCancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSign:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    self.imgSignData = UIImagePNGRepresentation(signImage.image);
    
    self.view.tag = 0;
   
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM/dd/YYYY"];
    NSString *strCurrentDate = [formatter1 stringFromDate:[NSDate date]];
    
    [self.delegate didSign:self.imgSignData date:strCurrentDate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
}

- (IBAction)onClear:(id)sender
{
    [AudioPlayer playDeleteEffectSound];
    
    signImage.image = nil;
}



@end
