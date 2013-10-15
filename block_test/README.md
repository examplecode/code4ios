# Ojbect C 中Block的一些知识点 #

## 基本的用法及 ##
```objective-c
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
```
## Block 引用外部的基本类型，传递值的情况##	

block在引用外部的基本类型时，仅仅是把当前的值，传递到block中，block并不能改变和影响外部的基本类型。 参看下面实例的运行结果
```objective-c
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
```
## Block 引用外部的基本类型，引用情况 ##
通过关键字"__block" 修饰基本类型时，block内部以引用的方式使用基本类型，此事block内部可以影响和改变外部的基本类型的值。参看下面示例运行情况

```objective-c
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
```
## 测试对象在block中的引用情况 ##
对于普通对象，被在栈中分配的block引用，retain不变，但是被在堆中分配的block引用会 retain +1 . ([block copy] 方法会使block在堆中分配) 参考下面的代码片段


```objective-c
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
```
## 对象在block中的引用情况，使用 __block 关键字 ##

如果使用 __block 关键字修饰被block引用的 对象，无论block在堆中分配还是在栈中分配，对象的 retain都不会改变。如下代码所示

```objective-c
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
```


