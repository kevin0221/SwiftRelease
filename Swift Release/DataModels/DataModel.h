//
//  DataModels.h
//  Swift Release
//
//  Created by beauty on 12/1/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRelease.h"
#import "Model.h"
#import "Property.h"
#import "Merge.h"

@interface DataModel : NSObject

@property ReleaseType releaseType;
@property (nonatomic, strong) NSData *imgPhoto;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strDescription;
@property (nonatomic, strong) NSString *strDate;
@property (nonatomic, strong) NSString *strFileName;

-(instancetype)init;
-(instancetype)initWithModel:(Model*)model;
-(instancetype)initWithProperty:(Property*)property;
-(instancetype)initWithMerge:(Merge *)merge;

@end
