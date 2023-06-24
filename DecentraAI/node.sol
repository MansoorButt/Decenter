// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./Job.sol";

contract Node {
    struct Decentride{
        address owner;
        uint jobId;
        uint startTime;
        uint endTime;
        uint nodeID;
        uint availableBalance;
        string CPU_CORE;
        string CPU_PERCENT;
        string GPU_PERCENT;
        string MEM_SHARED;
        string storageShared;
        string bandwithShared;
        Model[] model;
    }

    struct Model{
        uint modelId;
        string algo;
        string modelHash;
        string accuracy;
    }

    Decentride[] public decentride;

    Jobs job;

     constructor(Jobs _job){
        job = _job;
    }
    
    mapping(address => uint256[]) public traverseDecentride;
    mapping(uint => Jobs.Job) public assignedJob;
    
    function setAssignedJob(uint jobId) public {
        assignedJob[jobId] = job.getJob(jobId);
    }


}