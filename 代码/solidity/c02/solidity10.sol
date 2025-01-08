pragma solidity 0.8.28; 

// 这一讲来说一下控制解构
// if、else、for、while、do while、break、continue、?
// 没有switch和goto

contract Test {
    // 1. if
    // if是一个条件判断语句
    // 如果括号里面的条件为真，那么就会执行花括号里面的代码
    // 如果括号里面的条件为假，那么就会执行else后面的代码
    function testIf() public pure returns (uint){
        uint a = 1;
        uint b = 2;
        if(a > b){
            return a;
        }else{
            return b;
        }
    }

    // 2. for
    // for是一个循环语句
    // for循环有三个部分，初始化、条件、递增
    // 初始化是在for循环开始的时候执行的
    // 条件是在每次循环开始的时候执行的
    // 递增是在每次循环结束的时候执行的
    function testFor() public pure returns (uint){
        uint sum = 0;
        for(uint i = 0;i < 10;i++){
            sum += i;
        }
        return sum;
    }

    // 3. while
    // while是一个循环语句
    // while循环只有一个条件
    // 只要条件为真，就会一直执行循环体
    function testWhile() public pure returns (uint){
        uint sum = 0;
        uint i = 0;
        while(i < 10){
            sum += i;
            i++;
        }
        return sum;
    }

    // 4. do while
    // do while是一个循环语句
    // do while循环只有一个条件
    // do while循环会先执行一次循环体，然后再判断条件
    // 只要条件为真，就会一直执行循环体
    function testDoWhile() public pure returns (uint){
        uint sum = 0;
        uint i = 0;
        do{
            sum += i;
            i++;
        }while(i < 10);
        return sum;
    }

    // 5. break
    // break是一个跳出循环的关键字
    // break只能用在循环中
    // 当执行到break的时候，会跳出循环
    function testBreak() public pure returns (uint){
        uint sum = 0;
        for(uint i = 0;i < 10;i++){
            sum += i;
            if(sum > 10){
                break;
            }
        }
        return sum;
    }

    // 6. continue
    // continue是一个跳过本次循环的关键字
    // continue只能用在循环中
    // 当执行到continue的时候，会跳过本次循环
    function testContinue() public pure returns (uint){
        uint sum = 0;
        for(uint i = 0;i < 10;i++){
            if(i == 5){
                continue;
            }
            sum += i;
        }
        return sum;
    }

    // 7. 三元运算符
    // 三元运算符是一个条件判断语句
    // 三元运算符有三个部分，条件、真值、假值
    // 如果条件为真，那么就会返回真值
    // 如果条件为假，那么就会返回假值
    // 真就拿前面的值，假就拿后面的值
    function testThree() public pure returns (uint){
        uint a = 1;
        uint b = 2;
        return a > b ? a : b;
    }
}