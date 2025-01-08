pragma solidity 0.8.28; 

contract AddrTest{
    // 往这个合约地址存款 上面框填写余额之后执行这个方法添加余额
    function deposit() public payable{

    }
    
    function getBlance() public view returns(uint){
        return address(this).balance; // this指的是当前合约
    }
}