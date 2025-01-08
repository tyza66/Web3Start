pragma solidity 0.8.28; // 这里用于声明solidity版本号

import "solidity2.sol";          // 这里用于导入其他合约

// 这是一个注释

// 声明一个合约
contract Test{
    uint a; // 声明一个整型状态变量a
    function setA(uint x) public{
        a = x;
    }
}