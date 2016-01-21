//
//  AddPostViewController.m
//  MemoryJournal
//
//  Created by Steve on 2016-01-16.
//  Copyright © 2016 Steve. All rights reserved.
//

#import "AddPostViewController.h"
#import "ColorManager.h"

@interface AddPostViewController () <UITextFieldDelegate>

# pragma mark - IBOutlets -

@property (weak, nonatomic) IBOutlet UITextView *addPostTextView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postImageViewToBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewtoBottomConstraint;

# pragma mark - Properties -

@property (assign) BOOL isImageViewAnimated;
@property (assign) CGRect textViewOriFrame;
@property (assign) BOOL isKeyboardShown;

@end

@implementation AddPostViewController

# pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.tintColor = [ColorManager addPostDoneButtonTextColor];
    self.doneButton.backgroundColor = [ColorManager addPostDoneButtonBackgroundColor];
    [self setupPostImageView];
    [self addKeyboardToolBarWithDoneButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textViewOriFrame = self.addPostTextView.frame;
}

# pragma mark - Private -

- (void)setupPostImageView {
    if (self.selectedImage != nil) {
        self.postImageView.hidden = NO;
        self.postImageView.layer.cornerRadius = self.postImageView.frame.size.width / 2;
        self.postImageView.layer.borderWidth = 1.5;
        self.postImageView.layer.borderColor = [UIColor blackColor].CGColor;
        self.postImageView.clipsToBounds = YES;
        self.postImageView.image = self.selectedImage;
    } else {
        self.postImageView.hidden = YES;
    }
}

- (void)addKeyboardToolBarWithDoneButton {
    
    UIToolbar *keyboardDoneButtonView = [UIToolbar new];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(keyboardDoneButtonTapped)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.addPostTextView.inputAccessoryView = keyboardDoneButtonView;
    
}

- (void)keyboardDoneButtonTapped {
    [self.addPostTextView resignFirstResponder];
}

# pragma mark - IBActions -

- (IBAction)doneButtonTapped:(UIButton *)sender {
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animateHeight = keyboardHeight + 8 - self.doneButton.frame.size.height;
    if ((self.selectedImage != nil && !self.isImageViewAnimated) || !self.isKeyboardShown) {
        self.isImageViewAnimated = YES;
        self.isKeyboardShown = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.postImageViewToBottomConstraint.constant = animateHeight;
            self.textViewtoBottomConstraint.constant = animateHeight - 8;
            [self.view layoutIfNeeded];
        }];
    } else {
        self.isImageViewAnimated = NO;
        self.isKeyboardShown = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.postImageViewToBottomConstraint.constant = 8;
            self.textViewtoBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    
    
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
}

@end
