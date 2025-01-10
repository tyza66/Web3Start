pragma solidity 0.8.28; 

contract MyToken{

    mapping (address => uint256) public balanceOf; // 用于记录每个账户的代币余额

    // 构造函数中初始化代币总量（供应量）
    constructor(uint256 initSupply){
        balanceOf[msg.sender] = initSupply; // 初始化的时候创建者拥有所有的代币
    }

    // 代币接收者可以是合约地址，也可以是账户地址
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value); // 检查发送者的余额是否大于发送的代币数量
        require(balanceOf[_to] + _value >= balanceOf[_to]); // 检查溢出 如果数计算溢出了会比原来的值小
        balanceOf[msg.sender] -= _value; // 减少发送者的余额
        balanceOf[_to] += _value; // 增加接收者的余额 如果一个mapping中的地址没有被初始化，那么该地址对应的值会被视为零。当你对这个地址执行 += 操作时，就相当于在零的基础上进行增加
        return true;
    }
}
