//
//  Merge+CoreDataProperties.h
//  
//
//  Created by beauty on 2/26/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Merge.h"

NS_ASSUME_NONNULL_BEGIN

@interface Merge (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *descriptions;
@property (nullable, nonatomic, retain) NSString *strDate;
@property (nullable, nonatomic, retain) NSData *imgPhoto;
@property (nullable, nonatomic, retain) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
