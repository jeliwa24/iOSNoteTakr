//
//  JLWDetailViewController.h
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class JLWNoteImage;

@interface JLWDetailViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) JLWNoteImage *detailItem;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)addPictureTapped:(id)sender;
- (IBAction)titleFieldTextChanged:(id)sender;
- (IBAction)viewImageTapped:(id)sender;
- (IBAction)sendEmail:(id)sender;

@end
