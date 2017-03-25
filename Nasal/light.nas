beacon_switch = props.globals.getNode("controls/switches/beacon", 2);
var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0.4, 0.4], "/controls/lighting/beacon" );
strobe_switch = props.globals.getNode("controls/switches/strobe", 2);
var strobe = aircraft.light.new( "/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1], "/controls/lighting/strobe" );

controls.toggleLandingLights = func()
{
    var state = getprop("controls/lighting/landing-lights");
    setprop("controls/lighting/landing-lights",!state);
}

setprop("/systems/electrical/outputs/strobe-norm", 1.0);
setprop("/systems/electrical/outputs/nav-lights-norm", 1.0);
#setprop("/systems/electrical/outputs/taxi-light", 0.0);
