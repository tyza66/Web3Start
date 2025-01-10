pragma solidity ^0.8.0;

contract Adoption{
    address[16] public adopters; // 用于存储这16个宠物的领养者

    // 完成交易通知刷新前端
    event Adopted(address indexed _adopter, uint indexed _petId);

    // 领养宠物
    function adopt(uint petId) public returns (uint){
        require(petId >= 0 && petId <= 15);
        adopters[petId] = msg.sender; // 几号的宠物被谁领养了 通过宠物id从数组adopters查询领养者
        emit Adopted(msg.sender, petId); // 发送事件通知
        return petId;
    }

    function getAdopters() public view returns (address[16] memory){
        return adopters;
    }
}