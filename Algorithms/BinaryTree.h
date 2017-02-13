//
//  BinaryTree.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/12/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode : NSObject

@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, strong) TreeNode * leftChild;
@property (nonatomic, strong) TreeNode * rightChild;

- (void) insertNode: (TreeNode *) node;

@end

@interface BinaryTree : NSObject

@property (nonatomic, strong) TreeNode * root;

- (void) insertValue: (NSNumber *) value;

@end

@interface LinkedListItem : NSObject

@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, strong) LinkedListItem * nextItem;

- (void) printValue;

@end

@interface LinkedList : NSObject

@property (nonatomic, strong) LinkedListItem * head;

- (void) insertValue: (NSNumber *) value;
- (void) swapNodes;
- (void) printList;

@end

