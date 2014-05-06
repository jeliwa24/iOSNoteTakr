//
//  JLWNoteData.h
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLWNoteData : NSObject <NSCoding>

@property (strong) NSString *title;
@property (strong) NSString *noteText;

- (id)initWithTitle:(NSString*)title noteText:(NSString*)noteText;



@end
