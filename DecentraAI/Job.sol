// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Jobs {

    struct Job{
        uint jobId;
        uint status;
        uint submissionTime;
        address sentBy;
        address recievedBy;
        string name;
        string jobType;
        string algoType;
        string trainingHash;
        string testingHash;
        string modelHash;
        string targetVariable;
        string[] metricsRequired;
        string[] featureSelection;
    }
    uint public count;

    Job[] public jobs;
    Job[] public tempArray;

        mapping(address => uint256[]) public jobCreated; // This is a mapping where we keep track of all Job_id created on a particular address
        mapping(address => uint256[]) public jobAccepted; // This is a mapping where we keep track of all Job_id accepted on a particular address


    function submitJob(
        address _sentBy,
        string memory _name,
        string memory _jobType,
        string memory _algoType,
        string memory _trainingHash,
        string memory _testingHash,
        string memory _targetVariable,
        string[] memory _metricsRequired,
        string[] memory _featureSelection
    ) external {
        jobs.push(Job(count,0,block.timestamp,_sentBy,address(0),_name,_jobType,_algoType,_trainingHash,_testingHash,"",_targetVariable,_metricsRequired,_featureSelection));
        jobCreated[_sentBy].push(count);
        count++;
    }

    function acceptJob(uint _jobId, address _received) external {
        Job storage myJob = jobs[_jobId];
        require(myJob.status == 0 ,"Job already accepted");
        myJob.recievedBy = _received;  
        myJob.status = 1;
        jobAccepted[_received].push(myJob.jobId);                                         
    }

    function excecuteJob(uint _jobId,string memory _modelHash) external {
        Job storage myJob = jobs[_jobId];
        require(myJob.status == 1,"Job is not accepted yet");
        myJob.modelHash = _modelHash;
        myJob.status = 2;
    }   

    // function getAcceptedJob(address _walletAddress) public view returns(uint[] memory){
    //         return jobAccepted[_walletAddress];
    // }

    // function getAcceptedJobArray(address _walletAddress) public returns(Job[] memory){
    //     uint[] memory array = getAcceptedJob(_walletAddress);
    //     delete tempArray;
    //     for(uint i = 0 ;i<array.length;i++){
    //         tempArray.push(jobs[i]);
    //     }
    //     return tempArray;
    // }
    
    // function getCreatedJob(address _walletAddress) public view returns(uint[] memory){
    //     return jobCreated[_walletAddress];

    // }
    
    // function getCreatedJobArray(address _walletAddress) public returns(Job[] memory){
    //     uint[] memory array = getCreatedJob(_walletAddress);
    //      delete tempArray;
    //     for(uint i = 0 ;i<array.length;i++){
    //         tempArray.push(jobs[i]);
    //     }
    //     return tempArray;
    // }

    function getJobs() public view returns(Job[] memory){
        return jobs;
    }

    function getJob(uint _jobId) public view returns(Job memory){
        return jobs[_jobId];
    }



}