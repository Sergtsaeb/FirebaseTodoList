//
//  InterfaceController.m
//  WatchKitTodoList Extension
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/9/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import "InterfaceController.h"
#import "TodoRowController.h"
#import "Todo.h"
@import WatchKit;

#import "Todo.h"

@interface InterfaceController () <WKExtensionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;

@property(strong, nonatomic) NSArray<Todo *> *allTodos;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self setupTable];

    // Configure interface objects here.
}

-(NSArray<Todo *> *)allTodos {
    Todo *firstTodo = [[Todo alloc] init];
    firstTodo.title = @"First Todo";
    firstTodo.content = @"This is a todo.";
    
    Todo *secondTodo = [[Todo alloc] init];
    secondTodo.title = @"Second Todo";
    secondTodo.content = @"This is a todo.";
    
    Todo *thirdTodo = [[Todo alloc] init];
    thirdTodo.title = @"Third Todo";
    thirdTodo.content = @"This is a todo.";
    
    return @[firstTodo, secondTodo, thirdTodo];
    
}

-(void) setupTable {
    [self.table setNumberOfRows:self.allTodos.count withRowType:@"TodoRowController"];
    
    for (NSInteger i = 0; i < self.allTodos.count; i++) {
        
        TodoRowController *rowController = [self.table rowControllerAtIndex:i];
        
        [rowController.titleLabel setText:self.allTodos[i].title];
        [rowController.contentLabel setText:self.allTodos[i].content];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
//    NSDictionary *currentTodo = @"%@", self.allTodos[indexPath].title
    
    
}

- (IBAction)newTodoPressed {
    NSArray *suggestions = @[@"Sup", @"Homez", @"FreshPrince"];
    
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
    
}


@end



