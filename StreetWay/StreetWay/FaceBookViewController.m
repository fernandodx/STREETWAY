//
//  FaceBookViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 24/08/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "FaceBookViewController.h"
#import <Firebase/Firebase.h>
#import "LocalDAO.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphAction.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphContent.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FontAwesomeKit/FontAwesomeKit.h>




@interface FaceBookViewController ()

@property(nonatomic, strong) IBOutlet UILabel* labelLagodo;


@end

@implementation FaceBookViewController

@synthesize labelLagodo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://STREETWAY.firebaseio.com"];
//    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
//
//    
//    [facebookLogin logInWithPublishPermissions:@[@"publish_actions"]
//                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
//                                        
//                                        if (facebookError) {
//                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
//                                        } else if (facebookResult.isCancelled) {
//                                            NSLog(@"Facebook login got cancelled.");
//                                        } else {
//                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
//                                            
//                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
//                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
//                                                       
//                                                       if (error) {
//                                                           NSLog(@"Login failed. %@", error);
//                                                           [labelLagodo setText:@"Falha no login."];
//                                                          
//                                                       } else {
//                                                           NSLog(@"Logged in! %@", authData);
//                                                           [labelLagodo setText:@"Login realizado com sucesso!"];
//                                                       }
//                                                   }];
//                                            
//                                        }
//                                    }];
//    
//    
    
    
    // Add a custom login button to your app
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor darkGrayColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
   
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
         }
     }];
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
