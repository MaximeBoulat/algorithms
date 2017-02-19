//
//  ViewHierarchyViewController.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/13/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubviewSelectionProtocol <NSObject>

-(void) didMakeSelectionWithStack: (NSArray *) stack;

@end

@interface ViewHierarchyViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * selectionStack;
@property (nonatomic, assign) id <SubviewSelectionProtocol> delegate;
@property (nonatomic, strong) UIView * commonSuperview;

@end

@interface BorderedView : UIView

@end
