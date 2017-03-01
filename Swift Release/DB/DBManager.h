//
//  DBManager.h
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "ModelRelease.h"
#import "PropertyRelease.h"
#import "Model.h"
#import "Property.h"
#import "Photoshoot.h"
#import "Witness.h"
#import "DataModel.h"
#import "CustomText.h"

@interface DBManager : NSObject


+(BOOL)saveModelData:(ModelRelease*)modelRelease;
+(BOOL)savePropertyData:(PropertyRelease*)propertyRelease;
+(BOOL)saveMergeData:(DataModel*)mergeModel;

+(NSNumber*)savePhotoShootInfo:(DataRelease*)dataRelease;
+(NSNumber*)saveWitnessInfo:(DataRelease*)dataRelease;


+(NSArray*)getPhotoShoots;
+(NSArray*)getModels;
+(NSArray*)getProperties;
+(NSArray*)getWitnesses;

+(BOOL)removeData:(NSString*)filename;
+(BOOL)removePhotoshoot:(NSNumber*)id;
+(BOOL)removeWitness:(NSNumber*)id;

+(void)updateFileName:oldFileName newFileName:(NSString*)fileName;

+(ModelRelease*) getModel:(DataModel*)dataModel;
+(PropertyRelease*)getProperty:(DataModel*)dataModel;

+(Photoshoot*)getPhotoshoot:(NSNumber*)id;
+(Witness*)getWitness:(NSNumber*)id;

+(BOOL)addCustomTextWithTitle:(NSString*)strTitle withContent:(NSString*)strContent;
+(BOOL)removeCustomTextWithTitle:(NSString*)strTitle;
+(NSString*)getCustomTextContentWithTitle:(NSString*)strTitle;
+(NSArray*)getCustomTexts;

@end
