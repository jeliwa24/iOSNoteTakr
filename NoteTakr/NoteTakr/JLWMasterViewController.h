//
//  JLWMasterViewController.h
//  NoteTakr
//
//  Created by Jessica Wang on 4/30/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface JLWMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
