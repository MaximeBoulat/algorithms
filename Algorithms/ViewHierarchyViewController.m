//
//  ViewHierarchyViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/13/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "ViewHierarchyViewController.h"
#import "Algorithms-Swift.h"

@interface ViewHierarchyViewController ()

@end

@implementation ViewHierarchyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
		
	self.selectionStack = [NSMutableArray new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didSelectView:(UITapGestureRecognizer *)sender {
	
	if (self.commonSuperview) {
		self.commonSuperview.layer.borderColor = [UIColor blackColor].CGColor;
		self.commonSuperview = nil;
	}
	
	if (self.selectionStack.count == 2) {
		for (UIView * view in self.selectionStack) {
			view.layer.borderColor = [UIColor blackColor].CGColor;
		}
		[self.selectionStack removeAllObjects];
	}
	else {
		UIView * selection = sender.view;
		if (!self.selectionStack.count || selection != self.selectionStack[0]) {
			selection.layer.borderColor = [UIColor redColor].CGColor;
			[self.selectionStack addObject:selection];
		}
	}
	
	[self.delegate didMakeSelectionWithStack:self.selectionStack];
	
}


@end

@implementation BorderedView

-(void) layoutSubviews {
	[super layoutSubviews];

	self.layer.borderWidth = 2;
	self.layer.borderColor = [UIColor blackColor].CGColor;
}

@end


