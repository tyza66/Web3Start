# 区块包括：索引、时间戳、交易信息（数组）、工作量证明、上一个区块的哈希值
import hashlib
import json
from time import time
from urllib.parse import urlparse

import requests
from flask import Flask, jsonify, request


# 区块链类 将区块链的特征封一下
class BolckChain:
    def __init__(self):
        self.chain = []  # 这个用于存储区块链 随着区块链的不断增长，数据量会越来越大，导致数据传输和存储的负担加重
        self.current_transactions = []  # 这个用于存储当前交易信息
        self.nodes = set()  # 这个用于存储网络中的节点信息 SET能保证不重复

        self.new_block(proof=100, previous_hash=1)  # 创建创世区块

    # 注册一个节点
    def register_node(self, address):
        parsed_url = urlparse(address)
        self.nodes.add(parsed_url.netloc)

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
            'sender': sender,  # 发送者
            'recipient': recipient,  # 接收者
            'amount': amount  # 金额
        })
        return self.last_block['index'] + 1

    @staticmethod
    def hash(block):
        # 将区块转换为json字符串，然后转换为字节，然后进行sha256加密 最后返回加密后的哈希值
        return hashlib.sha256(json.dumps(block, sort_keys=True).encode()).hexdigest()

    @property  # 将函数定义为属性
    def last_block(self):
        return self.chain[-1]  # 返回最后一个区块

    # 模拟工作量证明 真实的应该是前一个区块的哈希值、当前区块的哈希值、一个随机数一起哈希验证
    def proof_of_work(self, last_proof):
        proof = 0
        while self.valid_proof(last_proof, proof) is False:  # 最后一个节点的工作量证明和当前的工作量证明进行加密，然后判断加密后的哈希值是否满足条件
            proof += 1
        return proof

    # 用上一个区块的工作量证明和当前的工作量证明进行加密，然后判断加密后的哈希值是否满足条件
    # 现在比特币应该是以18个0开头
    def valid_proof(self, last_proof, proof):
        guess = f'{last_proof}{proof}'.encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"

    # 验证区块链是否有效
    def valid_chain(self, chain):
        last_block = chain[0]
        current_index = 1
        while current_index < len(chain):
            block = chain[current_index]
            if block['previous_hash'] != self.hash(last_block):  # 判断当前区块的哈希值是否等于上一个区块的哈希值
                return False
            if not self.valid_proof(last_block['proof'], block['proof']):  # 判断工作量证明是否有效
                return False
            last_block = block
            current_index += 1
        return True

    # 解决冲突
    def resolve_conflicts(self):
        neighbours = self.nodes  # 获取所有的节点 目的是找到最长的区块链
        new_chain = None
        max_length = len(self.chain)
        for node in neighbours:
            response = requests.get(f'http://{node}/chain')
            if response.status_code == 200:
                length = response.json()['length']
                chain = response.json()['chain']
                if length > max_length and self.valid_chain(chain):  # 如果长度大于当前的区块链长度并且区块链是有效的
                    max_length = length
                    new_chain = chain
        if new_chain:
            self.chain = new_chain
            return True
        return False


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
        last_proof = last_block['proof']  # 获取最后一个区块的工作量证明模拟用
        proof = blockchain.proof_of_work(last_proof)  # 模拟计算当前节点工作量证明(浪费自然资源)
        blockchain.new_transaction(  # 给自己的奖励交易
            sender="0",  # 奖励不需要发送者 相当于新发行的货币
            recipient=node_identifier,  # 接收者是自己
            amount=1  # 奖励金额
        )
        block = blockchain.new_block(proof)  # 给最新的交易同步进区块链 之后返回当前添加的区块信息
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

    # 注册节点
    @app.route('/nodes/register', methods=['POST'])
    def register_nodes():
        values = request.get_json()
        nodes = values.get('nodes')
        if nodes is None:
            return "Error: Please supply a valid list of nodes", 400
        for node in nodes:
            blockchain.register_node(node)
        response = {
            'message': 'New nodes have been added',
            'total_nodes': list(blockchain.nodes)
        }
        return jsonify(response), 201

    app.run(host='0.0.0.0', port=5000)


if __name__ == '__main__':
    init_flask()
