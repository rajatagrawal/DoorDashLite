//
//  ChooseAddressViewController.m
//  `
//
//  Created by Rajat Agrawal on 7/22/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import <MapKit/MapKit.h>
#import "DataStore.h"

@interface ChooseAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, assign) BOOL reducedSize;
@property (weak, nonatomic) IBOutlet UIButton *confirmAddressButton;

@end

@implementation ChooseAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.mapView setShowsUserLocation:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [self.mapView setShowsUserLocation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressBar.delegate = self;
    self.navigationItem.title = @"Choose an address";
    self.reducedSize = NO;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"User entered : %@", self.addressBar
          .text);
    
    if (self.addressBar.text.length > 0) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = [NSString stringWithString:self.addressBar.text];
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                UIAlertController *errorController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [errorController addAction:[UIAlertAction actionWithTitle:@"Dismiss"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
              [self presentViewController:errorController animated:YES completion:nil];
            } else {
                NSLog(@"Response is %@", response);
                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
                pointAnnotation.title = response.mapItems.firstObject.name;
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(response.boundingRegion.center.latitude, response.boundingRegion.center.longitude);
                
                MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:pointAnnotation reuseIdentifier:nil];
                self.mapView.centerCoordinate = pointAnnotation.coordinate;
                [self.mapView addAnnotation:[annotationView annotation]];
                
                
                MKCoordinateRegion region =  MKCoordinateRegionMake(pointAnnotation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
                self.mapView.region = region;
                self.currentLocation = pointAnnotation.coordinate;
            }
        }];
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.reducedSize == NO) {
        self.reducedSize = YES;
        
        self.confirmAddressButton.hidden = YES;
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"keyboard show frame is %lf %lf", keyboardFrame.size.height, keyboardFrame.size.width);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect originalRect = self.view.frame;
        NSLog(@"showing original keyboard frame is %lf", originalRect.size.height);
        originalRect.size.height -= keyboardFrame.size.height;
        self.view.frame = originalRect;
        
        [UIView commitAnimations];
    }
}
- (IBAction)confirmAddress:(id)sender {
    DataStore.sharedInstance.currentLocation = self.currentLocation;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.reducedSize) {
        self.reducedSize = NO;
        self.confirmAddressButton.hidden = NO;
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        NSLog(@"keyboard show frame is %lf %lf", keyboardFrame.size.height, keyboardFrame.size.width);
        
        NSLog(@"hiding original keyboard frame is %lf", self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect originalRect = self.view.frame;
        originalRect.size.height += keyboardFrame.size.height;
        self.view.frame = originalRect;
        
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
