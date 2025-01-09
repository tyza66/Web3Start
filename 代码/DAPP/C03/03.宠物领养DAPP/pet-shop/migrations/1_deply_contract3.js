var Adoption = artifacts.require("Adoption");

// 部署合约的脚本
module.exports = function (deployer) {
    deployer.deploy(Adoption);
}