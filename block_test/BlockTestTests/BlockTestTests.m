//
//  BlockTestTests.m
//  BlockTestTests
//
//  Created by chengkai on 13-3-8.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "BlockTestTests.h"

@implementation BlockTestTests

typedef  void (^MyBlock) (void);


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//定义一个函数参数类型为block (返回值为整形，参数类型为整形的block)
void my_fun(int (^myblock) (int)) {
    
    NSLog(@"===== myblock(8) = %d ======",myblock(8));
}



//block 的基本用法
- (void)testBlockExample
{
    //执行一个匿名block
    int val1 = ^(int a) { return a*a; } (5);
   
    //定义一个block变量，类似于函数指针
    int(^square) (int);
    square = ^(int a ) {return a*a ;};
        
    int val2 =square(6);
    
    NSLog(@"====  val1 = %d ======",val1);
    NSLog(@"====  val2 = %d ======",val2);
    
    my_fun(square);
    
   NSLog(@"====  square retain]= %d ======",[square retainCount]);
    
}

//block初始化的时候引用基本类型的话，只是传递基本的值而已，最终和block外部基本类型没有任何关系。
- (void)testBlockExample2
{
    int myval = 10;
    
    //这时候初始化block对象，其实是把myval的值传过来
    void (^fun)(void)= ^(void) {
        
        NSLog(@"==== testBlockExample2 myval = %d ======",myval +5);
               
    };
    //在调用之前改变myval的值
    myval = 20;
    //函数输出15,而不是25.
    fun();
    
}

//使用 __block 修饰变量则是以引用的方式传递,可以在block内部改变其值
- (void)testBlockExample3
{
    __block int myval = 10;
    
    //这时候初始化block对象，其实是把myval的值传过来
    void (^fun)(void)= ^(void) {
        
        NSLog(@"==== testBlockExample3： myval = %d ======",myval +5);
        
        //在block内部改变myval的值
        myval ++;
        
    };
    //在调用之前改变myval的值
    myval = 20;
    //函数输出25
    fun();
    
    //myval = 21
    NSLog(@"==== testBlockExample3： myval = %d ======",myval);
    
}


//测试一个对象在Block中引用情况
- (void)testBlockExample4
{
    NSObject * obj = [[NSObject alloc] init];
    
    NSLog(@"====  obj id: %d retain]= %d ======",obj.hash,[obj retainCount]);
    
    void (^myblock) (void) = ^(void) {
         NSLog(@"==== [in block] obj id: %d retain]= %d ======",obj.hash,[obj retainCount]);

     } ;
    
    myblock();
    
    //使用copy 使block的内存分配在堆上
    void (^myblock1) (void) = [myblock copy];
    
    //分配在堆上的block对对象的引用，会使retain +1 
    myblock1();
    

}


//使用 __block关键字 声明的的对象在block中引用 retain不会改变。
- (void)testBlockExample5
{
    __block NSObject * obj = [[NSObject alloc] init];
    
    NSLog(@"====  obj id: %d retain]= %d ======",obj.hash,[obj retainCount]);
    
    void (^myblock) (void) = ^(void) {
        NSLog(@"==== [in block] obj id: %d retain]= %d ======",obj.hash,[obj retainCount]);
        
    } ;
    
    myblock();
    
    //使用copy 使block的内存分配在堆上
    void (^myblock1) (void) = [myblock copy];
    
    //使用 __block 关键字声明的对象 retain 不会改变
    myblock1();
    
    
}

MyBlock genMyBlock() {
    int val = 10;
    MyBlock block = ^(void) {
        NSLog(@"val = %d",val);
    };
    
     NSLog(@"block hash = %d",[block hash]);
    return block;
}

- (void)testBlockExample6
{
    MyBlock block = genMyBlock();
    block();
    NSLog(@"block hash %d  block retain %d",[block hash],[block retainCount] );
}




@end
