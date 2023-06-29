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
        uint[] modelIndices; // Store the indices of Model structs
    }

    struct Model {
        uint modelId;
        string algo;
        string modelHash;
        string accuracy;
    }

    Decentride[] public decentride;
    Model[] public models; // Store all Model structs
    Jobs job;
    uint nodeCount;
    uint modelCount;

    mapping(address => uint256[]) public traverseDecentride;
    // mapping(uint => uint256[]) public traverseModel;
    mapping(uint => Jobs.Job) public assignedJob;
    mapping(uint => uint) public state;
    mapping(address => Decentride[]) public trackVM;

    constructor(Jobs _job) {
        job = _job;
    }

    function setAssignedJob(uint _nodeId, uint _jobId) public {
        assignedJob[_nodeId] = job.getJob(_jobId);
    }

    function registerDecentride(
        address _owner,
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
        openMachine(nodeCount);
        traverseDecentride[_owner].push(nodeCount);
        trackVM[_owner][nodeCount]=newDecentride;
        nodeCount++;
    }

    // This function adds a new model to the Decentride platform
    // It takes in four parameters: the index of the Decentride, the algorithm used, the hash of the model, and the accuracy of the model
    function addModel(
        uint decentrideIndex,
        string memory _algo,
        string memory _modelHash,
        string memory _accuracy,
        address _owner
    ) public {
        // Check if the Decentride index is valid
        require(
            decentrideIndex < decentride.length,
            "Invalid Decentride index"
        );

        // Create a new Model struct
        Model memory newModel;
        // Set the model ID to the current model count
        newModel.modelId = modelCount;
        // Set the algorithm used for the model
        newModel.algo = _algo;
        // Set the hash of the model
        newModel.modelHash = _modelHash;
        // Set the accuracy of the model
        newModel.accuracy = _accuracy;
        // Add the new model to the models array
        models.push(newModel);
        // Add the index of the new model to the Decentride's modelIndices array
        decentride[decentrideIndex].modelIndices.push(modelCount);
        trackVM[_owner][decentrideIndex].modelIndices[modelCount]=modelCount;
        // Increment the model count
        modelCount++;
    }

    // This function sends a job to a specific node
    function sendJob(uint _nodeId, uint _jobId,address _owner) public {
        // Create a new Decentride object and assign it to the specified node
        Decentride memory newDecentride = decentride[_nodeId];
        // Set the job ID for the new Decentride object
        trackVM[_owner][_nodeId].jobId=_jobId;
        newDecentride.jobId = _jobId;
        // Call the setAssignedJob function to update the assigned job for the specified node
        setAssignedJob(_nodeId, _jobId);
    }

    function openMachine(uint _nodeId) public {
        state[_nodeId] = 1;
    }

    function closeMachine(uint _nodeId) public {
        state[_nodeId] = 0;
    }

    function getNode(address _owner) public view returns(Decentride[] memory){
        return trackVM[_owner];
    }
         
    
    
}
