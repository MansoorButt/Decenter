pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract PaymentContract {
    struct Token {
        string name;
        string symbol;
        uint256 depositedAmount;
    }

    mapping(address => Token) public tokens;
    mapping(address => mapping(address => uint256)) public employeeBalances;
    
    event TokenAdded(address tokenAddress, string name, string symbol, uint256 depositedAmount);
    event EmployeePaid(address indexed employee, address indexed tokenAddress, uint256 amount);
    
    modifier tokenExists(address tokenAddress) {
        require(bytes(tokens[tokenAddress].name).length != 0, "Token does not exist");
        _;
    }
    
    function addToken(address tokenAddress, string memory name, string memory symbol, uint256 depositedAmount) external {
        require(bytes(name).length != 0, "Name cannot be empty");
        require(bytes(symbol).length != 0, "Symbol cannot be empty");
        require(depositedAmount > 0, "Deposited amount must be greater than 0");

        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(msg.sender) >= depositedAmount, "Insufficient balance");

        tokens[tokenAddress] = Token(name, symbol, depositedAmount);
        token.transferFrom(msg.sender, address(this), depositedAmount);

        emit TokenAdded(tokenAddress, name, symbol, depositedAmount);
    }
    
    function payEmployee(address employee, address tokenAddress, uint256 amount) external tokenExists(tokenAddress) {
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Insufficient contract balance");
        
        employeeBalances[employee][tokenAddress] += amount;
        token.transfer(employee, amount);
        
        emit EmployeePaid(employee, tokenAddress, amount);
    }
    
    function getEmployeeBalance(address employee, address tokenAddress) external view tokenExists(tokenAddress) returns (uint256) {
        return employeeBalances[employee][tokenAddress];
    }
}
