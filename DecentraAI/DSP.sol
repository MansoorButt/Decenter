//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./Authorization.sol";
import "./Job.sol";

contract DSP {
    struct ServiceProvider{
        address wallet;
        string name;
        uint depositedCoin;
    }

    Authorization authorization;
    Jobs job;

    constructor(Authorization _authorization,Jobs _job){
        authorization = _authorization;
        job = _job;
    }

    mapping(address => ServiceProvider[])  public providers;
     mapping(address => uint) public jobsAccepted;

    function registerDSP(address _walletAddress,string memory _name , uint _depositedCoin) external {
        require(!authorization.isServiceProvider(_walletAddress),"This Service Provider already exists");
        authorization.validateServiceProvider(_walletAddress);
        ServiceProvider memory info = ServiceProvider(_walletAddress,_name,_depositedCoin);
        jobsAccepted[_walletAddress]++;
        providers[_walletAddress].push(info);
    }

    function _acceptJob(uint _jobId) public {
        job.acceptJob(_jobId,msg.sender);
    }

    function _executeJob(uint _jobId,string memory _modelHash) public {
        job.excecuteJob(_jobId,_modelHash);
    }

    

}