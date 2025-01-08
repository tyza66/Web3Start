pragma solidity 0.8.28; 

// solidity是静态类型语言 所以需要声明变量的类型
// 值类型都是拷贝传递 引用类型是引用传递

contract Test{
    // 1. 布尔类型
    // 跟其他语言差不多 也可以用来做逻辑判断
    bool flag = true;
    bool flag2 = false;

    function testBool() public returns(bool){
        return flag && flag2;
    }

    function testBoo2() public returns(bool){
        return flag || flag2;
    }

    // 2. 整数类型
    // 关键字 从uint8到uint256 以8为步长 从int8到int256 以8为步长
    // 数字表示的是位数 数字默认都是256位
    // 运算符也是跟其他语言一样分为比较运算符、位运算符、算术运算符
    int a = 1;
    int b = 2;
    // constant 表示函数不会修改状态变量的值
    func add() public constant returns(int){
        if(b > a){
            return b - a;
        else if(b < a){
            return a - b;
        }else{
            return a * b;
        }
    }
}