//
//  SierpinskyViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/7/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "SierpinskyViewController.h"

@interface SierpinskyViewController ()

@end

@implementation SierpinskyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	
	[self addSubviewsToView:self.view];
	
}


- (void) addSubviewsToView: (UIView *)view {
	
	
	// base case
	
	if (view.frame.size.width < 1) {
		view.backgroundColor = [UIColor blueColor];
	}
	else {
		// first view
		
		CGRect rect = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height / 2);
		UIView * subview = [[UIView alloc]initWithFrame:rect];
		[view addSubview:subview];
		[self addSubviewsToView:subview];
		
		
		// second view
		
		rect = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height / 2);
		subview = [[UIView alloc]initWithFrame:rect];
		[view addSubview:subview];
		[self addSubviewsToView:subview];
		
		// third view
		
		rect = CGRectMake(view.frame.size.width / 2, view.frame.size.height / 2, view.frame.size.width / 2, view.frame.size.height / 2);
		subview = [[UIView alloc]initWithFrame:rect];
		[view addSubview:subview];
		[self addSubviewsToView:subview];
	}
}



@end
