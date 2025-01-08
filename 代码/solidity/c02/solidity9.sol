pragma solidity 0.8.28; 

// 这一讲来说一下函数的参数
// 输入参数、输出参数、命名参数、参数解构

contract Test {
    // 1. 输入参数
    // 输入参数就是在函数的括号里面定义的参数
    // 这里的参数是一个uint类型的参数
    // 这个参数是一个输入参数
    // 2. 输出参数
    // 输出参数就是在函数的括号后面定义的参数
    // 这里的参数是一个uint类型的参数
    // 我们给这个参数取了一个名字叫sum
    function add(uint a,uint b) public pure returns (uint sum){
        // 这里的_num就是输入参数
        return a + b;
    }

    // 3. 命名参数
    function testSimpleInput() public pure returns (uint sum){
        sum = add({a:1,b:3}); 
        return sum;
    }

    // 4. 参数解构
    // 这个函数有两个返回值
    function towReturn() public pure returns (uint sum,uint product){
        sum = 1;
        product = 2;
        return (sum,product);
    }
    // 我们在接收有两个返回值的函数的返回值的时候可以同时用两个变量来接收
    function testTowReturn() public pure returns (uint sum,uint product){
        (sum,product) = towReturn(); // 在这里就是一种解构
        return (sum,product);
    }

    // 这个方法返回三个含有不同类型的参数
    function threeReturn() public pure returns (uint sum,string memory name,uint flag){
        sum = 1;
        name = "hello";
        flag = 2;
        return (sum,name,flag);
    }
    // 我们可以用var关键字来接收多个返回值
    function testThreeReturn() public pure returns (uint sum,string memory name,uint flag){
        (sum,name,flag) = threeReturn();
        uint y;
        uint z;
        (y,,z) = threeReturn(); // 我们可以用逗号来忽略某个返回值或者忽略元组中的返回值
        uint x;
        (x,) = (3,4);
        (sum,flag) = (flag,sum); //我们还可以利用解构来交换两个变量的值
        return (sum,name,flag);
    }
}