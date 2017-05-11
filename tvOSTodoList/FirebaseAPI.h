//
//  FirebaseAPI.h
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/10/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

typedef void(^AllTodosCompletion)(NSArray<Todo *> *allTodos);

@interface FirebaseAPI : NSObject

+(void)fetchAllTodos:(AllTodosCompletion)completion;


@end
