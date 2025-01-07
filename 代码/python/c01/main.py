# 区块包括：索引、时间戳、交易信息（数组）、工作量证明、上一个区块的哈希值
import hashlib
import json
from time import time
from flask import Flask, jsonify, request


# 区块链类 将区块链的特征封一下
class BolckChain:
    def __init__(self):
        self.chain = []  # 这个用于存储区块链 随着区块链的不断增长，数据量会越来越大，导致数据传输和存储的负担加重
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
            'sender': sender, # 发送者
            'recipient': recipient, # 接收者
            'amount': amount #金额
        })
        return self.last_block['index'] + 1

    @staticmethod
    def hash(block):
        # 将区块转换为json字符串，然后转换为字节，然后进行sha256加密 最后返回加密后的哈希值
        return hashlib.sha256(json.dumps(block, sort_keys=True).encode()).hexdigest()

    @property # 将函数定义为属性
    def last_block(self):
        return self.chain[-1]  # 返回最后一个区块

    # 模拟工作量证明 真实的应该是前一个区块的哈希值、当前区块的哈希值、一个随机数一起哈希验证
    def proof_of_work(self, last_proof):
        proof = 0
        while self.valid_proof(last_proof, proof) is False: # 最后一个节点的工作量证明和当前的工作量证明进行加密，然后判断加密后的哈希值是否满足条件
            proof += 1
        return proof

    # 用上一个区块的工作量证明和当前的工作量证明进行加密，然后判断加密后的哈希值是否满足条件
    # 现在比特币应该是以18个0开头
    def valid_proof(self, last_proof, proof):
        guess = f'{last_proof}{proof}'.encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"

def init_flask():
    app = Flask(__name__)
    blockchain = BolckChain()
    node_identifier = '123'

    @app.route('/test', methods=['GET'])
    def test():
        return 'test'

    # 挖矿路由
    @app.route('/mine', methods=['GET'])
    def mine():
        last_block = blockchain.last_block
        last_proof = last_block['proof']    # 获取最后一个区块的工作量证明模拟用
        proof = blockchain.proof_of_work(last_proof) # 模拟计算当前节点工作量证明
        blockchain.new_transaction(
            sender="0",
            recipient=node_identifier,
            amount=1
        )
        block = blockchain.new_block(proof)
        response = {
            'message': "New Block Forged",
            'index': block['index'],
            'transactions': block['transactions'],
            'proof': block['proof'],
            'previous_hash': block['previous_hash']
        }
        return jsonify(response), 200

    # 创建交易路由 只是将交易信息添加进去，并没有挖矿（记账）
    # 创建新的交易的时候是需要验证私钥的，这里只是模拟，所以没有验证
    @app.route('/transactions/new', methods=['POST'])
    def new_transaction():
        values = request.get_json()
        if values == None:  # 判断是否有值
            return 'Missing values', 400
        required = ['sender', 'recipient', 'amount']
        if not all(k in values for k in required):  # 判断是否有缺失的值
            return 'Missing values', 400
        index = blockchain.new_transaction(values['sender'], values['recipient'], values['amount'])
        response = {'message': f'Transaction will be added to Block {index}'}
        return jsonify(response), 201

    # 获取整个区块链
    @app.route('/chain', methods=['GET'])
    def full_chain():
        response = {
            'chain': blockchain.chain,  # 整个区块链的信息
            'length': len(blockchain.chain)
        }
        return jsonify(response), 200

    app.run(host='0.0.0.0', port=5000)


if __name__ == '__main__':
    init_flask()
