//
//  CheckInViewController.m
//  MemoryJournal
//
//  Created by Steve on 2016-01-15.
//  Copyright © 2016 Steve. All rights reserved.
//

#import "CheckInViewController.h"
#import "ColorManager.h"
#import <INTULocationManager/INTULocationManager.h>
#import <Parse/Parse.h>
#import "LocationInfo.h"

#define CAMERA_ACCESS_ERROR_TITLE @"Unable To Detect Camera On The Device!"
#define CAMERA_ACCESS_ERROR_MESSAGE @"Oops! Unfortunately, we are unable to detect the camera. Please go to settings to enable the camera!"
#define SETTINGS @"Settings"
#define DONE @"Ok"

@interface CheckInViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseAlbumImageView;
@property (strong, nonatomic) LocationInfo *locationInfo;

@end

@implementation CheckInViewController

# pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationInfo = [LocationInfo object];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupCheckInButton];
}

# pragma mark - Private -

- (void)setupCheckInButton {
    self.checkInBtn.layer.cornerRadius = self.checkInBtn.frame.size.width / 2;
    self.checkInBtn.layer.borderWidth = 1;
    self.checkInBtn.layer.borderColor = [ColorManager homeCheckInButtonBorderColor].CGColor;
    self.checkInBtn.backgroundColor = [ColorManager homeCheckInButtonBackGroundColor];
    self.checkInBtn.tintColor = [ColorManager homeCheckInButtonTextColor];
}

- (void)startLocationManager {
    __weak typeof(self) weakSelf = self;
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                                                     timeout:5.0
                                                                       block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                                           
                                                                           if (status == INTULocationStatusSuccess || status == INTULocationStatusTimedOut) {
                                                                               
                                                                               PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
                                                                               weakSelf.locationInfo.currentLocation = geoPoint;
                                                                               
                                                                               [weakSelf.locationInfo saveInBackground];
                                                                           } else if (status == INTULocationStatusServicesNotDetermined) {
                                                                               
                                                                           }
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                       }];
}

# pragma mark - IBActions -

- (IBAction)checkInButtonTapped:(UIButton *)sender {
    
    [self startLocationManager];
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:CAMERA_ACCESS_ERROR_TITLE
                                              message:CAMERA_ACCESS_ERROR_MESSAGE
                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *settings = [UIAlertAction actionWithTitle:SETTINGS
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        UIAlertAction *Ok = [UIAlertAction actionWithTitle:DONE
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                                            }];
        
        [alertController addAction:settings];
        [alertController addAction:Ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
}

- (IBAction)imageViewTapped:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

# pragma mark - UIImagePickerController Delegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
}

@end
