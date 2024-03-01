const MyToken = artifacts.require("Miragrow");

module.exports = (deployer) => {
    deployer.deploy(MyToken);
};
