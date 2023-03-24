// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "contracts/Router.sol";
import "contracts/Extension.sol";
import "contracts/Incrementer.sol";
import "@dynamic-contracts/interface/IExtension.sol";

// source .env
// forge script script/Deploy.s.sol --rpc-url "https://opt-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}" --broadcast --verify

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        // use privateKey to sign all of the subsequent transactions, with the exclusion of cheatcodes
        vm.startBroadcast(privateKey);

        Number number = new Number();

        IExtension.Extension[] memory extensions = new IExtension.Extension[](2);
        extensions[0].metadata = IExtension.ExtensionMetadata('number', 'number.storage', address(number));
        extensions[0].functions = new IExtension.ExtensionFunction[](2);
        extensions[0].functions[0] = IExtension.ExtensionFunction(number.setNumber.selector, 'setNumber(uint256)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(number.getNumber.selector, 'getNumber()');

        Incrementer incrementer = new Incrementer();
        extensions[1].metadata = IExtension.ExtensionMetadata('incrementer', 'incrementer.storage', address(incrementer));
        extensions[1].functions = new IExtension.ExtensionFunction[](1);
        extensions[1].functions[0] = IExtension.ExtensionFunction(incrementer.increment.selector, 'increment()');

        new SimpleRouter(extensions);

        vm.stopBroadcast();
    }
}