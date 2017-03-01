//
//  DataModels.m
//  Swift Release
//
//  Created by beauty on 12/1/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "DataModel.h"
#import "AppDelegate.h"
#import "Photoshoot.h"

@implementation DataModel

-(instancetype)init
{
    self = [super init];
    
    self.releaseType = NONE;
    self.imgPhoto = [[NSData alloc] init];
    self.strTitle = @"";
    self.strDescription = @"";
    self.strDate = @"";
    self.strFileName = @"";
    
    return self;
}


-(instancetype)initWithModel:(Model *)model
{
    self = [super init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(id = %@)", model.photoshoot_id];
    [fetchRequest setPredicate:pred];
    
    NSError *error;
    NSArray *arrPhotoshoot = [context executeFetchRequest:fetchRequest error:&error];
   
    Photoshoot *photoshoot = nil;
    if (arrPhotoshoot.count > 0) {
        photoshoot = arrPhotoshoot[0];
    }
    
    
    self.releaseType = ModelType;
    self.imgPhoto = model.model_imgPhoto;
    self.strTitle = model.model_name;
    
    self.strDescription = photoshoot == nil ? @"" : photoshoot.shootTitle;
    
    self.strDate = photoshoot == nil ? @"" : photoshoot.date;
    self.strFileName = model.fileName;   
    
    
    return self;
}

-(instancetype)initWithProperty:(Property *)property
{
    self = [super init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(id = %@)", property.photoshoot_id];
    [fetchRequest setPredicate:pred];
    
    NSError *error;
    NSArray *arrPhotoshoot = [context executeFetchRequest:fetchRequest error:&error];
    
    Photoshoot *photoshoot = nil;
    if (arrPhotoshoot.count > 0) {
        photoshoot = arrPhotoshoot[0];
    }
    
    
    self.releaseType = PropertyType;
    self.imgPhoto = property.property_imgPhoto;
    self.strTitle = property.property_description;
    
    self.strDescription = photoshoot == nil ? @"" : photoshoot.shootTitle;
    
    self.strDate = property.property_signDate;
    self.strFileName = property.fileName;
    
    
    return self;
}

-(instancetype)initWithMerge:(Merge *)merge
{
    self = [super init];
    
    self.releaseType = MergeType;
    self.strTitle = merge.title;
    self.strDescription = merge.descriptions;
    self.strDate = merge.strDate;
    self.imgPhoto = merge.imgPhoto;
    self.strFileName = merge.fileName;
    
    return self;
}

@end
