interval
========

installation
--------
git clone git://github.com/eshubin/interval.git

build
--------
cd interval
./rebar compile

testing
--------
./rebar eunit

launch
-------
erl -pz ebin

application:start(interval).
