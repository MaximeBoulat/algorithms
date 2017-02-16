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
    // Do any additional setup after loading the view.
	
	UIView * commonAncestor = [AlgorithmManagerSwift findCommonAncestorWithI:self.testView m:self.testView2];
	
	NSLog(@"Found common ancestor with tag: %li", commonAncestor.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
