import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type GetProfileCountryResult = { 'ok' : ProfileWithCountryDetails } |
  { 'err' : GetProfileResultErr };
export type GetProfileResult = { 'ok' : GetProfileResultOk } |
  { 'err' : GetProfileResultErr };
export type GetProfileResultErr = { 'userNotAuthenticated' : null } |
  { 'countryDataNotFound' : null } |
  { 'userDoesNotExist' : null } |
  { 'unregisteredUser_nameOrEmailIsInvalid' : null };
export type GetProfileResultOk = { 'userSuccessfullyDeleted' : null } |
  { 'profiles' : Array<Profile> } |
  { 'profile' : Profile } |
  { 'userSuccessfullyAdded' : null };
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
export interface Profile {
  'country' : string,
  'username' : string,
  'owner' : Principal,
  'email' : string,
}
export interface ProfileWithCountryDetails {
  'countryDetails' : string,
  'profile' : Profile,
}
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
  'addProfile' : ActorMethod<[Profile], GetProfileResult>,
  'addTaskToProfile' : ActorMethod<[string, string], GetTaskResult>,
  'delProfile' : ActorMethod<[string], GetProfileResult>,
  'getProfile' : ActorMethod<[string], GetProfileCountryResult>,
  'getProfiles' : ActorMethod<[], GetProfileResult>,
  'listTasksForUser' : ActorMethod<[string], GetTaskResult>,
  'whoami' : ActorMethod<[], Principal>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
