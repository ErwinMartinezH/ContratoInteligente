// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {
    address public accountA; // Dirección inicial
    address public accountB; // Dirección de destino

    event Deposit(address indexed sender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    modifier onlyAccountA() {
        require(msg.sender == accountA, "Solo la cuenta A puede realizar esta operacion");
        _;
    }

    modifier onlyAccountB() {
        require(msg.sender == accountB, "Solo la cuenta B puede realizar esta operacion");
        _;
    }

    constructor(address _accountA, address _accountB) payable {
        require(_accountA != address(0), "La cuenta A no puede ser la direccion cero");
        require(_accountB != address(0), "La cuenta B no puede ser la direccion cero");
        require(msg.value > 0, "Debe enviar Ether al desplegar el contrato");

        accountA = _accountA;
        accountB = _accountB;

        emit Deposit(msg.sender, msg.value);
    }

    function deposit() external payable {
        require(msg.value > 0, "Debe enviar un monto positivo de Ether");
        emit Deposit(msg.sender, msg.value);
    }

    function transferToAccountB(uint256 amount) external onlyAccountA {
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "La transferencia fallo");

        emit Transfer(accountA, accountB, amount);
    }

    function withdraw(uint256 amount) external onlyAccountB {
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "El retiro fallo");

        emit Withdrawal(accountB, amount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
