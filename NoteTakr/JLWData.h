//
//  JLWData.h
//  NoteTakr
//
//  Created by Jessica Wang on 5/1/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDefaultValue @"New Note"
#define kAllNotes @"Notes"
#define kDetailView @"Show Detail"

@interface JLWData : NSObject
+(NSMutableDictionary *) getAllNotes;
+(void) setCurrentKey:(NSString *) key;
+(NSString *) getCurrentKey;
+(void) setNoteForCurrentKey:(NSString *)note;
// manipulate or change notes
+(void) setNote:(NSString *) note forKey:(NSString *) key;
+(void) removeNoteForKey:(NSString *) key;
+(void) saveNotes;

@end
