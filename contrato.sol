// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Versión específica

contract SimpleTransfer {
    address public accountA;
    address public accountB;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() payable {
        require(msg.value > 0, "Debe enviar Ether al desplegar el contrato");
        accountA = 0x04Ea7820d7f23f9fDC7A5C6a8A2Fa0B8b3D6Eca1;
        accountB = 0x375e5A10d9878BF6522A188C7c69778f52648A9A;
    }

    function deposit() public payable {
        require(msg.value > 0, "Debe enviar Ether");
    }

    function transferToAccountB(uint256 amount) public {
        require(msg.sender == accountA, "Solo la cuenta A puede transferir");
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "Transferencia fallida");

        emit Transfer(accountA, accountB, amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == accountB, "Solo la cuenta B puede retirar");
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "Retiro fallido");

        emit Transfer(address(this), accountB, amount);
    }
}
