//
//  ViewController.m
//  MultThreadDemo
//
//  Created by Demon_Yao on 9/5/15.
//  Copyright (c) 2015 Tyrone Zhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     NSLog(@"************************ syncronization ********************");
     [self syncronizedTaskInSerialQueue];
     [self syncronizedTaskInConcurrentQueue];
     
     NSLog(@"************************ asyncronization ********************");
     [self asyncronizedTaskInSerialQueue];
     [self asyncronizedTaskInConcurrentQueue];
     */
    
    
    //    [self dispatchGroupTask];
    
    
    /*
     [self asyncronizedDispatchBarrierWithConcurrentQueue];
     */
    
    
    //    [self defaultInocationOperation];
    
    //    [self defaultBlockOperation];
    
    //    [self blockOperationInSelfCreatedQueue];
    //
    //    [self blockOperationInOtherQueue];
    
    //    [self moreThanOneBlockOperationInOtherQueue];
    
    //    [self addDependencesBlockOperationsInOtherQueue];
    
    [self dispatchSemaphore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark - calculate from 0 to 100.

- (NSUInteger)calculateShortTime
{
    NSInteger result = 0;
    for (NSInteger i = 1; i <= 1; i++) {
        result += i;
    }
    
    return result;
}

#pragma makr - calculate from 0 to 10000.

- (NSUInteger)calculateLongTime
{
    NSInteger result = 0;
    for (NSInteger i = 1; i <= 1000000; i++) {
        result += i;
    }
    
    return result;
}

#pragma mark - syncornized tasks in a serail queue.
- (void)syncronizedTaskInSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("serialQueueWithSyncronizedTask", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\nserial - syn - long - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    dispatch_sync(queue, ^{
        NSUInteger result = [weakSelf calculateShortTime];
        NSLog(@"%@\nserial - syn - short - %lu",[NSThread currentThread],(unsigned long)result);
    });
}

#pragma mark - syncornized tasks in a concurrent queue.
- (void)syncronizedTaskInConcurrentQueue
{
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueueWithSyncronizedTask", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\nconcurrent - syn - long - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    dispatch_sync(queue, ^{
        NSUInteger result = [weakSelf calculateShortTime];
        NSLog(@"%@\nconcurrent - syn - short - %lu",[NSThread currentThread],(unsigned long)result);
    });
}

#pragma mark - asyncronized task in serial queue.

- (void)asyncronizedTaskInSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("serialQueueWithAsyncronizedTask", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\nserial - asyn - long - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    dispatch_async(queue, ^{
        NSUInteger result = [weakSelf calculateShortTime];
        NSLog(@"%@\nserial - asyn - short - %lu",[NSThread currentThread],(unsigned long)result);
    });
}

#pragma mark - asyncronized task in concurrent queue.

- (void)asyncronizedTaskInConcurrentQueue
{
    dispatch_queue_t queue = dispatch_queue_create("ConcurrentQueueWithAsyncronizedTask", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\nconcurrent - asyn - long - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    dispatch_async(queue, ^{
        NSUInteger result = [weakSelf calculateShortTime];
        NSLog(@"%@\nconcurrent - asyn - short - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    NSLog(@"end thread - %@",[NSThread currentThread]);
}


#pragma makr -
#pragma mark - Block issues.

- (void)blockMainThread
{
    NSLog(@"之前 - %@", [NSThread currentThread]);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"sync - %@", [NSThread currentThread]);
    });
    
    NSLog(@"之后 - %@", [NSThread currentThread]);
}

- (void)blockSelfSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"之前 － %@",[NSThread currentThread]);
    
    dispatch_async(queue, ^{
        
        NSLog(@"sync之前 － %@",[NSThread currentThread]);
        
        dispatch_sync(queue, ^{
            NSLog(@"sync - %@",[NSThread currentThread]);
        });
        
        NSLog(@"sync之后 - %@",[NSThread currentThread]);
        
    });
    
    NSLog(@"之后 － %@",[NSThread currentThread]);
}

#pragma mark -
#pragma mark - dispatch_group

- (void)dispatchGroupTask
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group - 01 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group - 02 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group - 03 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"finished all group tasks - %@",[NSThread currentThread]);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"========");
}

- (void)dispatchSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"before wait - %@",[NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"wait - %@",[NSThread currentThread]);
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"signal - %@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    NSLog(@"===");
}

#pragma mark -
#pragma mark - dispatch_barrier

- (void)doSomeAsyncronizedTaskInQueue:(dispatch_queue_t)queue
{
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group - 01 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group - 02 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group - 03 - %@",[NSThread currentThread]);
        }
    });
}

- (void)syncronizedDispatchBarrierWithSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("com.syncro.barrier.serial", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    [self doSomeAsyncronizedTaskInQueue:queue];
    
    dispatch_barrier_sync(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\n syncro - barrier - serial - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    [self doSomeAsyncronizedTaskInQueue:queue];
}

- (void)syncronizedDispatchBarrierWithConcurrentQueue
{
    dispatch_queue_t queue = dispatch_queue_create("com.syncro.barrier.serial", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(self) weakSelf = self;
    
    [self doSomeAsyncronizedTaskInQueue:queue];
    
    dispatch_barrier_sync(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\n syncro - barrier - concurrent - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    [self doSomeAsyncronizedTaskInQueue:queue];
}

- (void)asyncronizedDispatchBarrierWithSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("com.syncro.barrier.serial", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    [self doSomeAsyncronizedTaskInQueue:queue];
    
    dispatch_barrier_async(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\n asyncro - barrier - serial - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    [self doSomeAsyncronizedTaskInQueue:queue];
}

- (void)asyncronizedDispatchBarrierWithConcurrentQueue
{
    dispatch_queue_t queue = dispatch_queue_create("com.syncro.barrier.serial", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(self) weakSelf = self;
    
    [self doSomeAsyncronizedTaskInQueue:queue];
    
    dispatch_barrier_async(queue, ^{
        NSUInteger result = [weakSelf calculateLongTime];
        NSLog(@"%@\n asyncro - barrier - concurrent - %lu",[NSThread currentThread],(unsigned long)result);
    });
    
    [self doSomeAsyncronizedTaskInQueue:queue];
}

#pragma mark -
#pragma mark - NSInvocaitonOperation

// default syncronization & current thread
- (void)defaultInocationOperation
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationContent) object:nil];
    [operation start];
    
    NSLog(@"current thread - %@",[NSThread currentThread]);
}

#pragma mark - NSBlcokOperation

// default syncronization & current thread (addExecutionBlock will make the operation to be dispatch_barrier_asyn )
- (void)defaultBlockOperation
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self operationContent];
    }];
    
    for (int i = 0; i < 3; i++) {
        [operation addExecutionBlock:^{
            if (i == 0) {
                [NSThread sleepForTimeInterval:1.];
            }
            
            NSLog(@"execution block %d - %@",i, [NSThread currentThread]);
        }];
    }
    [operation start];
    
    NSLog(@" end thread 2 - %@",[NSThread currentThread]);
}

- (void)blockOperationInSelfCreatedQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self operationContent];
    }];
    
    for (int i = 0; i < 3; i++) {
        [operation addExecutionBlock:^{
            [NSThread sleepForTimeInterval:1.];
            NSLog(@"execution block %d - %@",i, [NSThread currentThread]);
        }];
    }
    
    [queue addOperation:operation];
    
    NSLog(@" end thread 3 - %@",[NSThread currentThread]);
}

- (void)blockOperationInOtherQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    for (int i = 0; i < 3; i++) {
        [queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1.];
            NSLog(@"operation block %d - %@",i, [NSThread currentThread]);
        }];
    }
    
    NSLog(@" end thread 4 - %@",[NSThread currentThread]);
}

- (void)moreThanOneBlockOperationInOtherQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 1 - %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 2 - %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 3 - %@", [NSThread currentThread]);
    }];
    
    //    [queue addOperation:operation1];
    //    [queue addOperation:operation2];
    //    [queue addOperation:operation3];
    
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:YES];
    
    NSLog(@"end thread 5 - %@",[NSThread currentThread]);
}

- (void)addDependencesBlockOperationsInOtherQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 1 - %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 2 - %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.];
        NSLog(@"operation 3 - %@", [NSThread currentThread]);
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
    
    NSLog(@"end thread 5 - %@",[NSThread currentThread]);
}

#pragma mark - operation queue




- (void)operationContent
{
    NSLog(@"operation - %@",[NSThread currentThread]);
}

@end
