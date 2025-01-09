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
    // 除以0或者进行负数移位的话会报错

    // 常量 又叫字面量 literals
    // 有四类常量：有理数和整数常量、字符串常量、十六进制常量、地址常量
    function testLiterals() public view returns(uint){
        // 直接写出来值就是常量（字面量）
        return 1 + 1.5e11; // 常量支持科学计数法 就是1.5*10^11
        // 常量是支持任意精度的
    }
    // memory是临时存储空间 用来存储函数的参数和局部变量
    // storage是永久存储空间 用来存储合约的状态变量
    // calldata是用来存储外部函数调用的参数
    function testStringLiterals() public view returns(string memory) {
        return "apple";     // 字符串常量隐性转换为字节数组
    }
    function testHexLiterals() public view returns(bytes2,bytes1,bytes1){
        bytes2 a = hex"abcd";
        bytes1 b = hex"ef";
        bytes1 c = hex"01";
        return (a,b,c);
    }
    function testAddressLiterals() public view returns(address){
        return 0x1234567890123456789012345678901234567890;
    }

    // 3.地址类型
    // 地址类型是一个20字节的值
    // 地址可以是外部账户地址 也可以是合约地址
    // 地址的属性和函数有balance、transfer、send、call、callcode、delegatecall
    // 见程序4
}

// 直接去remix单元测试、或者run里面运行就行了 之后去已部署的合约里面 之后看解码输出