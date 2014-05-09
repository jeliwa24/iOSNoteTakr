//
//  JLWDetailViewController.m
//  NoteTakr4
//
//  Created by Jessica Wang on 5/5/14.
//  Copyright (c) 2014 JWang. All rights reserved.
//

#import "JLWDetailViewController.h"
#import "JLWNoteImage.h"
#import "JLWNoteData.h"
#import <QuartzCore/QuartzCore.h>


@interface JLWDetailViewController ()
- (void)configureView;
@end

@implementation JLWDetailViewController

@synthesize picker = _picker;


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
        self.noteTextView.text = self.detailItem.data.noteText;
        self.imageView.image = self.detailItem.fullImage;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    [self toggleEditPhotoButtons];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self toggleEditPhotoButtons];

    CGRect scrollViewFrame = self.view.frame;
    scrollViewFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    scrollViewFrame.size.height -= self.toolBar.frame.size.height;

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);

    // button for navigation bar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // buttons for toolbar
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendEmail:)];
    
    UIBarButtonItem *takePictureButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    self.toolBar.items = [NSArray arrayWithObjects:emailButton, space, takePictureButton, nil];

    // set image to scale aspect fit
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // add rounded border to text view
    [self.noteTextView.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor]];
    [self.noteTextView.layer setBorderWidth:1.0];
    
    self.noteTextView.layer.cornerRadius = 5;
    self.noteTextView.clipsToBounds = YES;
    
    // tried to implement shifting the scroll view up so keyboard doesn't cover up textview, but wasn't able to get it to work :(
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillAppearNotification:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillDisappearNotification:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
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
    
    self.detailItem.data.noteText = self.noteTextView.text;
    [_detailItem saveData];
    
}

-(void) keyboardWillAppearNotification:(NSNotification *)notification {

    [self animateTextField: notification up:YES];

    
}

-(void) keyboardWillDisappearNotification:(NSNotification *)notification {

    [self animateTextField: notification up:NO];

}

// tried to implement shifting text view so keyboard doesn't cover it up... but didn't get it to work
-(void) animateTextField:(NSNotification *)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect originalTextViewFrame = self.noteTextView.frame;

    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect newTextViewFrame = self.noteTextView.frame;
        newTextViewFrame.size.height = keyboardTop - self.noteTextView.frame.origin.y - 10;
        
        self.noteTextView.frame = newTextViewFrame;
    } else {
        // Keyboard is going away (down) - restore original frame
        self.noteTextView.frame = originalTextViewFrame;
    }
    
    [UIView commitAnimations];
}

-(void)closeKeyboard
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

- (IBAction)viewImageTapped:(id)sender {
    [self performSegueWithIdentifier:@"viewImage" sender:self];
}

- (IBAction)titleFieldTextChanged:(id)sender {
    self.detailItem.data.title = self.titleField.text;

}

- (IBAction)sendEmail:(id)sender {

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:[NSString stringWithFormat: @"Check out my note - %@",self.titleField.text]];

    //message body:
    NSString *supportText = [NSString stringWithFormat:@"%@",self.noteTextView.text];
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
    
    [self toggleEditPhotoButtons];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    // chosen image
    
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.detailItem.fullImage = fullImage;
    self.imageView.image = fullImage;
    
    //check if picture was selected
    [self toggleEditPhotoButtons];
    [_detailItem saveImages];
}

- (void) toggleEditPhotoButtons {
    
    // if there is an image chosen, show edit photos buttons, otherwise don't show
    if (!self.imageView.image) {
        [self.changePhoto setHidden:YES];
        [self.deletePhotoButton setHidden:YES];
        [self.tapToAdd setHidden:NO];

    }
    else {
        [self.changePhoto setHidden:NO];
        [self.deletePhotoButton setHidden:NO];
        [self.tapToAdd setHidden:YES];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showImage"]) {
        
        //JLWImageViewController *imageController = segue.destinationViewController;
    }
}


- (IBAction)deletePhoto:(id)sender {
    self.imageView.image = (UIImage *)nil;
    [self toggleEditPhotoButtons];
    [_detailItem deleteImage];

}

- (void) takePicture {
    // check if device has camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else {
        // this should theoretically work, couldn't try it coz simulator doesn't have camera
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

@end
