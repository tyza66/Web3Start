pragma solidity 0.8.28; 

// 本次介绍错误处理 也就是程序出现错误的时候的处理方式
// solidity是使用回退状态来处理错误的
// solidity中没有try catch finally这种结构 在发生异常的时候会回退所有的状态 包含一些子调用所发生的一些状态变化
// 单个错误发生的时候就像任何事情没有发生一样
// 我们可以把区块链看作是一个分布式事务类型的数据库 将这个错误机制看错是一个事务回滚的机制