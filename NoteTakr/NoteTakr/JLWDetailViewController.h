//
//  JLWDetailViewController.h
//  NoteTakr
//
//  Created by Jessica Wang on 4/30/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionText;

@end
