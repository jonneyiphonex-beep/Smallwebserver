-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").
-include("yaws.hrl").
-include("yaws_api.hrl").

-define(top_srcdir,   "/workspaces/Smallwebserver/yaws-yaws-2.3.1").
-define(top_builddir, "/workspaces/Smallwebserver/yaws-yaws-2.3.1").
-define(srcdir,       "/workspaces/Smallwebserver/yaws-yaws-2.3.1/src").
-define(ebindir,      "/workspaces/Smallwebserver/yaws-yaws-2.3.1/ebin").
-define(ts_srcdir,    "/workspaces/Smallwebserver/yaws-yaws-2.3.1/test").
-define(ts_builddir,  "/workspaces/Smallwebserver/yaws-yaws-2.3.1/test").
-define(wwwdir,       "/workspaces/Smallwebserver/yaws-yaws-2.3.1/www").
-define(ssldir,       "/workspaces/Smallwebserver/yaws-yaws-2.3.1/ssl").
-define(sslkeyfile,   "/workspaces/Smallwebserver/yaws-yaws-2.3.1/ssl/yaws-key.pem").
-define(sslcertfile,  "/workspaces/Smallwebserver/yaws-yaws-2.3.1/ssl/yaws-cert.pem").

-define(data_srcdir  (SuiteName), filename:join(?ts_srcdir,   atom_to_list(SuiteName) ++ "_data")).
-define(data_builddir(SuiteName), filename:join(?ts_builddir, atom_to_list(SuiteName) ++ "_data")).

-define(templatedir(SuiteName), filename:join(?data_srcdir(SuiteName),   "templates")).
-define(tempdir    (SuiteName), filename:join(?data_builddir(SuiteName), "temp")).

-ifdef(SHOW_LOG).

-define(LOG(Fmt),       io:format(standard_error, Fmt, [])).
-define(LOG(Fmt, Args), io:format(standard_error, Fmt, Args)).

-else.

-define(LOG(Fmt),       io_lib:format(Fmt, [])).
-define(LOG(Fmt, Args), io_lib:format(Fmt, Args)).

-endif.

-define(GET_ENV(VarName), case os:getenv(VarName) of
                              false -> "";
                              _     -> os:getenv(VarName)
                          end).
