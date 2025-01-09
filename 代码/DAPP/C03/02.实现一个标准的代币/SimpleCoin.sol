pragma solidity 0.8.28; 

// 本合约遵循ERC20标准
// https://github.com/ethereum/ercs/blob/master/ERCS/erc-20.md

// 定义一个抽象合约作为接口（新版的接口定义规则已经改变）
abstract contract ERC20Interface{
    string public name; // 代币名称
    string public symbol; // 代币符号
    uint8 public decimals; // 代币小数点位数
    uint public totalSupply; // 代币总供应量

    function getBalanceOf(address _owner) public view virtual returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// 定义一个合约继承ERC20Interface
contract SimpleCoin is ERC20Interface{
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowed; // 记录一个账户 A 对另一个账户 B 的授权额度
    // 解构就是 A => （B => 100）, A授权B 100个代币的可操作额度  就是B可以操作A的100个代币的额度

    // 构造函数
    constructor(){
        name = "ty coin";
        symbol = "tyc";
        decimals = 0; // 代币不要小数
        totalSupply = 100; // 代币总供应量100个
        balanceOf[msg.sender] = totalSupply;
    }

    // 查询_owner的余额
    function getBalanceOf(address _owner) public view override returns (uint256 balance){
        return balanceOf[_owner];
    }

    // 转账
    function transfer(address _to, uint256 _value) public override returns (bool success){
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value); // 触发Transfer事件
        return true;
    }

    // 授权
    // _spender: 被授权的地址 传入B的地址
    // _value: 授权额度
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowed[msg.sender][_spender] = _value;  // 赋予B可以操作A的代币额度
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // 查询_owner授权_spender的额度 就是B能操作A的代币额度
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return allowed[_owner][_spender];
    }

    // 从_owner转账到_to
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Not enough balance");
        require(allowed[_from][msg.sender] >= _value, "Not enough allowance"); // 检查from的地址中是否允许现在的msg.sender操作from的代币
        // 就是msg.sender可以操作from的代币必须大于等于_value
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

