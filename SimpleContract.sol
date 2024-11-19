// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {
    // Direcciones de las cuentas A y B
    address public accountA;
    address public accountB;

    // Evento para transferencias
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Constructor para inicializar las cuentas A y B
    constructor(address _accountB) {
        accountA = msg.sender; // La cuenta que despliega el contrato será la cuenta A
        accountB = _accountB; // La cuenta B es pasada como parámetro al contrato
    }

    // Función para depositar fondos en el contrato
    function deposit() public payable {
        require(msg.value > 0, "Debe enviar algo de Ether");
    }

    // Función para transferir fondos de la cuenta A a la cuenta B
    function transferToAccountB(uint256 amount) public {
        require(msg.sender == accountA, "Solo la cuenta A puede transferir");
        require(address(this).balance >= amount, "No hay suficiente saldo en el contrato");

        payable(accountB).transfer(amount); // Transferencia de Ether a la cuenta B

        emit Transfer(accountA, accountB, amount);
    }

    // Función para verificar el saldo del contrato
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Función para retirar fondos de la cuenta B (solo para la cuenta B)
    function withdraw(uint256 amount) public {
        require(msg.sender == accountB, "Solo la cuenta B puede retirar");
        payable(accountB).transfer(amount);
    }
}
