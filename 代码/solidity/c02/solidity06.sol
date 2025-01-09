pragma solidity 0.8.28; 

contract TestStruct{

    // 2. 结构体
    struct Position{
        uint x;
        uint y;
    }

    function testPosition() public pure returns(Position memory){
        Position memory p1 = Position({x:1,y:2});
        Position memory p2 = Position(3,4);
        return p1;
    }

    struct Funder{
        address addr;
        uint amount;
    }

    Funder funder; // 状态变量

    function newFunder() public{
        funder = Funder({addr:msg.sender,amount:10});
    }

    // 3.映射类型 mapping
    // 是键值对 可以理解为哈希表 是没有长度的
    // 在这里没有键集合和值集合的概念
    // 映射类型只能用作状态变量
    mapping(address => uint) public balances; // 这里定义为地址映射到整数

    function updateBalance(uint newBalance) public{
        balances[msg.sender] = newBalance;
    }

    // 没办法遍历所有地址或者所有制 如果想遍历只能用其他方案变通的进行遍历
}