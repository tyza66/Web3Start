pragma solidity 0.8.28; 

// 这里讲解一些本语言自带的全局变量和函数
// 他们可以理解为solidity自带的一些便捷函数
// 可以分为四类：有关区块和交易的、有关错误处理的、有关数字及加密功能的、有关地址和合约的

contract TestSelf {
    address addr = msg.sender; // 交易发送者的地址
    uint value = msg.value; // 是当前交易所附带的以太币
    address coinbase = block.coinbase; // 当前区块的地址
    uint difficulty = block.difficulty; // 当前区块的难度
    uint number = block.number; // 当前区块的编号/块号
    uint timestamp = block.timestamp; // 当前区块的时间戳 就是从1970年1月1日到现在的秒数
    uint _now = block.timestamp; // 当前区块的时间戳 同上 就算 上面那个的别名
    uint gasprice = tx.gasprice; // 当前交易的gas价格
}
