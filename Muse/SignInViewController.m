//
//  SignInViewController.m
//  Muse
//
//  Created by yan runchen on 2013/12/13.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "SignInViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "ServerConnection.h"
#import "Tag.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailView;
@property (weak, nonatomic) IBOutlet UITextField *passwordView;
@property (weak, nonatomic) IBOutlet UIView *signUpView;
- (IBAction)backToSignIn:(id)sender;
- (IBAction)showSignUpView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUp;
@property (weak, nonatomic) IBOutlet UITextField *pwdSignUp;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmSignUp;
@property (weak, nonatomic) IBOutlet UITextField *nameSignUp;
@property (weak, nonatomic) IBOutlet UIControl *signUpContainer;
@property (strong, nonatomic) FBLoginView *fbloginBtn;

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)closeViewEdit:(id)sender;

@end

@implementation SignInViewController

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
	// Do any additional setup after loading the view.
    //[_cancelBtn addTarget:self.revealViewController.frontViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    if ([User getUser] && ![[User getUser].email hasPrefix:@"#facebook#"] ) {
        _emailView.text = [User getUser].email;
    }
    _signUpView.backgroundColor = [UIColor colorWithWhite:0.18f alpha:1.0f];
    _signUpView.layer.cornerRadius = 5;
    _signUpView.layer.masksToBounds = YES;
    _signInBtn.layer.cornerRadius = 5;
    //_signUpView.layer.borderColor = [UIColor colorWithWhite:0.1f alpha:1.0f].CGColor;
    //_signUpView.layer.borderWidth = 7.0f;
    _signUpView.layer.shadowColor = [UIColor blackColor].CGColor;
    _signUpView.layer.shadowOpacity = 1.0;
    _signUpView.layer.shadowRadius = 5.0;
    _signUpView.layer.shadowOffset = CGSizeMake(0, 3);
    _signUpView.clipsToBounds = NO;
    CGRect rect = _signUpView.frame;
    _signUpView.frame = CGRectMake(rect.origin.x, 1136+rect.origin.y/2 , rect.size.width, rect.size.height);
    
    FBLoginView *fbloginBtn = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    fbloginBtn.frame = CGRectMake(66, 345, 196, 45);
    fbloginBtn.delegate = self;
    [self.view insertSubview:fbloginBtn atIndex:0];
    _signUpContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"%@",user.name);
    NSLog(@"%@",[user objectForKey:@"email"]);
    if ([User getUser]) return;
    [User userWithEmail:[NSString stringWithFormat:@"#facebook#%@",[user objectForKey:@"email"]] password:[NSString stringWithFormat:@"#Facebook#%@%@#Muse#",[user objectForKey:@"email"],user.id] name:user.name];
    [User getUser].resource_id = [NSNumber numberWithInt:1];
    NSString *result = [[User getUser] signinWithFB];
    if ([result isEqual:@"ok"]) {
        [Tag getAll];
        UIView *tableView = self.revealViewController.rightViewController.view.subviews[0];
        UIImageView *imageView = (UIImageView *) [tableView viewWithTag:1];//content.subviews[0];
        UILabel *labelView = (UILabel *) [tableView viewWithTag:2];//content.subviews[1];
        
        NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/%@", SERVER_URL, [User getUser].avatar]];
        UIImage *avatar = [UIImage imageWithData:data];
        imageView.image = avatar;
        labelView.text = [User getUser].name;
        
        [self performSegueWithIdentifier:@"backToPlayer" sender:self];
    }
    else{
        NSLog(@"failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"You're logged in as");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    //destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    //    if ([segue.identifier isEqualToString:@"showSignIn"]) {
    //        SignInView *signin = (SignInView*)segue.destinationViewController;
    //    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

- (void)resumeView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    float Y = 0.00f;
    CGRect rect = CGRectMake(0.0f, Y, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self resumeView];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height;
    
    NSLog(@"screen width: %f, height: %f", screenWidth, screenHeight);
    
    
    float Y = -30.0f;
    if (screenHeight <= 481) {
        Y = -115.0f;
    }
    CGRect rect = CGRectMake(0.0f, Y, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    return YES;
}

- (IBAction)backToSignIn:(id)sender {
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    CGRect rect = _signUpView.frame;
    _signUpView.frame = CGRectMake(rect.origin.x, 1136+rect.origin.y/2 , rect.size.width, rect.size.height);
    _signUpContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView commitAnimations];
    
    [self hideKeyboard];
    
    //_signUpView.hidden = YES;
}

- (void) hideKeyboard
{
    [_emailView resignFirstResponder];
    [_passwordView resignFirstResponder];
    [_emailSignUp resignFirstResponder];
    [_pwdSignUp resignFirstResponder];
    [_pwdConfirmSignUp resignFirstResponder];
    [_nameSignUp resignFirstResponder];
    [self resumeView];
}

- (IBAction)showSignUpView:(id)sender {
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    CGRect rect = _signUpView.frame;
    _signUpView.frame = CGRectMake(43, 142 , rect.size.width, rect.size.height);
    _signUpContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    [UIView commitAnimations];
    

}

- (IBAction)signIn:(id)sender {
    
    User * user = [User userWithEmail:_emailView.text password:_passwordView.text];
    NSString *result = [user signin];
    if ([result isEqual:@"ok"]) {
        [Tag getAll];
        UIView *tableView = self.revealViewController.rightViewController.view.subviews[0];
        UIImageView *imageView = (UIImageView *) [tableView viewWithTag:1];//content.subviews[0];
        UILabel *labelView = (UILabel *) [tableView viewWithTag:2];//content.subviews[1];
        
        if ([User getUser]) {
            NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/%@", SERVER_URL, [User getUser].avatar]];
            UIImage *avatar = [UIImage imageWithData:data];
            imageView.image = avatar;
            labelView.text = [User getUser].name;
        }
        
        [self performSegueWithIdentifier:@"backToPlayer" sender:self];
    }
    else{
        NSLog(@"failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)signUp:(id)sender {
    if ([_emailSignUp.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Email can't be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![self NSStringIsValidEmail:_emailSignUp.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Email is invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([_pwdSignUp.text isEqual:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Password can't be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([_pwdSignUp.text length] < 6 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Password is less than 6 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(![_pwdConfirmSignUp.text isEqual:_pwdSignUp.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([_nameSignUp.text isEqual:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Nickname can't be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        User* new_user = [User userWithEmail:_emailSignUp.text password:_pwdSignUp.text name:_nameSignUp.text];
        NSString* result = [new_user signup];
        if ([result isEqual: @"ok"]) {
            [Tag getAll];
            UIView *tableView = self.revealViewController.rightViewController.view.subviews[0];
            UIImageView *imageView = (UIImageView *) [tableView viewWithTag:1];//content.subviews[0];
            UILabel *labelView = (UILabel *) [tableView viewWithTag:2];//content.subviews[1];
            
            if ([User getUser]) {
                NSData *data = [ServerConnection getRequestToURL:[NSString stringWithFormat:@"%@/%@", SERVER_URL, [User getUser].avatar]];
                UIImage *avatar = [UIImage imageWithData:data];
                imageView.image = avatar;
                labelView.text = [User getUser].name;
            }
            
            [Tag getAll];
            [self performSegueWithIdentifier:@"backToPlayer" sender:self];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }

}

- (IBAction)closeViewEdit:(id)sender{
    [self hideKeyboard];
}

@end
