//
//  JLWNoteData.m
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import "JLWNoteData.h"

@implementation JLWNoteData

@synthesize title = _title;
@synthesize noteText = _noteText;

- (id)initWithTitle:(NSString*)title noteText:(NSString*)noteText {
    if ((self = [super init])) {
        self.title = title;
        self.noteText = noteText;
    }
    return self;
}

#pragma mark NSCoding

#define kTitleKey       @"Title"
#define kNoteTextKey      @"Note"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_noteText forKey:kNoteTextKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    NSString *noteText = [decoder decodeObjectForKey:kNoteTextKey];
    return [self initWithTitle:title noteText:noteText];
}

// decodeWithCoder ? should check if nil and provide default 

@end
