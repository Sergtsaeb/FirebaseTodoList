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
@import WatchConnectivity;
#import "Todo.h"

@interface InterfaceController () <WKExtensionDelegate, WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;

@property(strong, nonatomic) NSArray<Todo *> *allTodos;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
        [self.titleLabel setText:context[@"title"]];
        [self.contentLabel setText:context[@"content"]];
    
    [self setupTable];
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
    [super willActivate];
    
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
    
    //The message parameter is where you would want to hand the ios app Todo data ro save to Firebase
    [[WCSession defaultSession] sendMessage:@{} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSArray *todoDictionaries = replyMessage[@"todos"];
        
        NSMutableArray *allTodos = [[NSMutableArray alloc] init];
        
        for (NSDictionary *todoObject in todoDictionaries) {
            Todo *newTodo = [[Todo alloc] init];
            newTodo.title = todoObject[@"title"];
            newTodo.content = todoObject[@"content"];
            //assign any other values here
            
            [allTodos addObject:newTodo];
            
        }
        self.allTodos = allTodos.copy;
        [self setupTable];
        
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didDeactivate {
    [super didDeactivate];
    
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSDictionary *todoDictionary = @{@"title": self.allTodos[rowIndex].title, @"content": self.allTodos[rowIndex].content};
    
    
    
    
}

- (IBAction)newTodoPressed {
    NSArray *suggestions = @[@"Sup", @"Homez", @"FreshPrince"];
    
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
    
}


@end



