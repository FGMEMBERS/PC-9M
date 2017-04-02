var label = func(txt, posx, posy, desc) {
  cDefaultGroup.createChild("text", desc)
                .setTranslation(posx, posy)
                .setAlignment("left-top")
                .setFont("typewriter.txf")
                .setFontSize(12, 1.5)
                .setColor(1,1,1)
                .setText(txt);
};

var variable = func(txt, posx, posy, desc) {
  cDefaultGroup.createChild("text", desc)
                .setTranslation(posx, posy)
                .setAlignment("right-top")
                .setFont("DSEG/DSEG7/Classic/DSEG7Classic-BoldItalic.ttf")
                .setFontSize(18, 1.2)
                .setColor(1,1,1)
                .setText(txt);
};

var cDisplay = canvas.new({
  "name": "systems",
  "size": [1024, 1024],
  "view": [795, 1024],
  "mipmapping": 1
});
cDisplay.addPlacement({"node": "sysdisp"});
#cDisplay.set("background", canvas.style.getColor("bg_color"));
cDisplay.set("background", "#000000");

var cDefaultGroup = cDisplay.createGroup();

var window = canvas.Window.new([240,309],"dialog");
window.setCanvas(cDisplay);

# engine torque
label("TORQUE", 154, 198, "torque");
label("PSIx10", 176, 288, "psix10");

# turbine temperature
label("ITT", 189, 518, "itt");
label("x100⁰C", 181, 606, "x100degc");

# gass generator speed
label("NG", 190, 822, "ng");
label("%RPMx10", 166, 906, "pctrpmx10");

# fuel, fuel remaining and fuel flow
label("FUEL", 375, 331, "fuel");
label("(LBS)", 432, 331, "(lbs)");
label("QTY", 337, 369, "qty");
label("FL/H", 329, 413, "fl/h");
label("USED", 327, 460, "used");

# hydraulic pressure
label("N2", 636, 426, "n2");
label("HYD", 629, 448, "hyd");
label("PSIx1000", 609, 466, "psix1000");

# propeller speed
label("NP  RPM", 384, 572, "np rpm");
# outside air temperature
label("OAT ⁰C", 570, 572, "oatdegc");
# DC bysbar voltage and current
label("DC VOLTS", 380, 629, "dcvolts");
label("DC AMPS", 557, 629, "dcamps");

var torque_t = variable( "0.0", 232, 234, "tq");
var itt_t = variable( "0.0", 232, 550, "itt");
var ng_t = variable( "0.0", 232, 857, "ng");
var qty_t = variable( "0.0", 468, 362, "qty");
var flh_t = variable( "0.0", 468, 405, "fl_h");
var used_t = variable( "0.0", 468, 450, "used");
var np_t = variable( "0.0", 464, 585, "np");
var oat_t = variable( "0.0", 634, 580, "np");
var dcv_t = variable( "0.0", 454, 640, "dcv");
var dca_t = variable( "0.0", 634, 640, "dca");

var torque_o = 0;
var itt_o = 0;
var ng_o = 0;
var qty_o = 0;
var qty_i = 0;
var flh_o = 0;
var used_o = 0;
var np_o = 0;
var oat_o = 0;
var dcv_o = 0;
var dca_o = 0;

var rtimer = maketimer(0.333333333, func {

    torque = getprop("engines/engine/thruster/torque");
    if (torque_o != torque) {
       torque_o = torque;

# The PT6A-6 through the -21 uses a conversion factor of 30.87 X torque in PSI
       torque_t.setText(sprintf("%3.1f", abs(torque)/30.87));
    }

    itt = getprop("engines/engine/itt_degf");
    if (itt_o != itt) {
       itt_o = itt;
        itt = (itt - 32.0)*0.5555555555;
       itt_t.setText(sprintf("%4i", itt));
    }

    ng = getprop("engines/engine/n1");
    if (ng_o != ng) {
       ng_o = ng;
       ng_t.setText(sprintf("%4.1f", ng));
    }

    qty = getprop("consumables/fuel/tank/level-lbs");
    if (qty_o != qty) {
       if (qty_i <= 0) qty_i = qty;
       qty_o = qty;
       qty_t.setText(sprintf("%4i", qty));
       used_t.setText(sprintf("%4i", qty_i - qty));
    }

    flh = getprop("engines/engine/fuel-flow_pph");
    if (flh_o != flh) {
       flh_o = flh;
       flh_t.setText(sprintf("%3i", flh*0.568));
    }

    np = getprop("engines/engine/thruster/rpm");
    if (np_o != np) {
        np_o = np;
        np_t.setText(sprintf("%5i", np));
    }

    oat = getprop("environment/temperature-degc");
    if (oat_o != oat) {
        oat_o = oat;
        oat_t.setText(sprintf("%3i", oat));
    }
});
rtimer.start();

