# engine 1
start1 = props.globals.getNode("/controls/engines/start1", 1);
abort1 = props.globals.getNode("/controls/engines/abort1", 1);

set_engine1_state = func() {
	start1 = getprop("/controls/engines/start1");
	abort1 = getprop("/controls/engines/abort1");
	cutoff1 = getprop("/controls/engines/engine[0]/cutoff");
	fuel_cutoff1 = getprop("/controls/fuel-cutoff1");

	if (start1 and cutoff1 and !fuel_cutoff1)
	{
                # turboprop
		setprop("/controls/engines/engine[0]/starter", 1);
                interpolate("/fdm/jsbsim/propulsion/engine[0]/n1", 20, 15);
		settimer(func {
                    setprop("/controls/engines/engine[0]/cutoff", 0);

                    # turbine for emulating exhaust thrust
                    setprop("/engines/engine[1]/cutoff", 1);
                    setprop("/controls/engines/engine[1]/starter", 1);
                    settimer(func { setprop("/controls/engines/engine[1]/cutoff", 0); }, 1);
                 }, 16);

		settimer(switchback1, 1);
	}
	if (abort1)
	{
		setprop("/controls/engines/engine[0]/cutoff", 1);
                setprop("/controls/engines/engine[1]/cutoff", 1);
		settimer(switchback1, 1);
	}
}

switchback1 = func() {
	setprop("/controls/engines/run1",1);
	setprop("/controls/engines/start1",0);
	setprop("/controls/engines/abort1",0);
}

setlistener(start1, set_engine1_state );
setlistener(abort1, set_engine1_state );

