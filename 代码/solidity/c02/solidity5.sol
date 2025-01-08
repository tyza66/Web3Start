pragma solidity 0.8.28; 
// 引用类型通常要考虑到占用空间的问题
// 引用类型通常占用的空间要超过256位
// 要考虑到数据存储位置问题
// 有两种数据存储的类型：memory和storage
// memory内存是临时存储空间 用来存储函数的参数和局部变量
// storage永久存储空间 用来存储合约的状态变量 数据永久存储在区块链中
// 大多数数据存储的位置是有默认值的 我们可以用memory和storage改变这个默认值

// 函数的参数函数的返回值默认是memory 我们可以用storage改变这个默认值
// 复杂变量和状态变量默认都是storage
// storage的gas开销远大于memory

contract ArrarTest{
    // 1. 数组
    // 数组长度可以固定也可以动态
    // bytes和string是特殊的数组类型
    // string可以转为bytes，bytes类似于byte[]，但是长度是固定的
    // 数组常见的属性和方法有length、push、pop、slice、splice、concat、reverse、sort
    uint[] public u = [1,2,3,4,5]; // 变长度数组 放入IDE中后会自动生成访问器 下标也是从0开始

}