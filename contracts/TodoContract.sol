// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

contract TodoContract {
    uint256 public taskCount = 0;

    struct Task {
        uint256 index;
        string taskName;
        bool isComplete;
    
    }

    mapping(uint256 => Task) public todos;
    event TaskCreated(string task, uint256 taskNumber);
    event TaskUpdated(string task, uint256 taskId);
    event TaskIsCompleteToggled(string task, uint256 taskId, bool isComplete);
    event TaskDeleted(uint256 taskNumber);

    function createTask(string memory _taskName) public {
        todos[taskCount] = Task(taskCount, _taskName, false);
        taskCount++;
        emit TaskCreated((_taskName), taskCount - 1);
    }
}