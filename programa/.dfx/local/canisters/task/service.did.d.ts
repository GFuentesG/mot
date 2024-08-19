import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type GetTaskResult = { 'ok' : GetTaskResultOk } |
  { 'err' : GetTaskResultErr };
export type GetTaskResultErr = { 'taskNotFoundOrYouDoNotOwnThisTask' : null } |
  { 'youAreNotTheOwnerOfThisTask' : null } |
  { 'userNotAuthenticated' : null } |
  { 'countryDataNotFound' : null } |
  { 'taskIsAlreadyInTheRequestedStatus' : null } |
  { 'errModuleHttp' : null } |
  { 'taskNotFound' : null } |
  { 'userDoesNotExist' : null } |
  { 'taskNotAdded' : null } |
  { 'youDoNotHavePermissionToViewThisTask' : null };
export type GetTaskResultOk = { 'tasks' : Array<Task> } |
  { 'taskStatusUpdatedSuccessfully' : null } |
  { 'task' : Task } |
  { 'theTaskWasDeleted' : null } |
  { 'taskAddedSuccessfully' : null };
export interface Task {
  'id' : TaskId,
  'status' : TaskStatus,
  'owner' : Principal,
  'description' : string,
}
export type TaskId = number;
export type TaskStatus = { 'pending' : null } |
  { 'completed' : null };
export interface _SERVICE {
  'addTask' : ActorMethod<[string], GetTaskResult>,
  'addTaskForPrincipal' : ActorMethod<[string, Principal], GetTaskResult>,
  'delTask' : ActorMethod<[TaskId], GetTaskResult>,
  'getAllTasks' : ActorMethod<[], Array<Task>>,
  'getMyTasks' : ActorMethod<[], GetTaskResult>,
  'getTaskById' : ActorMethod<[TaskId], GetTaskResult>,
  'getTasksByOwner' : ActorMethod<[Principal], Array<Task>>,
  'updateTaskStatus' : ActorMethod<[TaskId, TaskStatus], GetTaskResult>,
  'whoami' : ActorMethod<[], Principal>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
