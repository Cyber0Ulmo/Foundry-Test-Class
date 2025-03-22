// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {KipuBank} from "../../src/KipuBank.sol";

contract KipuBankTest is Test {
    //Instances
    KipuBank bank;

    //Variables ~ Users
    address Barba = makeAddr("Barba");
    address student1 = makeAddr("student1");
    address student2 = makeAddr("student2");

    //Variables ~ Utils
    uint256 constant BANK_CAP = 10*10**18;
    uint256 constant INITIAL_BALANCE = 100*10**18;

    modifier processDeposit() {
        uint256 amount = 1*10**18;
        vm.prank(Barba);
        bank.deposit{value: amount}();
        _;
    }

    function setUp() public {
        bank = new KipuBank(BANK_CAP);

        vm.deal(Barba, INITIAL_BALANCE);
        vm.deal(student1, INITIAL_BALANCE);
        vm.deal(student2, INITIAL_BALANCE);
    }


    event Deposit(address indexed sender, uint256 amount);
    function test_depositPass() public {
        vm.prank(Barba);
        vm.expectEmit();
        emit Deposit(Barba, 1 ether);
        bank.deposit{value: 1 ether}();
        assertEq(address(bank).balance, 1 ether);
    }

    function test_withdrawPass() public processDeposit {
        vm.prank(Barba);
        bank.withdraw(1 ether);
        assertEq(address(bank).balance, 0);
    }

    error KipuBank_InsufficientBalance();
    function test_withdrawFail() public processDeposit {
        vm.prank(Barba);
        vm.expectRevert(abi.encodeWithSelector
        (KipuBank_InsufficientBalance.selector));
        bank.withdraw(2 ether);
        }
}