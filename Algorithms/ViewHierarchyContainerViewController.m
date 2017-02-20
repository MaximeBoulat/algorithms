//
//  ViewHierarchyContainerViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/18/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "ViewHierarchyContainerViewController.h"
#import "ViewHierarchyViewController.h"
#import "AlgorithmManager.h"

@interface ViewHierarchyContainerViewController () <SubviewSelectionProtocol>

@property (nonatomic, strong) ViewHierarchyViewController * viewController;
@property (weak, nonatomic) IBOutlet UIButton *findCommonSuperviewButton;
@property (weak, nonatomic) IBOutlet UIButton *pushCloneButton;

@end 

@implementation ViewHierarchyContainerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.pushCloneButton.hidden = YES;
	self.findCommonSuperviewButton.hidden = YES;
	
	if (self.navigationController.viewControllers[0] == self) {
		self.title = @"View selection";	}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString: @"Containment"]) {
		ViewHierarchyViewController * vc = (ViewHierarchyViewController *) segue.destinationViewController;
		self.viewController = vc;
		vc.delegate = self;
	}
	else {
		
		NSMutableArray * path = [NSMutableArray new];
		
		UIView * subview = self.viewController.selectionStack[0];
		UIView * superView = subview.superview;
		
		while (superView != self.viewController.view.superview) {
			NSInteger index = [superView.subviews indexOfObject:subview];
			[path insertObject:@(index) atIndex:0];
			subview = superView;
			superView = superView.superview;
		}
		
		UIViewController * destination = segue.destinationViewController;
		NSArray * subviews = destination.view.subviews;
		UIView * target;
		
		while (path.count) {
			NSNumber * index = path[0];
			[path removeObjectAtIndex:0];
			target = subviews[index.integerValue];
			subviews = target.subviews;
		}
	
		target.backgroundColor = [UIColor redColor];
		destination.view.userInteractionEnabled = NO;
		
	}

}

#pragma mark - SubviewSelectionProtocol

-(void) didMakeSelectionWithStack: (NSArray *) stack {
	
	if (stack.count == 1) {
		self.pushCloneButton.hidden = NO;
		self.findCommonSuperviewButton.hidden = YES;
	}
	else if (stack.count == 2) {
		self.pushCloneButton.hidden = YES;
		self.findCommonSuperviewButton.hidden = NO;
	}
	else {
		self.pushCloneButton.hidden = YES;
		self.findCommonSuperviewButton.hidden = YES;
	}
	
}

#pragma mark - Actions

- (IBAction)didPressFindCommonSuperview:(id)sender {
	
	
	UIView * view1 = self.viewController.selectionStack[0];
	UIView * view2 = self.viewController.selectionStack[1];
	
	self.viewController.commonSuperview = [AlgorithmManager findNearestCommonAncestor:view1 and:view2];
	
	self.viewController.commonSuperview.layer.borderColor = [UIColor blueColor].CGColor;
	
}

- (IBAction)didPressPushClone:(id)sender {
}



@end
