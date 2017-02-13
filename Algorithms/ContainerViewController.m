//
//  ContainerViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/7/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "ContainerViewController.h"
#import "GameCollectionViewController.h"
#import "ViewHierarchyViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;

@property (nonatomic, strong) ViewHierarchyViewController * view1;
@property (nonatomic, strong) ViewHierarchyViewController * view2;

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
//	[self.container addSubview:sierpinsky.view];
//	[sierpinsky didMoveToParentViewController:self];
//	[self addChildViewController:sierpinsky];
	

}

#pragma mark - Actions

- (IBAction)didPressMaze:(id)sender {
	
	for (UIViewController * child in self.childViewControllers) {
		if ([child isKindOfClass:[GameCollectionViewController class]]) {
			[self.container bringSubviewToFront:child.view];
			break;
		}
	}
	
}

- (IBAction)didPressView1:(id)sender {
	
	if (self.view1) {
		[self.container bringSubviewToFront:self.view1.view];
	}
	else {
		ViewHierarchyViewController * view1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewHierarchy"];
		view1.view.frame = self.container.frame;
		[view1 willMoveToParentViewController:self];
		[self.container addSubview:view1.view];
		[view1 didMoveToParentViewController:self];
		[self addChildViewController:view1];
		self.view1 = view1;
	}
}

- (IBAction)didPressView2:(id)sender {
	
	if (self.view2) {
		[self.container bringSubviewToFront:self.view2.view];
	}
	else {
		ViewHierarchyViewController * view1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewHierarchy"];
		view1.view.frame = self.container.frame;
		[view1 willMoveToParentViewController:self];
		[self.container addSubview:view1.view];
		[view1 didMoveToParentViewController:self];
		[self addChildViewController:view1];
		self.view2 = view1;
	}
}

- (IBAction)didPressScan:(id)sender {
	
	NSMutableArray * path = [NSMutableArray new];
	
	UIView * superView = self.view1.test
	
	
}

@end
