//
//  JLWDetailViewController.m
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import "JLWDetailViewController.h"
#import "JLWImageViewController.h"
#import "JLWNoteImage.h"
#import "JLWNoteData.h"
#import <QuartzCore/QuartzCore.h>


@interface JLWDetailViewController ()
- (void)configureView;
@end

@implementation JLWDetailViewController

@synthesize picker = _picker;

//-(instancetype) init {
//    // Registering for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillAppearNotification:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillDisappearNotification:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    return self;
//}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    // initial UI state
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        self.titleField.text = self.detailItem.data.title;
        self.noteTextField.text = self.detailItem.data.noteText;
        self.imageView.image = self.detailItem.fullImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.scrollView setScrollEnabled:YES];
    //[self.scrollView setContentSize:CGSizeMake(320, 800)];
    //[self.scrollView addSubview:self.imageView];
    //[self.scrollView addSubview:self.noteTextField];

    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.noteTextField.layer.borderWidth = 1.0f;
    self.noteTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppearNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappearNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    [self configureView];
}

- (void)adjustContentSizeForScrollView:(UIScrollView *)scrollView
{
    CGFloat height = 0.0;
    
    for (UIView *subview in scrollView.subviews)
    {
        CGFloat viewBottom = subview.frame.origin.y + subview.frame.size.height;
        if (viewBottom > height)
            height = viewBottom;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, height);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.detailItem.data.noteText = self.noteTextField.text;
    [_detailItem saveData];
    
}

-(void) keyboardWillAppearNotification:(NSNotification *)notification {
    NSDictionary *dictionary = [notification userInfo];
    CGRect keyboardFrame = [dictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // We adjust the frame of the scroll view so that it will not be under the
    // keyboard
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewFrame.size.height -= CGRectGetHeight(keyboardFrame);
    
    self.scrollView.frame = scrollViewFrame;
}

-(void) keyboardWillDisappearNotification:(NSNotification *)notification {
    // Reset the keyboard to its original position
    self.scrollView.frame = self.view.bounds;
}

-(void) animateTextField:(UITextField *)textField up:(BOOL)up {
    
}

-(void) closeKeyboard
{
    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPictureTapped:(id)sender {
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = YES;
    }
    [self presentViewController:_picker animated:YES completion:nil];
}

- (IBAction)titleFieldTextChanged:(id)sender {
    self.detailItem.data.title = self.titleField.text;

}

- (IBAction)viewImageTapped:(id)sender {
    [self performSegueWithIdentifier:@"viewImage" sender:self];
}

- (IBAction)sendEmail:(id)sender {

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    //[mailComposer setToRecipients:[NSArray arrayWithObjects: @"support@myappworks.com",nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"Check out my note - %@",self.titleField.text]];

    //message body:
    NSString *supportText = [NSString stringWithFormat:@"%@",self.noteTextField.text];
//    supportText = [supportText stringByAppendingString: @"Please describe your problem or question."];
    UIImage *supportImage = self.imageView.image;
    NSData *imgData = UIImagePNGRepresentation(supportImage);
    [mailComposer setMessageBody:supportText isHTML:NO];
    [mailComposer addAttachmentData:imgData mimeType:@"image/png" fileName:@"noteimage.png"];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Implement the method shouldAutorotateToInterfaceOrientation
- (BOOL)shouldAutorotateToInterfaceOrientation {
    return YES;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
    self.detailItem.fullImage = fullImage;
    //self.detailItem.thumbImage = thumbImage;
    self.imageView.image = fullImage;
    
    [_detailItem saveImages];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showImage"]) {
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //        NSDate *object = _objects[indexPath.row];
        //        [[segue destinationViewController] setDetailItem:object];
        
        JLWImageViewController *imageController = segue.destinationViewController;
        //JLWNoteImage *note = [self.notes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        //imageController.detailItem = note;
    }
}
@end
