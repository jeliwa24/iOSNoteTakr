//
//  JLWDetailViewController.h
//  NoteTakr3
//
//  Created by Jessica Wang on 5/2/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
