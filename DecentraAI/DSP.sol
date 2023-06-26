//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./Authorization.sol";
import "./Job.sol";
import "./node.sol";

contract DSP {
    struct ServiceProvider{
        address wallet;
        string name;
        uint depositedCoin;
    }

    Authorization authorization;
    Jobs job;
    Node nodes;

    constructor(Authorization _authorization,Jobs _job,Node _node){
        authorization = _authorization;
        job = _job;
        nodes = _node;
    }

     mapping(address => ServiceProvider) public provider;
     mapping(address => uint) public jobsAccepted;
     mapping()

    function registerDSP(address _walletAddress,string memory _name , uint _depositedCoin) external {
        require(!authorization.isServiceProvider(_walletAddress),"This Service Provider already exists");
        authorization.validateServiceProvider(_walletAddress);
        ServiceProvider memory info = ServiceProvider(_walletAddress,_name,_depositedCoin);
        provider[_walletAddress]= info;
    }

    function _acceptJob(uint _jobId,address _walletAddress) public {
        job.acceptJob(_jobId,msg.sender);
        jobsAccepted[_walletAddress]++;
    }

    function _executeJob(uint _jobId,string memory _modelHash) public {
        job.excecuteJob(_jobId,_modelHash);
    }

    function _registerDecentride(
        address _owner,
        uint _startTime,
        uint _availableBalance,
        string memory _ipAddress,
        string memory _CPU_CORE,
        string memory _CPU_PERCENT,
        string memory _GPU_PERCENT,
        string memory _MEM_SHARED,
        string memory _storageShared) public {

                nodes.registerDecentride(_owner,_startTime,_availableBalance,_ipAddress,_CPU_CORE,_CPU_PERCENT,_GPU_PERCENT,_MEM_SHARED,_storageShared);           

        } 

        function _addModel(uint decentrideIndex,
        string memory _algo,
        string memory _modelHash,
        string memory _accuracy) public{
            
            nodes.addModel(decentrideIndex,_algo,_modelHash,_accuracy);
        }

        function _assignDecentride(uint _jobId,uint _nodeId) public {
            nodes.sendJob(_jobId,_nodeId);
        }

                
    

}