//
//  TodoCell.h
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/9/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface TodoCell : UITableViewCell

@property (strong, nonatomic) Todo *todo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
