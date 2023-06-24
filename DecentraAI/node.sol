// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./Job.sol";

contract Node {
    struct Decentride {
        address owner;
        uint jobId;
        uint startTime;
        uint endTime;
        uint nodeID;
        uint availableBalance;
        string ipAddress;
        string CPU_CORE;
        string CPU_PERCENT;
        string GPU_PERCENT;
        string MEM_SHARED;
        string storageShared;
        uint[] modelIndices;  // Store the indices of Model structs
    }

    struct Model {
        uint modelId;
        string algo;
        string modelHash;
        string accuracy;
    }

    Decentride[] public decentride;
    Model[] public models;  // Store all Model structs
    Jobs job;
    uint nodeCount;
    uint modelCount;

    mapping(address => uint256[]) public traverseDecentride;
    mapping(uint => uint256[]) public traverseModel;
    mapping(uint => Jobs.Job) public assignedJob;
    
    constructor(Jobs _job) {
        job = _job;
    }
    
    function setAssignedJob(uint jobId) public {
        assignedJob[jobId] = job.getJob(jobId);
    }

    function registerDecentride(
        address _owner,
        uint _jobId,
        uint _startTime,
        uint _availableBalance,
        string memory _ipAddress,
        string memory _CPU_CORE,
        string memory _CPU_PERCENT,
        string memory _GPU_PERCENT,
        string memory _MEM_SHARED,
        string memory _storageShared
    ) public {
        Decentride memory newDecentride;
        newDecentride.owner = _owner;
        newDecentride.jobId = _jobId;
        newDecentride.startTime = _startTime;
        newDecentride.nodeID = nodeCount;
        newDecentride.availableBalance = _availableBalance;
        newDecentride.ipAddress = _ipAddress;
        newDecentride.CPU_CORE = _CPU_CORE;
        newDecentride.CPU_PERCENT = _CPU_PERCENT;
        newDecentride.GPU_PERCENT = _GPU_PERCENT;
        newDecentride.MEM_SHARED = _MEM_SHARED;
        newDecentride.storageShared = _storageShared;
        decentride.push(newDecentride);
        nodeCount++;
    } 
    
    function addModel(uint decentrideIndex, string memory _algo, string memory _modelHash, string memory _accuracy) public {
        require(decentrideIndex < decentride.length, "Invalid Decentride index");
        Model memory newModel;
        newModel.modelId = modelCount;
        newModel.algo = _algo;
        newModel.modelHash = _modelHash;
        newModel.accuracy = _accuracy;        
        models.push(newModel);        
        decentride[decentrideIndex].modelIndices.push(modelCount);
        modelCount++;
    }


    


}
