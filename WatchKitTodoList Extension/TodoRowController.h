//
//  TodoRowController.h
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/9/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface TodoRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@end
