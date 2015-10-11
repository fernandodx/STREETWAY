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
#import "FireBaseUtil.h"




@interface FaceBookViewController ()

@property(nonatomic, strong) IBOutlet UILabel* labelLagodo;


@end

@implementation FaceBookViewController

@synthesize labelLagodo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Firebase *ref = [FireBaseUtil getFireRef];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        
                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            
                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       
                                                       if (error) {
                                                           NSLog(@"Login failed. %@", error);
                                                       } else {
                                                           NSLog(@"Logged in! %@", authData);
                                                       }
                                                   }];
                                        }
                                    }];

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
