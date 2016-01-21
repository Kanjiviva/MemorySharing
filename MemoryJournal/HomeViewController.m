//
//  CheckInViewController.m
//  MemoryJournal
//
//  Created by Steve on 2016-01-15.
//  Copyright © 2016 Steve. All rights reserved.
//

#import "HomeViewController.h"
#import "ColorManager.h"
#import <INTULocationManager/INTULocationManager.h>
#import <Parse/Parse.h>
#import "LocationInfo.h"
#import "AddPostViewController.h"

#define CAMERA_ACCESS_ERROR_TITLE @"Unable To Detect Camera On The Device!"
#define CAMERA_ACCESS_ERROR_MESSAGE @"Oops! Unfortunately, we are unable to detect the camera. Please go to settings to enable the camera!"
#define SETTINGS @"Settings"
#define DONE @"Ok"
#define MAIN_STORYBOARD @"Main"
#define ADDPOST_VIEW_CONTROLLER @"AddPostViewController"

@interface HomeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseAlbumImageView;
@property (strong, nonatomic) LocationInfo *locationInfo;

@end

@implementation HomeViewController

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

# pragma mark - Private -

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

- (IBAction)cameraImageViewTapped:(UITapGestureRecognizer *)sender {
    
    [self startLocationManager];
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
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

- (IBAction)albumImageViewTapped:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

# pragma mark - UIImagePickerController Delegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    AddPostViewController *apViewController = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:ADDPOST_VIEW_CONTROLLER];
    apViewController.selectedImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:picker completion:^{
        [self presentViewController:apViewController animated:YES completion:nil];
    }];
    
    
}

@end
