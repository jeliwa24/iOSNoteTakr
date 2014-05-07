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

@property (strong, nonatomic) JLWNoteData *data;

@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIImage *fullImage;

@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteDoc;

- (id)initWithTitle:(NSString*)title noteText:(NSString*)noteText //thumbImage:(UIImage *)thumbImage
          fullImage:(UIImage *)fullImage;

- (void) saveImages;

@end
