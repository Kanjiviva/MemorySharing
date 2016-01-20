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
@property (weak, nonatomic) IBOutlet UITextView *addPostTextView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation AddPostViewController

# pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.tintColor = [ColorManager addPostDoneButtonTextColor];
    self.doneButton.backgroundColor = [ColorManager addPostDoneButtonBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBActions -

- (IBAction)doneButtonTapped:(UIButton *)sender {
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
