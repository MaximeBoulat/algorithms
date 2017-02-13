//
//  BinaryTree.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/12/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "BinaryTree.h"

@implementation BinaryTree

- (void) insertValue: (NSNumber *) value {
	
	TreeNode * node = [TreeNode new];
	node.value = value;
	
	
	if (!self.root) {
		self.root = node;
	}
	else {
		[self.root insertNode:node];
	}
}

@end


@implementation TreeNode

- (void) insertNode: (TreeNode *) node {
	if (node.value < self.value) {
		[self insertNodeOnLeftSide:node];
	}
	else {
		[self insertNodeOnRightSide:node];
	}
}

- (void) insertNodeOnLeftSide: (TreeNode *) node {
	if (self.leftChild) {
		[self.leftChild insertNode:node];
	}
	else {
		self.leftChild = node;
	}
}

- (void) insertNodeOnRightSide: (TreeNode *) node {
	if (self.rightChild) {
		[self.rightChild insertNode:node];
	}
	else {
		self.rightChild = node;
	}
}

@end

@implementation LinkedList


- (void) insertValue: (NSNumber *) value {
	
	if (!self.head) {
		
		LinkedListItem * head = [LinkedListItem new];
		head.value = value;
		self.head = head;
	}
	else {
		
		LinkedListItem * tail = self.head;
		
		while (tail.nextItem) {
			tail = tail.nextItem;
		}
		
		LinkedListItem * newTail = [LinkedListItem new];
		newTail.value = value;
		tail.nextItem = newTail;
	}
}


- (void) swapNodes {
	
	LinkedListItem * head = self.head.nextItem;
	
	[self swapNodesForNode:self.head];
	self.head = head;
	
}

- (void) swapNodesForNode: (LinkedListItem *) node {
	
	
	if (!node.nextItem) {
		return;
	}
	
	LinkedListItem * nextPair = node.nextItem.nextItem; // the begginning of the next pair
	
	node.nextItem.nextItem = node;
	if (nextPair.nextItem)
	{
		node.nextItem = nextPair.nextItem;
	}
	else {
		node.nextItem = nextPair;
	}

	[self swapNodesForNode:nextPair];
	
}

- (void) printList {
	
	[self.head printValue];
	
}


@end


@implementation LinkedListItem

- (void) printValue {
	
	printf ("%s\n", [[NSString stringWithFormat:@"%@ --> ", self.value] UTF8String]);
	[self.nextItem printValue];
	
}


@end
