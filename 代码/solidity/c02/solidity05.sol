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
    string s = "abcdefg";

    function h() public returns(uint){
        u.push(4);
        return u.length;
    }

    function f() public view returns(bytes1){
        return  bytes(s)[1];
        // 字母 b 的 ASCII 码是 98。将其转换为十六进制表示形式就是 0x62
    }

    // 动态创建一个memory数组
    function newM(uint len) public view returns(uint){
        uint[] memory a = new uint[](len); // 填多少就开辟多大 下标还是从0开始
        // 这个length是不会被赋值的方法更改的 但是状态变量u就可以

        // 我们给的长度一定要够 不能给超出数组长度的位置的值
        bytes memory b = new bytes(len);
        a[6] = 8;

        g([uint(1),2,3]);
        return a.length;
    }

    // 数组作为参数 接收三个元素的数组 传参不能传错
    function g(uint[3] memory _data) public view returns(uint){
        return _data.length;
    }
}