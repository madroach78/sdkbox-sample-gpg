
--module("sdkboxgpg")

if not json then
    require "cocos.cocos2d.json"
end

print("Evaluating Sdkbox GPG lua layer")

local DefaultCallbacks = {
    DEFAULT_CALLBACKS_BEGIN = 1,
    AUTH_ACTION_STARTED = 1,
    AUTH_ACTION_FINISHED = 2,
    DEFAULT_CALLBACKS_END = 2
}

local BaseStatus = {
    VALID = 1,
    VALID_BUT_STALE = 2,
    VALID_WITH_CONFLICT = 3,
    FLUSHED = 4,
    ERROR_LICENSE_CHECK_FAILED = -1,
    ERROR_INTERNAL = -2,
    ERROR_NOT_AUTHORIZED = -3,
    ERROR_VERSION_UPDATE_REQUIRED = -4,
    ERROR_TIMEOUT = -5,
    ERROR_CANCELED = -6,
    ERROR_MATCH_ALREADY_REMATCHED = -7,
    ERROR_INACTIVE_MATCH = -8,
    ERROR_INVALID_RESULTS = -9,
    ERROR_INVALID_MATCH = -10,
    ERROR_MATCH_OUT_OF_DATE = -11,
    ERROR_UI_BUSY = -12,
    ERROR_QUEST_NO_LONGER_AVAILABLE = -13,
    ERROR_QUEST_NOT_STARTED = -14,
    ERROR_MILESTONE_ALREADY_CLAIMED = -15,
    ERROR_MILESTONE_CLAIM_FAILED = -16,
    ERROR_REAL_TIME_ROOM_NOT_JOINED = -17,
    ERROR_LEFT_ROOM = -18
}

local CallbackManager = {_id_index=1000, _callbacks={}}

function CallbackManager:__nextIndex()
    i = self._id_index
    self._id_index = i + 1
    return i
end

function CallbackManager:addCallbackById(id, callback)
    if (self._callbacks[id] == nil) then
        self._callbacks[id] = callback
        print("Added callback " .. id)
    end
end

function CallbackManager:addCallback(callback)
    index = self:__nextIndex()
    self:addCallbackById(index, callback)
    return index
end

function CallbackManager:nativeNotify(id, str_json)

    --print("id   " .. id)
    --print("json " .. str_json)

    if (self._callbacks[id]) then
        o = json.decode(str_json)
        self._callbacks[id](o)
    end

    -- callbacks that are temporary one shot calls have to be removed.
    if (id >= 1000) then
        self._callbacks[id] = nil
    end
end

function cc.exports.__nativeNotify( id, str_json )
    print("id   " .. id)
    print("json " .. str_json)
    CallbackManager.nativeNotify( id, str_json )
end

--[[

function resetDefaultCallbacks()
    self._callbacks = {}
end

gpg = {}
gpg.ResponseStatus = {
    VALID = BaseStatus.VALID,
    VALID_BUT_STALE = BaseStatus.VALID_BUT_STALE,
    ERROR_LICENSE_CHECK_FAILED = BaseStatus.ERROR_LICENSE_CHECK_FAILED,
    ERROR_INTERNAL = BaseStatus.ERROR_INTERNAL,
    ERROR_NOT_AUTHORIZED = BaseStatus.ERROR_NOT_AUTHORIZED,
    ERROR_VERSION_UPDATE_REQUIRED = BaseStatus.ERROR_VERSION_UPDATE_REQUIRED,
    ERROR_TIMEOUT = BaseStatus.ERROR_TIMEOUT
}

gpg.DataSource = {
    CACHE_OR_NETWORK = 1,
    NETWORK_ONLY = 2
}

gpg.AuthOperation = {
    SIGN_IN = 1,
    SIGN_OUT = 2
}

gpg.AuthStatus = {
    VALID = BaseStatus.VALID,
    ERROR_INTERNAL = BaseStatus.ERROR_INTERNAL,
    ERROR_NOT_AUTHORIZED = BaseStatus.ERROR_NOT_AUTHORIZED,
    ERROR_VERSION_UPDATE_REQUIRED = BaseStatus.ERROR_VERSION_UPDATE_REQUIRED,
    ERROR_TIMEOUT = BaseStatus.ERROR_TIMEOUT
}

gpg.LogLevel = {
    VERBOSE = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4
}

gpg.ImageResolution = {
    ICON = 1,
    HI_RES = 2
}

gpg.SnapshotConflictPolicy = {
    MANUAL = 1,
    LONGEST_PLAYTIME = 2,
    LAST_KNOWN_GOOD = 3,
    MOST_RECENTLY_MODIFIED = 4,
    HIGHEST_PROGRESS = 5,
    DefaultConflictPolicy = 4
}

function gpg.IsSuccess(response_status)
    return response_status == gpg.ResponseStatus.VALID || response_status == gpg.ResponseStatus.VALID_BUT_STALE
end
]]

return CallbackManager
