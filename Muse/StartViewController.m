//
//  StartViewController.m
//  Muse
//
//  Created by yan runchen on 2013/12/20.
//  Copyright (c) 2013年 zhu peijun. All rights reserved.
//

#import "StartViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "Tag.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
//{
//    // Set the title of navigation bar by using the menu items
//    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    //destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
//    
//    // Set the photo if it navigates to the PhotoView
//    //    if ([segue.identifier isEqualToString:@"showSignIn"]) {
//    //        SignInView *signin = (SignInView*)segue.destinationViewController;
//    //    }
//    
//    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
//        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
//        
//        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
//            
//            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//            [navController setViewControllers: @[dvc] animated: YES ];
//            //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        };
//        
//    }
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"museStart.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([User getUser]) {
        if ([[User getUser] signinWithRememberToken]) {
            [Tag getAll];
            [self performSegueWithIdentifier:@"jumpToPlay" sender:self];
        }
        else{
            NSLog(@"remember_token is incorrent");
            [self performSegueWithIdentifier:@"goToSign" sender:self];
        }
    }
    else{
        [self performSegueWithIdentifier:@"goToSign" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
