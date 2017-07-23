//
//  ChooseAddressViewController.m
//  `
//
//  Created by Rajat Agrawal on 7/22/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "ChooseAddressViewController.h"

@interface ChooseAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressBar;

@end

@implementation ChooseAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressBar.delegate = self;
    UIImage *chooseAddressImage = [UIImage imageNamed:@"nav-address"];
    /*
    
     [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-address"]];
    [[UIBarButtonItem alloc] initWithImage:@"nav-address" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"plz" style:UIBarButtonItemStylePlain target:nil action:nil];
    */
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:chooseAddressImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    
    self.navigationItem.backBarButtonItem.tintColor = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:chooseAddressImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.navigationItem.title = @"Choose an address";
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboard show frame is %lf %lf", keyboardFrame.size.height, keyboardFrame.size.width);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect originalRect = self.view.frame;
    originalRect.origin.y -= keyboardFrame.size.height;
    self.view.frame = originalRect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSLog(@"keyboard show frame is %lf %lf", keyboardFrame.size.height, keyboardFrame.size.width);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect originalRect = self.view.frame;
    originalRect.origin.y += keyboardFrame.size.height;
    self.view.frame = originalRect;
    
    [UIView commitAnimations];
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
