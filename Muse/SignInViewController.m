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
        NSLog(@"%@",user.name);
        NSString *error;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserProfile.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                                   [NSArray arrayWithObjects: user.user_id, user.name, user.email,user.avatar, user.remembrer_token, nil]
                                                              forKeys:[NSArray arrayWithObjects: @"user_id", @"Name", @"Email",@"Avatar", @"Remember_token", nil]];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
        else {
            NSLog(@"%@",error);
        }
        
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"UserProfile" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        NSLog(@"%@",[temp objectForKey:@"Name"]);
        NSLog(@"%@",[temp objectForKey:@"Email"]);
        NSLog(@"%@",[temp objectForKey:@"Avatar"][@"url"]);
        NSLog(@"%@",[temp objectForKey:@"Remember_token"]);
    }
    else{
        NSLog(@"failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"email/password incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
