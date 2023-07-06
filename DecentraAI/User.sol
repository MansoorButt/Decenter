//SPDX-License-Identifier:MIT

pragma solidity ^0.8.13;

import "./Authorization.sol";
import "./Job.sol";

contract User{    

    struct UserInfo{
        address walletAddress;
        string name;
    }

    Authorization authorization;
    Jobs job;

    constructor(Authorization _authorization,Jobs _job){
        authorization = _authorization;
        job = _job;
    }
    UserInfo[] public users;

    mapping(address => UserInfo) public user;
    mapping(address => uint) public jobsCreated;

    function registerUser(address _walletAddress,string memory _name) external {
        require(!authorization.isUser(_walletAddress),"This User already exists");
        authorization.validateUser(_walletAddress);
        UserInfo memory info = UserInfo(_walletAddress, _name);
        user[_walletAddress]=info;
        jobsCreated[_walletAddress]++;
        users.push(UserInfo(_walletAddress,_name));
    }

    function userSubmitJob(
        string memory _name,
        string memory _jobType,
        string memory _algoType,
        string memory _trainingHash,
        string memory _testingHash,
        string memory _targetVariable,
        string[] memory _metricsRequired,
        string[] memory _featureSelection
    ) external {
        job.submitJob(
        msg.sender,
        _name,
        _jobType,
        _algoType,
        _trainingHash,
        _testingHash,
        _targetVariable,
        _metricsRequired,
        _featureSelection);       
    }

    function viewCreatedJobs() public view returns(Jobs.Job[] memory){
        return job.getJobs();
    }  
      
}