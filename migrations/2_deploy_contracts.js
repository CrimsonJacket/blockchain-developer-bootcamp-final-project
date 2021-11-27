var RequestPayment =  artifacts.require("./RequestPayment.sol");

module.exports = function(deployer) {
    deployer.deploy(RequestPayment)
};