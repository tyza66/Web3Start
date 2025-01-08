pragma solidity 0.8.28; 

// solidity是静态类型语言 所以需要声明变量的类型
// 值类型都是拷贝传递 引用类型是引用传递

contract Test{
    // 1. 布尔类型
    // 跟其他语言差不多 也可以用来做逻辑判断
    bool flag = true;
    bool flag2 = false;

    function testBool() public view returns(bool){
        return !(flag && flag2);
    }

    function testBoo2() public view returns(bool){
        return flag || flag2;
    }

    // 2. 整数类型
    // 关键字 从uint8到uint256 以8为步长 从int8到int256 以8为步长
    // 数字表示的是位数 数字默认都是256位
    // 运算符也是跟其他语言一样分为比较运算符、位运算符、算术运算符
    int a = 1;
    int b = 2;
    // constant 表示函数不会修改状态变量的值
    // 自Solidity 0.4.17版本开始，constant 修饰符不能再用于函数了，它只能用于状态变量。对于函数来说，类似的行为是用 view 或 pure 关键字来表示。
    // view 表示函数不会修改状态变量的值
    // pure 表示函数不会修改状态变量的值 也不会读取状态变量的值
    function add() public view returns(int){
        if(b > a){
            return b - a;
        }
        else if(b < a){
            return a - b;
        }else{
            return a * b;
        }
    }
}

// 直接去remix单元测试、或者run里面运行就行了 之后去已部署的合约里面 之后看解码输出