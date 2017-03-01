//
//  DBManager.m
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"


@implementation DBManager

+(BOOL)saveModelData:(ModelRelease *)modelRelease
{
    NSInteger photoshootInfoID = [[self savePhotoShootInfo:modelRelease] intValue];
    if (photoshootInfoID == -1)
    {
        NSLog(@"Photoshoot info cannot save.");
        return NO;
    }
    
    NSInteger witnessID = [[self saveWitnessInfo:modelRelease] intValue];
    if (witnessID == -1)
    {
        NSLog(@"Witness Info cannot insert to the table");
        return NO;
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    // check exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model_name == %@ and model_signDate == %@ and photoshoot_id == %@", modelRelease.strModel_name, modelRelease.strModel_signDate, [NSNumber numberWithInteger:photoshootInfoID]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model_name == %@ and photoshoot_id == %@", modelRelease.strModel_name, [NSNumber numberWithInteger:photoshootInfoID]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrModel = [context executeFetchRequest:fetchRequest error:&error];
    if (arrModel.count > 0)
    {
        
        Model *modelInfo = arrModel[0];
       
        modelInfo.model_parent = modelRelease.strModel_parentName;
        modelInfo.model_birth = modelRelease.strModel_birth;
        if ([modelRelease.strModel_gender isEqualToString:@"Male"])
        {
            modelInfo.model_gender = [NSNumber numberWithBool:YES];
        }
        else if ([modelRelease.strModel_gender isEqualToString:@"Female"])
        {
            modelInfo.model_gender = [NSNumber numberWithBool:NO];
        }
        modelInfo.model_ethnicity = modelRelease.strModel_ethnicity;
        modelInfo.model_streetAdress = modelRelease.strModel_streetAddress;
        modelInfo.model_city = modelRelease.strModel_city;
        modelInfo.model_state = modelRelease.strModel_state;
        modelInfo.model_country = modelRelease.strModel_country;
        modelInfo.model_zipCode = modelRelease.strModel_zipCode;
        modelInfo.model_email = modelRelease.strModel_email;
        modelInfo.model_phone = modelRelease.strModel_phone;
            
        modelInfo.model_imgPhoto = modelRelease.dataModel_photo;
        modelInfo.model_imgSignature = modelRelease.imgModel_signatureData;
        modelInfo.model_signDate = modelRelease.strModel_signDate;
        
        modelInfo.fileName = modelRelease.strFileName;
            
        modelInfo.photoshoot_id = [NSNumber numberWithInteger:photoshootInfoID];
        modelInfo.witness_id = [NSNumber numberWithInteger:witnessID];
            
            
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }
            
        return YES;
        
        
        
        
    }
    
        // get
    NSFetchRequest *fetchRequestAll = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAll = [NSEntityDescription entityForName:@"Model"
                                                     inManagedObjectContext:context];
    [fetchRequestAll setEntity:entityAll];
        
    NSArray *arrModels = [context executeFetchRequest:fetchRequestAll error:&error];
    NSInteger modelID = 0;
    for (Model *model in arrModels)
    {
        if ([model.id integerValue] >= modelID)
        {
            modelID = [model.id integerValue] + 1;
        }
    }
    
    // model information.
    Model *modelInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
        
    modelInfo.id = [NSNumber numberWithInteger:modelID];
    modelInfo.model_name = modelRelease.strModel_name;
    modelInfo.model_parent = modelRelease.strModel_parentName;
    modelInfo.model_birth = modelRelease.strModel_birth;
    if ([modelRelease.strModel_gender isEqualToString:@"Male"])
    {
        modelInfo.model_gender = [NSNumber numberWithBool:YES];
    }
    else if ([modelRelease.strModel_gender isEqualToString:@"Female"])
    {
        modelInfo.model_gender = [NSNumber numberWithBool:NO];
    }
    modelInfo.model_ethnicity = modelRelease.strModel_ethnicity;
    modelInfo.model_streetAdress = modelRelease.strModel_streetAddress;
    modelInfo.model_city = modelRelease.strModel_city;
    modelInfo.model_state = modelRelease.strModel_state;
    modelInfo.model_country = modelRelease.strModel_country;
    modelInfo.model_zipCode = modelRelease.strModel_zipCode;
    modelInfo.model_email = modelRelease.strModel_email;
    modelInfo.model_phone = modelRelease.strModel_phone;
        
    modelInfo.model_imgPhoto = modelRelease.dataModel_photo;
    modelInfo.model_imgSignature = modelRelease.imgModel_signatureData;
    modelInfo.model_signDate = modelRelease.strModel_signDate;
        
    modelInfo.fileName = modelRelease.strFileName;
        
    modelInfo.photoshoot_id = [NSNumber numberWithInteger:photoshootInfoID];
    modelInfo.witness_id = [NSNumber numberWithInteger:witnessID];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }

    return YES;
}


+(BOOL)savePropertyData:(PropertyRelease *)propertyRelease
{
    NSInteger photoshootInfoID = [[self savePhotoShootInfo:propertyRelease] integerValue];
    if (photoshootInfoID == -1)
    {
        NSLog(@"Error");
        return NO;
    }
    
    NSInteger witnessID = [[self saveWitnessInfo:propertyRelease] integerValue];
    if (witnessID == -1)
    {
        NSLog(@"Witness Info cannot insert to the table");
        return NO;
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // if exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"property_description == %@ and property_signDate == %@ and photoshoot_id == %@", propertyRelease.strProperty_description, propertyRelease.strProperty_signDate, [NSNumber numberWithInteger:photoshootInfoID]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrProperty = [context executeFetchRequest:fetchRequest error:&error];
    
    if (arrProperty.count > 0) {
        
        Property *property = arrProperty[0];
        
        property.property_imgPhoto = propertyRelease.dataProperty_photo;
        //property.property_description = propertyRelease.strProperty_description;
        property.property_streetAddress = propertyRelease.strProperty_address;
        property.property_city = propertyRelease.strProperty_city;
        property.property_state = propertyRelease.strProperty_state;
        property.property_country = propertyRelease.strProperty_country;
        property.property_zipCode = propertyRelease.strProperty_zipCode;
        
        property.property_ownerType = [NSNumber numberWithInteger:propertyRelease.property_ownershipType];
        property.property_individualOwnerName = propertyRelease.strProperty_Name;
        property.property_coporationName = propertyRelease.strProperty_corporationName;
        property.property_authorizedTitle = propertyRelease.strProperty_authorizedTitle;
        property.property_tel = propertyRelease.strProperty_phone;
        property.property_email = propertyRelease.strProperty_email;
        
        property.property_imgSignature = propertyRelease.imgProperty_signature;
        //property.property_signDate = propertyRelease.strProperty_signDate;
        
        property.fileName = propertyRelease.strFileName;
        
        
        //property.photoshoot_id = [NSNumber numberWithInteger:photoshootInfoID];
        property.witness_id = [NSNumber numberWithInteger:witnessID];
        
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }
        
        return YES;
        
        
    }
    
    /**************** add new ****************************/
    
    // get
    NSFetchRequest *fetchRequestAll = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAll = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequestAll setEntity:entityAll];
    
    
    NSArray *arrProperties = [context executeFetchRequest:fetchRequestAll error:&error];
    
    NSInteger propertyID = 0;
    for (Property *property in arrProperties)
    {
        if ([property.id integerValue] >= propertyID)
        {
            propertyID = [property.id integerValue] + 1;
        }
    }
    // model information.
    Property *propertyInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
    
    propertyInfo.id = [NSNumber numberWithInteger:propertyID];
    propertyInfo.property_imgPhoto = propertyRelease.dataProperty_photo;
    propertyInfo.property_description = propertyRelease.strProperty_description;
    propertyInfo.property_streetAddress = propertyRelease.strProperty_address;
    propertyInfo.property_city = propertyRelease.strProperty_city;
    propertyInfo.property_state = propertyRelease.strProperty_state;
    propertyInfo.property_country = propertyRelease.strProperty_country;
    propertyInfo.property_zipCode = propertyRelease.strProperty_zipCode;
    
    propertyInfo.property_ownerType = [NSNumber numberWithInteger:propertyRelease.property_ownershipType];
    propertyInfo.property_individualOwnerName = propertyRelease.strProperty_Name;
    propertyInfo.property_coporationName = propertyRelease.strProperty_corporationName;
    propertyInfo.property_authorizedTitle = propertyRelease.strProperty_authorizedTitle;
    propertyInfo.property_tel = propertyRelease.strProperty_phone;
    propertyInfo.property_email = propertyRelease.strProperty_email;
    
    propertyInfo.property_imgSignature = propertyRelease.imgProperty_signature;
    propertyInfo.property_signDate = propertyRelease.strProperty_signDate;
    
    propertyInfo.fileName = propertyRelease.strFileName;
    
    
    propertyInfo.photoshoot_id = [NSNumber numberWithInteger:photoshootInfoID];
    propertyInfo.witness_id = [NSNumber numberWithInteger:witnessID];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+(BOOL)saveMergeData:(DataModel *)mergeModel
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *strCurrentDate = [formatter stringFromDate:[NSDate date]];
    mergeModel.strDate = strCurrentDate;
    
    // get merges...
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Merge" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@ and descriptions == %@", mergeModel.strTitle, mergeModel.strDescription];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMerges = [context executeFetchRequest:fetchRequest error:&error];
    
    if (arrMerges.count > 0)
    {
    /************** update ***************************/
        Merge *merge = arrMerges[0];
        
        merge.imgPhoto = mergeModel.imgPhoto;
        merge.strDate = mergeModel.strDate;
        merge.fileName = mergeModel.strFileName;
        
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }
        
        return YES;
        
    }
    
    /**************** add new ****************************/
    
    // get
    NSFetchRequest *fetchRequestAll = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAll = [NSEntityDescription entityForName:@"Merge" inManagedObjectContext:context];
    [fetchRequestAll setEntity:entityAll];
    
    NSArray *arrAllMerges = [context executeFetchRequest:fetchRequestAll error:&error];
    
    NSInteger mergeID = 0;
    for (Merge *merge in arrAllMerges)
    {
        if ([merge.id integerValue] >= mergeID)
        {
            mergeID = [merge.id integerValue] + 1;
        }
    }
    // model information.
    Merge *mergeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Merge" inManagedObjectContext:context];
    
    mergeInfo.id = [NSNumber numberWithInteger:mergeID];
    mergeInfo.imgPhoto = mergeModel.imgPhoto;
    mergeInfo.title = mergeModel.strTitle;
    mergeInfo.descriptions = mergeModel.strDescription;
    mergeInfo.strDate = mergeModel.strDate;
    mergeInfo.fileName = mergeModel.strFileName;
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+(NSNumber*)savePhotoShootInfo:(DataRelease*)dataRelease
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // get photoshoots...
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrPhotoshoots = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSInteger i = 0; i < arrPhotoshoots.count; i++)
    {
        Photoshoot *photoshoot = arrPhotoshoots[i];
        if ([self isEqual:photoshoot withDataRelease:dataRelease])
        {
            photoshoot.counter = [NSNumber numberWithInteger:([photoshoot.counter intValue] + 1)];
            
            photoshoot.shootDescription = dataRelease.strPhotoshoot_description;
            photoshoot.date = dataRelease.strPhotoshoot_date;
            
            photoshoot.city = dataRelease.strPhotoshoot_city;
            photoshoot.state = dataRelease.strPhotoshoot_state;
            photoshoot.country = dataRelease.strPhotoshoot_country;
            
            photoshoot.imgSignature = dataRelease.imgPhotoshoot_signature;
            photoshoot.strSignDate = dataRelease.strPhotoshoot_signDate;
            
            photoshoot.photographer_email = dataRelease.strPhotoshoot_photographerEmail;
            photoshoot.company_name = dataRelease.strPhotoshoot_companyName;
            photoshoot.company_phone = dataRelease.strPhotoshoot_companyPhone;
            photoshoot.company_logo = dataRelease.imgPhotoshoot_companyLogo;
            
            
            if (![context save:&error])
            {
                NSLog(@"Photoshoot Info save error!");
                return [NSNumber numberWithInt:-1];
            }
            
            return photoshoot.id;
        }
        
    }
    
    NSInteger photographerID = 0;
    for (Photoshoot *photoshoot in arrPhotoshoots)
    {
        if([photoshoot.id integerValue] >= photographerID)
            photographerID = [photoshoot.id integerValue] + 1;
            
    }
    
    // set data
    Photoshoot *photoshootInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Photoshoot" inManagedObjectContext:context];
    
    photoshootInfo.id = [NSNumber numberWithInteger:photographerID];
   
    photoshootInfo.photographer = dataRelease.strPhotoshoot_photographer;
    photoshootInfo.shootTitle = dataRelease.strPhotoshoot_title;
    photoshootInfo.shootDescription = dataRelease.strPhotoshoot_description;
    photoshootInfo.date = dataRelease.strPhotoshoot_date;
    
    photoshootInfo.city = dataRelease.strPhotoshoot_city;
    photoshootInfo.state = dataRelease.strPhotoshoot_state;
    photoshootInfo.country = dataRelease.strPhotoshoot_country;
    
    photoshootInfo.imgSignature = dataRelease.imgPhotoshoot_signature;
    photoshootInfo.strSignDate = dataRelease.strPhotoshoot_signDate;
    
    photoshootInfo.photographer_email = dataRelease.strPhotoshoot_photographerEmail;
    photoshootInfo.company_name = dataRelease.strPhotoshoot_companyName;
    photoshootInfo.company_phone = dataRelease.strPhotoshoot_companyPhone;
    photoshootInfo.company_logo = dataRelease.imgPhotoshoot_companyLogo;
    
    photoshootInfo.counter = [NSNumber numberWithInt:1];
    
    if (![context save:&error])
    {
        NSLog(@"Photoshoot Info save error!");
        return [NSNumber numberWithInt:-1];
    }
    
    return [NSNumber numberWithInteger:photographerID];
    
}


+(BOOL)isEqual:(Photoshoot*)photoshoot withDataRelease:(DataRelease*)dataRelease
{
    if (![photoshoot.photographer isEqual:dataRelease.strPhotoshoot_photographer])
        return NO;
    if (![photoshoot.shootTitle isEqual:dataRelease.strPhotoshoot_title])
        return NO;
//    if (![photoshoot.shootDescription isEqual:dataRelease.strPhotoshoot_description])
//        return NO;
//    if (![photoshoot.date isEqual:dataRelease.strPhotoshoot_date])
//        return NO;
//    if (![photoshoot.city isEqual:dataRelease.strPhotoshoot_city])
//        return NO;
//    if (![photoshoot.state isEqual:dataRelease.strPhotoshoot_state])
//        return NO;
//    if (![photoshoot.country isEqual:dataRelease.strPhotoshoot_country])
//        return NO;
    
    return YES;
}

+(NSNumber*)saveWitnessInfo:(DataRelease *)dataRelease
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // get witnesses...
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Witness" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrWitness = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSInteger i = 0; i < arrWitness.count; i++)
    {
        Witness *witness = arrWitness[i];
        if ([witness.name isEqual:dataRelease.strWitness_name])
        {
            witness.counter = [NSNumber numberWithInteger:([witness.counter integerValue] + 1)];
            witness.signature = dataRelease.imgWitness_signature;
            witness.signDate = dataRelease.strWitness_signDate;
            
            if (![context save:&error])
            {
                NSLog(@"Error database");
                return [NSNumber numberWithInt:-1];
            }
            
            return witness.id;
        }
        
    }
    
    NSInteger witnessID = 0;
    for (Witness *witness in arrWitness)
    {
        if ([witness.id integerValue] >= witnessID)
        {
            witnessID = [witness.id integerValue] + 1;
        }
    }
    
    Witness *witnessInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Witness" inManagedObjectContext:context];

    // set data
    witnessInfo.id = [NSNumber numberWithInteger:witnessID];
    
    witnessInfo.name = dataRelease.strWitness_name;
    witnessInfo.signature = dataRelease.imgWitness_signature;
    witnessInfo.signDate = dataRelease.strWitness_signDate;
    witnessInfo.counter = [NSNumber numberWithInteger:1];
    
    if (![context save:&error])
    {
        NSLog(@"Error database");
        return [NSNumber numberWithInt:-1];
    }
    
    return [NSNumber numberWithInteger:witnessID];
}



#pragma mark -

+(NSArray*)getPhotoShoots
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrPhotoshoots = [context executeFetchRequest:fetchRequest error:&error];
    return arrPhotoshoots;
}

+(NSArray*)getModels
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrModels = [context executeFetchRequest:fetchRequest error:&error];
    return arrModels;
}

+(NSArray*)getProperties
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrProperties = [context executeFetchRequest:fetchRequest error:&error];
    return arrProperties;

}

+(NSArray*)getWitnesses
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Witness" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrWitnesses = [context executeFetchRequest:fetchRequest error:&error];
    return arrWitnesses;
}


+(BOOL)removeData:(NSString*)filename
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequestModel = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequestModel setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName == %@", filename];
    [fetchRequestModel setPredicate:predicate];
    
    NSError *error;
    NSArray *arrDataModels = [context executeFetchRequest:fetchRequestModel error:&error];
    
    if (!error && arrDataModels.count > 0)
    {
        for (Model *managedObject in arrDataModels)
        {
            if(![DBManager removePhotoshoot:managedObject.photoshoot_id])
                return NO;
            
            if (![DBManager removeWitness:managedObject.witness_id])
                return NO;
            
            
            [context deleteObject:managedObject];
        }
        [context save:nil];
    }
    
    
    NSFetchRequest *fetchRequestProperty = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProperty = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequestProperty setEntity:entityProperty];
    
    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"fileName == %@", filename];
    [fetchRequestProperty setPredicate:predicateProperty];
    
    NSArray *arrProperties = [context executeFetchRequest:fetchRequestProperty error:&error];
    
    if (!error && arrProperties.count > 0)
    {
        for (Property *managedObject in arrProperties)
        {
            [context deleteObject:managedObject];
        }
        [context save:nil];
    }
    
    NSFetchRequest *fetchRequestMerge = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityMerge = [NSEntityDescription entityForName:@"Merge" inManagedObjectContext:context];
    [fetchRequestMerge setEntity:entityMerge];
    
    NSPredicate *predicateMerge = [NSPredicate predicateWithFormat:@"fileName == %@", filename];
    [fetchRequestMerge setPredicate:predicateMerge];
    
    NSArray *arrMerges = [context executeFetchRequest:fetchRequestMerge error:&error];
    
    if (!error && arrMerges.count > 0)
    {
        for (Merge *managedObject in arrMerges)
        {
            [context deleteObject:managedObject];
        }
        [context save:nil];
    }
    
    // pdf file delete from device....
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] removeItemAtPath:pdfPath error:&error];
    
    return YES;
}

+(BOOL)removePhotoshoot:(NSNumber*)id
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequestModel = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequestModel setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", id];
    [fetchRequestModel setPredicate:predicate];
    
    NSError *error;
    NSArray *arrDataModels = [context executeFetchRequest:fetchRequestModel error:&error];
    
    if (!error && arrDataModels.count > 0)
    {
        for (Photoshoot *managedObject in arrDataModels)
        {
            int currentCounter = [managedObject.counter intValue];
            if(currentCounter  < 2)
            {
                [context deleteObject:managedObject];
            }
            else
            {
                
                managedObject.counter = [NSNumber numberWithInt:currentCounter - 1];
                if (![context save:&error])
                {
                    NSLog(@"Photoshoot Info save error!");
                    return NO;
                }
            }
            
        }
        [context save:nil];
    }
    
    return YES;
}

+(BOOL)removeWitness:(NSNumber*)id
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequestModel = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Witness" inManagedObjectContext:context];
    [fetchRequestModel setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", id];
    [fetchRequestModel setPredicate:predicate];
    
    NSError *error;
    NSArray *arrDataModels = [context executeFetchRequest:fetchRequestModel error:&error];
    
    if (!error && arrDataModels.count > 0)
    {
        for (Witness *managedObject in arrDataModels)
        {
            if(managedObject.counter.intValue  < 2)
            {
                [context deleteObject:managedObject];
            }
            else
            {
                NSInteger currentCounter = [managedObject.counter integerValue];
                managedObject.counter = [NSNumber numberWithInteger:currentCounter - 1];
                if (![context save:&error])
                {
                    NSLog(@"Witness Info save error!");
                    return NO;
                }
            }
            
        }
        [context save:nil];
    }
    
    return YES;
}

+(void)updateFileName:oldFileName newFileName:(NSString*)fileName
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequestModel = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequestModel setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName == %@", oldFileName];
    [fetchRequestModel setPredicate:predicate];
    
    NSError *error;
    NSArray *arrDataModels = [context executeFetchRequest:fetchRequestModel error:&error];
    
    if (!error && arrDataModels.count > 0)
    {
        for (Model *managedObject in arrDataModels)
        {
            managedObject.fileName = fileName;
            //[context deleteObject:managedObject];
        }
        [context save:nil];
    }
    
    
    NSFetchRequest *fetchRequestProperty = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProperty = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequestProperty setEntity:entityProperty];
    
    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"fileName == %@", oldFileName];
    [fetchRequestProperty setPredicate:predicateProperty];
    
    NSArray *arrProperties = [context executeFetchRequest:fetchRequestProperty error:&error];
    
    if (!error && arrProperties.count > 0)
    {
        for (Property *managedObject in arrProperties)
        {
            managedObject.fileName = fileName;
            //[context deleteObject:managedObject];
        }
        [context save:nil];
    }
}


+(ModelRelease*) getModel:(DataModel*)dataModel
{
    ModelRelease *modelRelease = [[ModelRelease alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"fileName == %@", dataModel.strFileName];
    [fetchRequest setPredicate:predicateProperty];
    
    NSError *error;
    NSArray *arrModels = [context executeFetchRequest:fetchRequest error:&error];
    if (arrModels.count > 0)
    {
        Model *model = arrModels[0];
        
        modelRelease.dataModel_photo = model.model_imgPhoto;
        modelRelease.strModel_name = model.model_name;
        modelRelease.strModel_birth = model.model_birth;
        if (model.model_gender == [NSNumber numberWithBool:YES])
        {
            modelRelease.strModel_gender = @"Male";
        }
        else
        {
            modelRelease.strModel_gender = @"Female";
        }
        modelRelease.strModel_ethnicity = model.model_ethnicity;
        modelRelease.strModel_parentName = model.model_parent;
        modelRelease.strModel_streetAddress = model.model_streetAdress;
        modelRelease.strModel_city = model.model_city;
        modelRelease.strModel_state = model.model_state;
        modelRelease.strModel_country = model.model_country;
        modelRelease.strModel_zipCode = model.model_zipCode;
        modelRelease.strModel_email = model.model_email;
        modelRelease.strModel_phone = model.model_phone;
        
        modelRelease.imgModel_signatureData = model.model_imgSignature;
        modelRelease.strModel_signDate = model.model_signDate;
        
        modelRelease.strFileName = model.fileName;
        
        // photoshoot info
        Photoshoot *photoshoot = [DBManager getPhotoshoot:model.photoshoot_id];
        
        modelRelease.strPhotoshoot_photographer = photoshoot.photographer;
        modelRelease.strPhotoshoot_title = photoshoot.shootTitle;
        modelRelease.strPhotoshoot_description = photoshoot.shootDescription;
        modelRelease.strPhotoshoot_date = photoshoot.date;
        modelRelease.strPhotoshoot_city = photoshoot.city;
        modelRelease.strPhotoshoot_state = photoshoot.state;
        modelRelease.strPhotoshoot_country = photoshoot.country;
        modelRelease.imgPhotoshoot_signature = photoshoot.imgSignature;
        modelRelease.strPhotoshoot_signDate = photoshoot.strSignDate;
    
        modelRelease.strPhotoshoot_photographerEmail = photoshoot.photographer_email;
        modelRelease.strPhotoshoot_companyName = photoshoot.company_name;
        modelRelease.strPhotoshoot_companyPhone = photoshoot.company_phone;
        modelRelease.imgPhotoshoot_companyLogo = photoshoot.company_logo;
        
        // Witness info
        Witness *witness = [DBManager getWitness:model.witness_id];
        modelRelease.strWitness_name = witness.name;
        modelRelease.imgWitness_signature = witness.signature;
        modelRelease.strWitness_signDate = witness.signDate;
        
        // Release Language
        //@property(nonatomic, strong) NSString *strLanuage;
        
    }
    
    return modelRelease;
}

+(PropertyRelease*)getProperty:(DataModel*)dataModel
{
    PropertyRelease *propertyRelease = [[PropertyRelease alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"fileName == %@", dataModel.strFileName];
    [fetchRequest setPredicate:predicateProperty];
    
    NSError *error;
    NSArray *arrProperties = [context executeFetchRequest:fetchRequest error:&error];
    if (arrProperties.count > 0)
    {
        Property *property = arrProperties[0];
        
        propertyRelease.dataProperty_photo = property.property_imgPhoto;
        propertyRelease.strProperty_description = property.property_description;
        propertyRelease.property_ownershipType = [property.property_ownerType intValue];
        propertyRelease.strProperty_Name = property.property_individualOwnerName;
        propertyRelease.strProperty_corporationName = property.property_coporationName;
        propertyRelease.strProperty_authorizedTitle = property.property_authorizedTitle;
        
        propertyRelease.strProperty_address = property.property_streetAddress;
        propertyRelease.strProperty_city = property.property_city;
        propertyRelease.strProperty_state = property.property_state;
        propertyRelease.strProperty_country = property.property_country;
        propertyRelease.strProperty_zipCode = property.property_zipCode;
        propertyRelease.strProperty_email = property.property_email;
        propertyRelease.strProperty_phone = property.property_tel;
        propertyRelease.imgProperty_signature = property.property_imgSignature;
        propertyRelease.strProperty_signDate = property.property_signDate;
        
        propertyRelease.strFileName = property.fileName;
        
        
        // photoshoot info
        Photoshoot *photoshoot = [DBManager getPhotoshoot:property.photoshoot_id];
        
        propertyRelease.strPhotoshoot_photographer = photoshoot.photographer;
        propertyRelease.strPhotoshoot_title = photoshoot.shootTitle;
        propertyRelease.strPhotoshoot_description = photoshoot.shootDescription;
        propertyRelease.strPhotoshoot_date = photoshoot.date;
        propertyRelease.strPhotoshoot_city = photoshoot.city;
        propertyRelease.strPhotoshoot_state = photoshoot.state;
        propertyRelease.strPhotoshoot_country = photoshoot.country;
        propertyRelease.imgPhotoshoot_signature = photoshoot.imgSignature;
        propertyRelease.strPhotoshoot_signDate = photoshoot.strSignDate;
        
        propertyRelease.strPhotoshoot_photographerEmail = photoshoot.photographer_email;
        propertyRelease.strPhotoshoot_companyName = photoshoot.company_name;
        propertyRelease.strPhotoshoot_companyPhone = photoshoot.company_phone;
        propertyRelease.imgPhotoshoot_companyLogo = photoshoot.company_logo;
        
        // Witness info
        Witness *witness = [DBManager getWitness:property.witness_id];
        propertyRelease.strWitness_name = witness.name;
        propertyRelease.imgWitness_signature = witness.signature;
        propertyRelease.strWitness_signDate = witness.signDate;
        
        // Release Language
        //@property(nonatomic, strong) NSString *strLanuage;
        
    }
    
    return propertyRelease;
}

+(Photoshoot*)getPhotoshoot:(NSNumber*)id
{
    Photoshoot *photoshoot = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photoshoot" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"id == %@", id];
    [fetchRequest setPredicate:predicateProperty];
    
    NSError *error;
    NSArray *arrPhotoshoots = [context executeFetchRequest:fetchRequest error:&error];
    
    if (arrPhotoshoots.count > 0)
    {
        photoshoot = arrPhotoshoots[0];
    }
    
    
    return photoshoot;
}


+(Witness*)getWitness:(NSNumber *)id
{
    Witness *witness = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Witness" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicateProperty = [NSPredicate predicateWithFormat:@"id == %@", id];
    [fetchRequest setPredicate:predicateProperty];
    
    NSError *error;
    NSArray *arrWitnesses = [context executeFetchRequest:fetchRequest error:&error];
    
    if (arrWitnesses.count > 0)
    {
        witness = arrWitnesses[0];
    }
    return witness;
}

#pragma mark - custom text

+(BOOL)addCustomTextWithTitle:(NSString*)strTitle withContent:(NSString*)strContent
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // check exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomText"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", strTitle];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrCustomText = [context executeFetchRequest:fetchRequest error:&error];
    
    // update
    if (arrCustomText.count > 0) {
        CustomText *customText = arrCustomText[0];
        
        customText.content = strContent;
        if (![context save:&error])
        {
            NSLog(@"Error!");
            return NO;
        }
        return YES;
    }
    
    // add new
    CustomText *customTextInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CustomText" inManagedObjectContext:context];
    customTextInfo.title = strTitle;
    customTextInfo.content = strContent;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+(BOOL)removeCustomTextWithTitle:(NSString*)strTitle
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // check exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomText" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", strTitle];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMerges = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrMerges.count > 0)
    {
        for (Merge *managedObject in arrMerges)
        {
            [context deleteObject:managedObject];
        }
        [context save:nil];
    }
    else
    {
        return NO;
    }
    
    
    return YES;
}

+(NSString*)getCustomTextContentWithTitle:(NSString*)strTitle
{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // check exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomText"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", strTitle];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrCustomText = [context executeFetchRequest:fetchRequest error:&error];

    if (arrCustomText.count > 0) {
        CustomText *customText = arrCustomText[0];
        return customText.content;
    }
    
    return @"";
}

+(NSArray*)getCustomTexts
{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // check exist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomText"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *arrCustomTexts = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrCustomTexts;
}


@end
