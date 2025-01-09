pragma solidity 0.8.28;         // 这里用于声明solidity版本号

import "solidity2.sol";          // 这里用于导入其他合约

// 这是一个注释

// 声明一个合约
contract Test{
    uint a; // 声明一个整型状态变量a

    // 声明一个函数
    function setA(uint x) public{
        a = x;
        emit Set_A(a); // 触发事件
    }

    // 声明一个事件 事件可以用来被监听 在方法被调用的时候可以用Web3.js监听到
    event Set_A(uint a);

    // 声明一个结构体 相当于自己定义一个数据类型
    struct Position{
        uint x;
        uint y;
    }

    // 声明一个address 类型的变量
    address owenerAddr;

    // 定义函数修改器 它可以修改一个函数的行为
    modifier owner(){
        // 限制发送请求的地址和owenerAddr的地址相同
        require(msg.sender == owenerAddr);
        _;    // 这个是一个占位符 表示执行函数的代码 相当于wrapper部分
    }

    // 声明一个函数 只有owner才能调用
    function mine() public owner{
        a += 1;
    }

}