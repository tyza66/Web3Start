pragma solidity 0.8.28; 
// 函数
// 函数是合约中的一个重要部分
// 函数分为构造函数、视图函数、纯函数、接收函数、回退函数
// 构造函数：合约创建时自动执行的函数 一个合约只能有一个构造函数
// 视图函数：不会修改合约状态的函数 也不会消耗gas
// 纯函数：不会修改合约状态的函数 也不会消耗gas （既不会读取状态变量也不会修改状态变量）
// 接收函数：接收以太币的函数
// 回退函数：没有函数名的函数 用于接收以太币

contract Test {
    uint internal data;
    constructor(uint a){
        // 构造函数
        data = a;
    }

    event EventA(uint a);

    function testView() public view returns (uint){
        // data = 1; // 报错,因为视图函数不允许修改状态变量
        // emit EventA(1); //在视图函数中触发事件也会被视为修改状态
        return data;
    }

    function testPure() public pure returns (uint){
        // data = 1; // 报错,因为纯函数不允许修改状态变量
        // emit EventA(1); //在纯函数中触发事件也会被视为修改状态
        int a = 1; // 只能执行一些本地的运算
        return 1;
    }

    // 回退函数没有函数名
    // 当这个合约接收到以太币时会必须定义这个无名函数
    // 新版中已经变为fallback函数和receive函数

    // 接收纯以太币转账的 receive 函数 
    // 当合约接收纯以太币转账（不包含任何数据）时，receive 函数会被触发
    receive() external payable { 
        // 处理纯以太币转账 
    } 
    // 处理调用不存在的函数或包含数据的以太币转账的 fallback 函数 
    // 合约如果想接收以太币，必须定义一个 fallback 函数或 receive 函数
    // 当调用不存在的函数或接收到包含数据的以太币转账时，fallback 函数会被触发
    // 如果不存在 fallback 函数，且转账包含数据或者调用不存在的函数，交易将会失败
    fallback() external payable { 
        // 处理调用不存在的函数或包含数据的以太币转账 
        // 如果没有定义 receive 函数，那么纯以太币转账也会走 fallback 函数
        // 我们可以在这里加一些实现逻辑
        emit EventA(1); // 触发事件
        uint a = 1 + 2;
        // 会推函数的逻辑应该尽可能简单，如果发送交易的人提供的gas不足，可能会导致交易失败
    }
    // 没有receive的情况下，不管成功还是失败都会调用fallback函数
    // receive 函数专门处理纯以太币转账 纯以太币转账就走receive函数
    //fallback 函数处理带有数据的以太币转账或调用不存在的函数 一旦有数据就走fallback函数 一旦调用不存在的函数也走fallback函数 这两宗情况无视是否有receive函数
}

// 定义另外一个合约去给这个合约转移以太币
contract Caller {
    function callTest(Test test) public {
        payable(address(test)).send(1 ether);
    }
}
