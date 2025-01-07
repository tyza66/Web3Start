# 区块包括：索引、时间戳、交易信息（数组）、工作量证明、上一个区块的哈希值
import hashlib
import json
from time import time


# 区块链类 将区块链的特征封一下
class BolckChain:
    def __init__(self):
        self.chain = []  # 这个用于存储区块链
        self.current_transactions = []  # 这个用于存储当前交易信息
        self.new_block(proof=100, previous_hash=1)  # 创建创世区块

    # 创建一个区块
    def new_block(self, proof, previous_hash=None):
        block = {
            'index': len(self.chain) + 1,
            'timestamp': time(),
            'transactions': self.current_transactions,
            'proof': proof,
            'previous_hash': previous_hash or self.hash(self.last_block)
            # -1表示最后一个区块 就是数组中最后一个元素 or表示如果传入了previous_hash就用传入的，否则用最后一个区块的哈希值
        }
        self.current_transactions = []  # 将交易信息清空 因为已经打包到区块中了
        self.chain.append(block)  # 将区块添加到区块链中
        return block

    # 添加一个交易
    def new_transaction(self, sender, recipient, amount) -> int:
        self.current_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount
        })
        return self.last_block['index'] + 1

    @staticmethod
    def hash(block):
        # 将区块转换为json字符串，然后转换为字节，然后进行sha256加密 最后返回加密后的哈希值
        return hashlib.sha256(json.dumps(block, sort_keys=True).encode()).hexdigest()

    @property # 将函数定义为属性
    def last_block(self):
        return self.chain[-1]  # 返回最后一个区块


def print_hi(name):
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.


if __name__ == '__main__':
    print_hi('PyCharm')
