%%%----------------------------------------------------------------------
%%% File    : yaws_generated.template
%%% Author  : Klacke <klacke@bluetail.com>
%%% Purpose :
%%% Created : 10 Jun 2002 by Klacke <klacke@bluetail.com>
%%%----------------------------------------------------------------------

%% generated code from some environment variables

-module(yaws_generated).
-author('klacke@bluetail.com').

-export([version/0,
         vardir/0,
         etcdir/0]).

version() -> "2.3.1".

vardir() ->
    case "/workspaces/Smallwebserver/yaws-yaws-2.3.1/_inst/var" of
        "undefined" -> undefined;
        VarDir -> VarDir
    end.

etcdir() ->
    case "/workspaces/Smallwebserver/yaws-yaws-2.3.1/_inst/etc" of
        "undefined" -> undefined;
        EtcDir -> EtcDir
    end.
