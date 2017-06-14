//
//  FirebaseAPI.m
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/10/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import "FirebaseAPI.h"
#import "Credentials.h"

@implementation FirebaseAPI

+(void)fetchAllTodos:(AllTodosCompletion)completion {
    
    NSString *urlString = [NSString stringWithFormat:@"https://fir-todolist-abbde.firebaseio.com/users.json?auth=%@", APP_KEY];
    
    NSURL *databaseURL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:databaseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"ROO OBJECT: %@", rootObject);
        
        NSMutableArray *allTodos = [[NSMutableArray alloc] init];
        
        for (NSDictionary *userTodosDictionary in [rootObject allValues]) {
            NSArray *userTodos = [userTodosDictionary[@"todos"] allValues];
            
            NSLog(@"%@", userTodos);
            
            for (NSDictionary *todoDictionary in userTodos) {
                
                Todo *newTodo = [[Todo alloc]init];
                newTodo.title = todoDictionary[@"title"];
                newTodo.content = todoDictionary[@"content"];
                
                //assign other todo properties here..
                
                [allTodos addObject:newTodo];
                
                
            }
            
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(allTodos);
            });
            
        }
       
    }] resume];
    
}

@end
