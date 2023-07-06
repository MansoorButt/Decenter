//SPDX-License-Identifier:MIT

pragma solidity ^0.8.13;

contract Authorization {
    mapping (address => bool) public isServiceProvider;
    mapping (address => bool) public isUser;

    function validateUser(address _userAddress) public {
        isUser[_userAddress]=true;
    }

    
    function validateServiceProvider(address _serviceProviderAddress) public {
        isServiceProvider[_serviceProviderAddress]=true;
    }

    function authenticate(address _user) external view returns(string memory){
        if(isUser[_user]){
            return "User";
        }
        else if(isServiceProvider[_user]){
            return "DSP";
        }
        else{
            return "User does not exist";
        }
    }
}