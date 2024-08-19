export const idlFactory = ({ IDL }) => {
  const Profile = IDL.Record({
    'country' : IDL.Text,
    'username' : IDL.Text,
    'owner' : IDL.Principal,
    'email' : IDL.Text,
  });
  const GetProfileResultOk = IDL.Variant({
    'userSuccessfullyDeleted' : IDL.Null,
    'profiles' : IDL.Vec(Profile),
    'profile' : Profile,
    'userSuccessfullyAdded' : IDL.Null,
  });
  const GetProfileResultErr = IDL.Variant({
    'userNotAuthenticated' : IDL.Null,
    'countryDataNotFound' : IDL.Null,
    'userDoesNotExist' : IDL.Null,
    'unregisteredUser_nameOrEmailIsInvalid' : IDL.Null,
  });
  const GetProfileResult = IDL.Variant({
    'ok' : GetProfileResultOk,
    'err' : GetProfileResultErr,
  });
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
  const ProfileWithCountryDetails = IDL.Record({
    'countryDetails' : IDL.Text,
    'profile' : Profile,
  });
  const GetProfileCountryResult = IDL.Variant({
    'ok' : ProfileWithCountryDetails,
    'err' : GetProfileResultErr,
  });
  return IDL.Service({
    'addProfile' : IDL.Func([Profile], [GetProfileResult], []),
    'addTaskToProfile' : IDL.Func([IDL.Text, IDL.Text], [GetTaskResult], []),
    'delProfile' : IDL.Func([IDL.Text], [GetProfileResult], []),
    'getProfile' : IDL.Func([IDL.Text], [GetProfileCountryResult], []),
    'getProfiles' : IDL.Func([], [GetProfileResult], ['query']),
    'listTasksForUser' : IDL.Func([IDL.Text], [GetTaskResult], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
