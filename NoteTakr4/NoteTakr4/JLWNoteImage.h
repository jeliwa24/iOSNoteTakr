//
//  JLWNoteImage.h
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLWNoteData.h"

NSString *_docPath;

@interface JLWNoteImage : NSObject

@property (strong) JLWNoteData *data;

@property (strong) UIImage *thumbImage;
@property (strong) UIImage *fullImage;

@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteDoc;

- (id)initWithTitle:(NSString*)title noteText:(NSString*)noteText //thumbImage:(UIImage *)thumbImage
          fullImage:(UIImage *)fullImage;

@end
