// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Todo {
    // - add tasks
    // - fetch the tasks
    // - Remove on the completion

    event TaskAdded(uint256 _index, string _taskName, string _priorityLevel);
    event TaskCompleted(uint256 _index, string _taskName);

    address owner;
    uint256 index;

    constructor() {
        owner = msg.sender;
    }

    struct Task {
        uint256 _index;
        string taskName;
        string priorityLevel;
        bool completed;
    }

    Task[] tasks;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized!");
        _;
    }

    function addTask(string memory _taskName, string memory _priorityLevel)
        public
        onlyOwner
    {
        Task memory task = Task({
            _index: index,
            taskName: _taskName,
            priorityLevel: _priorityLevel,
            completed: false
        });
        tasks.push(task);

        emit TaskAdded(task._index, task.taskName, task.priorityLevel);
        index++;
    }

    function fetchTask() public view returns (Task[] memory) {
        return tasks;
    }

    function markAsComplete(uint256 _taskIndex) public onlyOwner {
        require(tasks[_taskIndex].completed != true, "Task already completed");
        tasks[_taskIndex].completed = true;

        emit TaskCompleted(_taskIndex, tasks[_taskIndex].taskName);
    }
}
