const MetavaultAggregator = artifacts.require("MetavaultAggregator");

module.exports = function (deployer) {
  deployer.deploy(MetavaultAggregator);
};
