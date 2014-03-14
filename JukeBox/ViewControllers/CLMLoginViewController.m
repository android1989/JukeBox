//
//  CLMLoginViewController.m
//  Jukebox
//
//  Created by Andrew Hulsizer on 3/13/14.
//  Copyright (c) 2014 Classy Monsters. All rights reserved.
//

#import "CLMLoginViewController.h"
#import "CLMBubbleView.h"
#import <GROAuth2SessionManager/GROAuth2SessionManager.h>

@interface CLMLoginViewController () <UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet CLMBubbleView *bubble1;
@property (nonatomic, strong) IBOutlet CLMBubbleView *bubble2;
@property (nonatomic, strong) IBOutlet CLMBubbleView *bubble3;
@property (nonatomic, strong) IBOutlet CLMBubbleView *bubble4;
@end

@implementation CLMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://partner.api.beatsmusic.com/oauth2/authorize?response_type=code&redirect_uri=https%3A%2F%2Fwww.example.com&client_id=538k54xdrc6xnq9rnf55uyts"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"KenyanCoffeeRg-Regular" size:23];
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius = 12;
    self.loginButton.layer.borderWidth = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimation {
    [UIView animateWithDuration:60 animations:^{
        self.bubble1.center = CGPointMake(self.bubble1.center.x, 800);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:50 animations:^{
        self.bubble2.center = CGPointMake(self.bubble2.center.x, 800);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:45 animations:^{
        self.bubble3.center = CGPointMake(self.bubble3.center.x, 800);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:80 animations:^{
        self.bubble4.center = CGPointMake(self.bubble4.center.x, 800);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)login:(NSString *)scope code:(NSString *)code {
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:@"https://partner.api.beatsmusic.com"];
    GROAuth2SessionManager *oauthClient = [GROAuth2SessionManager managerWithBaseURL:url clientID:@"538k54xdrc6xnq9rnf55uyts" secret:@"Bzx6dRbzBvKX4Ce5yrxrpysE"];
    
    [oauthClient authenticateUsingOAuthWithPath:@"/oauth2/token" code:code redirectURI:@"https://www.example.com" success:^(AFOAuthCredential *credential) {
        NSLog(@"I have a token! %@", credential.accessToken);
        [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
        [self.delegate loginViewControllerDidLogin];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        self.errorLabel.text = error.description;
    }];
}



- (IBAction)dismissTextFields:(id)sender {
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL.baseURL);
    
    NSArray *components = [request.URL.absoluteString componentsSeparatedByString:@"?"];
    NSString *baseURL =  [components firstObject];
    NSString *parameters = [components lastObject];
    
    if ([baseURL isEqualToString:@"https://www.example.com/services.php"]) {
        NSArray *params = [parameters componentsSeparatedByString:@"&"];
        NSString *scope = [[[params firstObject] componentsSeparatedByString:@"="] lastObject];
        NSString *code  = [[[params objectAtIndex:1] componentsSeparatedByString:@"="] lastObject];
        [self login:scope code:code];
        
        [self hideWebView];
        return NO;
    }
    return YES;
}

- (void)showWebView {
    [UIView animateWithDuration:.5 animations:^{
        self.webView.center = CGPointMake(self.webView.center.x, self.view.center.y-10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.webView.center = CGPointMake(self.webView.center.x, self.view.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)hideWebView {
    [UIView animateWithDuration:.2 animations:^{
        self.webView.center = CGPointMake(self.webView.center.x, self.view.center.y-10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            self.webView.center = CGPointMake(self.webView.center.x, 852);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)beginFlow:(id)sender {
    [self showWebView];
}
@end
