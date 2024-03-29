//
//  JLWNoteImage.m
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import "JLWNoteImage.h"
#import "JLWNoteData.h"
#import "JLWNoteDatabase.h"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"
#define kFullImageFile  @"fullImage.jpg"

@implementation JLWNoteImage

@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize fullImage = _fullImage;
@synthesize docPath = _docPath;

- (id)initWithTitle:(NSString*)title noteText:(NSString*)noteText //thumbImage:(UIImage *)thumbImage
          fullImage:(UIImage *)fullImage {
    if ((self = [super init])) {
        self.data = [[JLWNoteData alloc] initWithTitle:title noteText:noteText];
        // self.thumbImage = thumbImage;
        self.fullImage = fullImage;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [JLWNoteDatabase nextJLWNotePath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

-(JLWNoteData *)data {
    
    if(_data!=nil) {
        return _data;
    }
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    return _data;
    
}

- (void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}

- (void) saveImages {
    //if (_thumbImage == nil || _fullImage == nil) return;
    //if(_fullImage == nil) return;
    
    [self createDataPath];
    
//    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
//    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
//    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    NSString *fullImagePath;
    // write image to disk

    fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    NSData *fullImageData = UIImagePNGRepresentation(_fullImage);
    [fullImageData writeToFile:fullImagePath atomically:YES];
    
    // set cached copy to nil
//    self.thumbImage = nil;
    self.fullImage = nil;
}

- (void) deleteImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    
    NSError *error;
    [fileManager removeItemAtPath:fullImagePath error:&error];
}

- (UIImage *)fullImage {
    
    if (_fullImage != nil) return _fullImage;
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    return [UIImage imageWithContentsOfFile:fullImagePath];
    
}

@end
