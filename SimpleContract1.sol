// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleTransfer {
    // Direcciones de las cuentas A y B
    address public accountA;
    address public accountB;

    // Evento para registrar transferencias
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Constructor para inicializar las cuentas
    constructor() {
        accountA = 0x04Ea7820d7f23f9fDC7A5C6a8A2Fa0B8b3D6Eca1;
        accountB = 0x375e5A10d9878BF6522A188C7c69778f52648A9A;
    }

    // Función para depositar fondos en el contrato
    function deposit() public payable {
        require(msg.value > 0, "Debe enviar Ether"); // Validar que se envíe Ether
    }

    // Función para transferir fondos del contrato a la cuenta B
    function transferToAccountB(uint256 amount) public {
        require(msg.sender == accountA, "Solo la cuenta A puede transferir");
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        // Transferir fondos a la cuenta B
        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "Transferencia fallida");

        // Emitir evento
        emit Transfer(accountA, accountB, amount);
    }

    // Función para verificar el saldo del contrato
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Función para que la cuenta B retire fondos
    function withdraw(uint256 amount) public {
        require(msg.sender == accountB, "Solo la cuenta B puede retirar");
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        // Transferir fondos a la cuenta B
        (bool success, ) = payable(accountB).call{value: amount}("");
        require(success, "Retiro fallido");

        // Emitir evento
        emit Transfer(address(this), accountB, amount);
    }
}
