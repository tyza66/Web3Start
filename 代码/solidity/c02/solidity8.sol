pragma solidity 0.8.28; 

// 本次介绍错误处理 也就是程序出现错误的时候的处理方式
// solidity是使用回退状态来处理错误的
// solidity中没有try catch finally这种结构 在发生异常的时候会回退所有的状态 包含一些子调用所发生的一些状态变化
// 单个错误发生的时候就像任何事情没有发生一样
// 我们可以把区块链看作是一个分布式事务类型的数据库 将这个错误机制看错是一个事务回滚的机制

// solidity中的错误处理 提供了两种方式
// 分别为assert和require 这两个函数就是用来处理错误的
// assert通常用来检查函数内部错误 require通常用来检查用户输入或者外部合约的错误

// 异常发生的时候异常也会向上冒泡

// 比如一个数字除以0了报的异常就是assert类型的异常
// 一个用户输入了一个错误的地址就会报require类型的异常

contract Sharer {
    // 将合约的余额平分给两个地址
    // msg.value 表示的是在调用 sendHalf 函数时传递给合约的以太币数量
    function sendHalf(address payable addr) public payable returns (uint balance) {
        require(msg.value % 2 == 0, "Even value required");     // 如果这个智能合约附加的余额是奇数的话就会报错
        uint balanceBeforeTransfer = address(this).balance;     // 获取转账前合约的余额
        addr.transfer(msg.value / 2); // 将一半的余额转给addr
        // 这里的assert是用来检查合约内部错误的 this.balance是合约的余额 balanceBeforeTransfer是转账之前的余额 msg.value是转账的金额
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // 检查转账之后合约的余额是否正确 就是为了检查之前执行的逻辑有没有错误
        return address(this).balance;
    }
    // 当执行方法的时候币会先添加2到合约的余额中 然后再转账 也就是说一开始address(this).balance就会变成2，而msg.value是本次携带的金额，始终是2 转走msg.value的一半之后address(this).balance剩余1
    // 第二次执行的时候原本合约余额是1，又携带了4（当前原始余额是5），转走4的一半的时候合约里面原本的1加上这次又剩下的一半2，合约中剩下3 这时判断条件里面原始余额5减去这次携带的一半2得到3 所以不会报错
}