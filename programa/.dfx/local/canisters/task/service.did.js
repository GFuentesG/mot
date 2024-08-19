export const idlFactory = ({ IDL }) => {
  const TaskId = IDL.Nat32;
  const TaskStatus = IDL.Variant({
    'pending' : IDL.Null,
    'completed' : IDL.Null,
  });
  const Task = IDL.Record({
    'id' : TaskId,
    'status' : TaskStatus,
    'owner' : IDL.Principal,
    'description' : IDL.Text,
  });
  const GetTaskResultOk = IDL.Variant({
    'tasks' : IDL.Vec(Task),
    'taskStatusUpdatedSuccessfully' : IDL.Null,
    'task' : Task,
    'theTaskWasDeleted' : IDL.Null,
    'taskAddedSuccessfully' : IDL.Null,
  });
  const GetTaskResultErr = IDL.Variant({
    'taskNotFoundOrYouDoNotOwnThisTask' : IDL.Null,
    'youAreNotTheOwnerOfThisTask' : IDL.Null,
    'userNotAuthenticated' : IDL.Null,
    'countryDataNotFound' : IDL.Null,
    'taskIsAlreadyInTheRequestedStatus' : IDL.Null,
    'errModuleHttp' : IDL.Null,
    'taskNotFound' : IDL.Null,
    'userDoesNotExist' : IDL.Null,
    'taskNotAdded' : IDL.Null,
    'youDoNotHavePermissionToViewThisTask' : IDL.Null,
  });
  const GetTaskResult = IDL.Variant({
    'ok' : GetTaskResultOk,
    'err' : GetTaskResultErr,
  });
  return IDL.Service({
    'addTask' : IDL.Func([IDL.Text], [GetTaskResult], []),
    'addTaskForPrincipal' : IDL.Func(
        [IDL.Text, IDL.Principal],
        [GetTaskResult],
        [],
      ),
    'delTask' : IDL.Func([TaskId], [GetTaskResult], []),
    'getAllTasks' : IDL.Func([], [IDL.Vec(Task)], ['query']),
    'getMyTasks' : IDL.Func([], [GetTaskResult], ['query']),
    'getTaskById' : IDL.Func([TaskId], [GetTaskResult], ['query']),
    'getTasksByOwner' : IDL.Func([IDL.Principal], [IDL.Vec(Task)], ['query']),
    'updateTaskStatus' : IDL.Func([TaskId, TaskStatus], [GetTaskResult], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
