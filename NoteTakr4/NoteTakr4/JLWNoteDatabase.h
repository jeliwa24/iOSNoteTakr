//
//  JLWNoteDatabase.h
//  NoteTakr4
//
//  Created by Jessica Wang on 5/6/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLWNoteDatabase : NSObject

+ (NSMutableArray *)loadJLWNotes;
+ (NSString *)nextJLWNotePath;

@end
