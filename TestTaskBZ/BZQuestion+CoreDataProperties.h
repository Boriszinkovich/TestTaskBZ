//
//  BZQuestion+CoreDataProperties.h
//  TestTaskBZ
//
//  Created by User on 30.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BZQuestion.h"

NS_ASSUME_NONNULL_BEGIN

@interface BZQuestion (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *questionText;
@property (nullable, nonatomic, retain) NSNumber *backgroundImage;
@property (nullable, nonatomic, retain) BZCategory *category;

@end

NS_ASSUME_NONNULL_END
