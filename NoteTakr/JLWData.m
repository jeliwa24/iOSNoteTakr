//
//  JLWData.m
//  NoteTakr
//
//  Created by Jessica Wang on 5/1/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import "JLWData.h"

@implementation JLWData

NSMutableDictionary *allNotes;
NSString *currentKey;

+(NSMutableDictionary *) getAllNotes {
    
    if(allNotes == nil) {
        allNotes = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kAllNotes]];
    }
    
    return allNotes;
}

+(void) setCurrentKey:(NSString *) key {
    currentKey = key;
}

+(NSString *) getCurrentKey{
    return currentKey;
}

+(void) setNoteForCurrentKey:(NSString *)note{
    [self setNote:note forKey:currentKey];
}

// manipulate or change notes
+(void) setNote:(NSString *) note forKey:(NSString *) key{
    [allNotes setObject:note forKey:key];
}

+(void) removeNoteForKey:(NSString *) key{
    [allNotes removeObjectForKey:key];
}

+(void) saveNotes {
    [[NSUserDefaults standardUserDefaults] setObject:allNotes forKey:kAllNotes];
}

@end
