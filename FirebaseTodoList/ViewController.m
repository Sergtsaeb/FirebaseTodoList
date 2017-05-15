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
#import "Todo.h"
#import "TodoCell.h"

@import FirebaseAuth;
@import Firebase;

static CGFloat const kClosedConstraint = 0.0;
static CGFloat const kOpenConstraint = 150.0;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentuser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property(strong, nonatomic) NSMutableArray *allTodos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = true;
    self.allTodos = _allTodos;
    
    self.heightConstraint.constant = kClosedConstraint;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
    [self setupFirebase];
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
        
        self.allTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            
            Todo *currentTodo = [[Todo alloc]init];
            currentTodo.title = todoTitle;
            currentTodo.content = todoContent;
            
            NSLog(@" TodoTtitle: %@ - Content: %@", todoTitle, todoContent);
            [self.allTodos addObject: currentTodo];
            [self.tableView reloadData];
        }
    }];
    
}

- (IBAction)logoutPressed:(id)sender {
    NSError *signoutError;
    [[FIRAuth auth] signOut: &signoutError];
    
    [self.allTodos removeAllObjects];
    [self checkUserStatus];
    [self.tableView reloadData];
}

- (IBAction)animateContainer:(id)sender {
    if (self.heightConstraint.constant == kOpenConstraint) {
        self.heightConstraint.constant = kClosedConstraint;
    } else {
        self.heightConstraint.constant = kOpenConstraint;
    }
    
    [UIView animateWithDuration: 1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allTodos count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    cell.titleLabel.text = currentTodo.title;
    cell.contentLabel.text = currentTodo.content;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_allTodos removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}


@end
