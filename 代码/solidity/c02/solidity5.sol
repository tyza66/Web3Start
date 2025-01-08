pragma solidity 0.8.28; 
// 引用类型通常要考虑到占用空间的问题
// 引用类型通常占用的空间要超过256位
// 要考虑到数据存储位置问题
// 有两种数据存储的类型：memory和storage
// memory内存是临时存储空间 用来存储函数的参数和局部变量
// storage永久存储空间 用来存储合约的状态变量 数据永久存储在区块链中