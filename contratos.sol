// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundManager {
    address public senderAccount; // Cuenta desde la que se enviará el ETH
    address public recipientAccount; // Cuenta que recibirá el ETH

    event Deposit(address indexed sender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    modifier onlySender() {
        require(msg.sender == senderAccount, "Solo la cuenta emisora puede realizar esta operacion");
        _;
    }

    constructor(address _senderAccount, address _recipientAccount) payable {
        require(_senderAccount != address(0), "La cuenta emisora no puede ser la direccion cero");
        require(_recipientAccount != address(0), "La cuenta receptora no puede ser la direccion cero");

        senderAccount = _senderAccount;
        recipientAccount = _recipientAccount;

        // Emitimos un evento si el contrato recibe Ether al ser desplegado
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    // Función para depositar fondos al contrato
    function deposit() external payable {
        require(msg.value > 0, "Debe enviar un monto positivo de Ether");
        emit Deposit(msg.sender, msg.value);
    }

    // Función para transferir fondos desde el contrato a la cuenta receptora
    function transferFunds(uint256 amount) external onlySender {
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(recipientAccount).call{value: amount}("");
        require(success, "La transferencia fallo");

        emit Transfer(senderAccount, recipientAccount, amount);
    }

    // Función para retirar fondos por parte del receptor
    function withdraw(uint256 amount) external {
        require(msg.sender == recipientAccount, "Solo la cuenta receptora puede realizar retiros");
        require(amount > 0, "El monto debe ser mayor a 0");
        require(address(this).balance >= amount, "Saldo insuficiente en el contrato");

        (bool success, ) = payable(recipientAccount).call{value: amount}("");
        require(success, "El retiro fallo");

        emit Withdrawal(recipientAccount, amount);
    }

    // Función para configurar nuevas cuentas emisora y receptora
    function setAccounts(address _senderAccount, address _recipientAccount) external onlySender {
        require(_senderAccount != address(0) && _recipientAccount != address(0), "Direcciones no validas");
        senderAccount = _senderAccount;
        recipientAccount = _recipientAccount;
    }

    // Función para consultar el saldo del contrato
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
