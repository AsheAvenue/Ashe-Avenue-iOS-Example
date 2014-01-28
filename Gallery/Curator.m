//
//  Curator.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Curator.h"
#import "Gallery.h"
#import "Menu.h"
#import "MainNav.h"

@implementation Curator

@synthesize curatorId, curatorNameLabel, secondaryTextLabel, image, text, galleryButton;

NSString *curatorName;
int curatorImageCount;

int leftSwipes = 0;
int rightSwipes = 0;

#pragma mark -
#pragma mark View


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [curatorNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    [text setFont:[UIFont fontWithName:@"OpenSans" size:17]];
    
    curatorId = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"curatorId"];
    if(curatorId == nil) {
        curatorId = @"1";
    }
    
    [self selectCurator];
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangeCurator:)
                                                 name:@"CuratorChanged"
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CuratorChanged" object:nil];
}

- (void)handleChangeCurator: (NSNotification *) notification {
    
    //get the notification's userInfo and parse out the curatorId
    NSDictionary *dict = notification.userInfo;
    self.curatorId = [dict objectForKey:@"curatorId"];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.curatorId forKey:@"curatorId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self selectCurator];
}

- (void)selectCurator {
    //load the curator file
    NSString *fileName = [NSString stringWithFormat:@"Curator-%@", curatorId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    if (filePath) {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *array = [contentOfFile componentsSeparatedByString:@"|"];
        
        curatorName = [[array objectAtIndex:0] uppercaseString];
        self.curatorNameLabel.text = curatorName;
        curatorImageCount = [[array objectAtIndex:1] intValue];
        
        NSString *secondaryText = [array objectAtIndex:2];
        self.secondaryTextLabel.text = secondaryText;

        self.text.text = [array objectAtIndex:3];
    }
    
    //load the image
    UIImage *curatorImage = [UIImage imageNamed:[NSString stringWithFormat:@"Curator-%@.jpg", curatorId]];
    [self.image setImage:curatorImage];
    
    //wipe out the existing UIImageView array
    [(MainNav *)self.navigationController setImgViews:nil];
}

-(IBAction)handleGalleryButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowGallery" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowGallery"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
        [[segue destinationViewController] setCuratorName:curatorName];
        [[segue destinationViewController] setCuratorSecondaryText:secondaryTextLabel.text];
        [[segue destinationViewController] setCuratorImageCount:curatorImageCount];
    } else if ([[segue identifier] isEqualToString:@"ShowMenu"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    }
}

#pragma mark -
#pragma mark Gesture

- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    leftSwipes++;
    [self handleSwipes];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    rightSwipes++;
    [self handleSwipes];
}

- (void)handleSwipes {
    if(leftSwipes > 1 && rightSwipes > 1) {
        [self performSegueWithIdentifier:@"ShowMenu" sender:self];
        leftSwipes = 0;
        rightSwipes = 0;
    }
}

@end
