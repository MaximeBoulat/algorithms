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
#import "Algorithms-Swift.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;

@property (nonatomic, strong) UINavigationController * view1;
@property (nonatomic, strong) UIViewController * sierpinsky;

@end

@implementation ContainerViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	UINavigationController * view1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewHierarchyNav"];
	view1.view.frame = self.container.frame;
	[view1 willMoveToParentViewController:self];
	[self.container addSubview:view1.view];
	[view1 didMoveToParentViewController:self];
	[self addChildViewController:view1];
	self.view1 = view1;
	 
//	UIViewController * sierpinsky = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Sierpinsky"];
//	sierpinsky.view.frame = self.container.frame;
//	[sierpinsky willMoveToParentViewController:self];
//	[self.container addSubview:sierpinsky.view];
//	[sierpinsky didMoveToParentViewController:self];
//	[self addChildViewController:sierpinsky];
//	self.sierpinsky = sierpinsky;
	
	[self didPressMaze:nil];
	
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
- (IBAction)didPressHierarchy:(id)sender {
		[self.container bringSubviewToFront:self.view1.view];
}


- (IBAction)didPressSierpinsky:(id)sender {
	[self.container bringSubviewToFront:self.sierpinsky.view];
}



@end
