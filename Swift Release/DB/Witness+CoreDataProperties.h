//
//  Witness+CoreDataProperties.h
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Witness.h"

NS_ASSUME_NONNULL_BEGIN

@interface Witness (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *signature;
@property (nullable, nonatomic, retain) NSString *signDate;
@property (nonatomic, retain) NSNumber *counter;

@end

NS_ASSUME_NONNULL_END
