//
//  JLWAppDelegate.h
//  NoteTakr
//
//  Created by Jessica Wang on 4/30/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
