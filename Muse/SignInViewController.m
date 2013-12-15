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

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailView;
@property (weak, nonatomic) IBOutlet UITextField *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)signIn:(id)sender;
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
    if ([User getUser]) {
        _emailView.text = [User getUser].email;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)signIn:(id)sender {
    
    User * user = [User userWithEmail:_emailView.text password:_passwordView.text];
    if ([user signin]) {
        UIView *tableView = self.revealViewController.rightViewController.view.subviews[0];
        UITableViewCell *tableCell = tableView.subviews[0];
        UIView *scrollView = tableCell.subviews[0];
        UIView *content = scrollView.subviews[1];
        UIImageView *imageView = content.subviews[0];
        UILabel *labelView = content.subviews[1];
        
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email/Password Incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
