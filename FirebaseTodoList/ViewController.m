//
//  ViewController.m
//  FirebaseTodoList
//
//  Created by Sergelenbaatar Tsogtbaatar on 5/8/17.
//  Copyright © 2017 Serg Tsogtbaatar. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewTodoViewController.h"

@import FirebaseAuth;
@import Firebase;

@interface ViewController ()

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentuser;

@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    NSLog(@"%@", segue.destinationViewController);
}

-(void)checkUserStatus {
    
    if (![[FIRAuth auth] currentUser]) {
        
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginController animated:YES completion:nil];
        
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
    }
    
}

-(void)setupFirebase {
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentuser = [[FIRAuth auth] currentUser];
    
    self.userReference = [[databaseReference child:@"users"] child:self.currentuser.uid];
    
    NSLog(@"The user reference yo: %@", self.userReference);
}

-(void)startMonitoringTodoUpdates {
    
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableArray *allTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            
            NSDictionary *todoData = child.value;
            
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            
            //for lab append new Todo to allTodos array
            [allTodos addObject: child];
            
            NSLog(@" TodoTtitle: %@ - Content: %@", todoTitle, todoContent);
        }
        
    }];
    
}

- (IBAction)logoutPressed:(id)sender {
    NSError *signoutError;
    [[FIRAuth auth] signOut: &signoutError];
    
    [self checkUserStatus];
}

- (IBAction)animateContainer:(id)sender {
    [self.containerView layoutIfNeeded];
    
    [UIView animateWithDuration:1.0 animations:^{
        // Make all constraint changes here
        
        
        self.heightConstraint = 0;
        
        [self.containerView layoutIfNeeded];
        
    }];
    

}



@end
