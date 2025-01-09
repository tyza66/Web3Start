pragma solidity 0.8.28; 
// 可见性
// 可见性是指函数或状态变量可以被外部调用的方式
// 可见性有四种：public、private
// public：可以通过内部和消息的的方式调用 对于public状态变量会自动创建一个访问器
// private：只能在当前合约中调用 在继承的合约和外部合约中都不能调用
// 默认是默认的权限修饰符是 public
// 除此之外还有internal和external
// internal：只能内部访问或继承合约中访问
// external：只能消息调用 外部合约调用

contract Test {
    uint public a = 1;
    uint private b = 2;

    function test() public view returns(uint){
        return a;
    }

    function test2() public view returns(uint){
        return b;
    }

    function test3() external {
        this.test(); // 在内部可以通过代码跳转也可以通过消息调用 this就是通过消息调用
        uint data = a;
    }

    function test4() internal {
        uint data = a;
    }

    function testE() public{
        // test3();         // 报错
    }


    function testI() public{
        test4();        
    }
}


// 编写另外一个合约 用于调用其中的public和external函数

contract Test2 {
    Test test = new Test();

    function readData() public{
        Test test = new Test();     // 先创建合约
        test.test();                // 调用public函数
        test.test3();               // 调用external函数
    }

}

// 写一个合约继承Test合约 通过is关键字继承 继承类中只能访问public和internal函数和状态变量
contract Test3 is Test {
    function test5() public {
        uint c = a;     // 可以调用public成员
        test4();        // 可以调用internal函数
    }

    function test6() public {
        // uint d = b;     // 报错 b是private的
        // test3();        // 报错
    }
}