//
//  ContainerViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/7/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "ContainerViewController.h"
#import "GameCollectionViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation ContainerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	for (UIViewController * maze in self.childViewControllers) {
//		if ([maze isKindOfClass: [GameCollectionViewController class]])
//		{
//			[maze willMoveToParentViewController:nil];
//			[maze.view removeFromSuperview];
//			[maze removeFromParentViewController];
//		}
//	}
//	
//	UIViewController * sierpinsky = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Sierpinsky"];
//	sierpinsky.view.frame = self.container.frame;
//	[sierpinsky willMoveToParentViewController:self];
//	[self.view addSubview:sierpinsky.view];
//	[sierpinsky didMoveToParentViewController:self];
//	[self addChildViewController:sierpinsky];
	
}


@end
