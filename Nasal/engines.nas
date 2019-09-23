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

var needle = func(posx, posy) {
  cDefaultGroup.createChild("path")
               .setTranslation(posx, posy)
               .setColor(1,1,1);
};

# hash table for needle positions
# define the layout:
var needle_radius_min = 100;
var needle_radius_max = 130;
var scale_min = -135;
var scale_max = 135;

# per 90 degrees of the scale
var num_segments = 36;

# calculate
var DEG2RAD = 0.0174533;
var scale_step_deg = 90/num_segments;
var scale_width_deg = 0.3*scale_step_deg;

var needles = [[0,0,0,0,0,0,0,0]];
for (var i=0; i<num_segments; i = i+1) {
    var a0 = (i*scale_step_deg - scale_width_deg) * DEG2RAD;
    var a1 = (i*scale_step_deg + scale_width_deg) * DEG2RAD;

    var x1 = needle_radius_min * math.cos(a0);
    var y1 = needle_radius_min * math.sin(a0);

    var x2 = needle_radius_max * math.cos(a0);
    var y2 = needle_radius_max * math.sin(a0);

    var x3 = needle_radius_max * math.cos(a1);
    var y3 = needle_radius_max * math.sin(a1);

    var x4 = needle_radius_min * math.cos(a1);
    var y4 = needle_radius_min * math.sin(a1);

    append(needles, [x1, y1, x2, y2, x3, y3, x4, y4]);
}

var draw_quad = func(min, max, signx, signy) {

  min = num_segments*(min/90);
  max = num_segments*(max/90);
  for (var i=min+1; i<max+1; i = i+1) {
    var x = signx*needles[i][0];
    var y = signy*needles[i][1];
    needle_t.moveTo(x, y);

    var x = signx*needles[i][2];
    var y = signy*needles[i][3];
    needle_t.lineTo(x, y);

    var x = signx*needles[i][4];
    var y = signy*needles[i][5];
    needle_t.lineTo(x, y);

    var x = signx*needles[i][6];
    var y = signy*needles[i][7];
    needle_t.lineTo(x, y);

    needle_t.close();
  }
}

var scale_full = scale_max-scale_min;
var scale_offs = (scale_max+scale_min)/2;
var scale0 = (-scale_min-90)/scale_full;
var scale1 = scale_offs/scale_full;
var scale2 = (scale_max-90)/scale_full;

var draw_vario = func(needle_t, vario) {
  var min = 0; var max = 0;

  needle_t.reset();

  min = scale0*90;
  if (vario < scale0) max = math.round(90*vario/scale0);
  else max = 90;
  draw_quad(min, max, -1, -1);

  if (vario < scale1) min = math.round(90*vario/scale1);
  else min = 0; 
  max = 90;
  draw_quad(min, max, -1, -1);

  min = 0;
  if (vario < scale2) max = math.round(90*vario/scale2);
  else max = 0; 
  draw_quad(min, max, -1, -1);

  needle_t.setColorFill(1,1,1);
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

# Comment out to display a debugging dialog
#var window = canvas.Window.new([240,309],"dialog");
#window.setCanvas(cDisplay);

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

var torque_nt = needle(203, 243);
var itt_nt = needle(210, 564);
var ng_nt = needle(212, 874);
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

    torque = getprop("engines/engine/thruster/torque") or 0;
    if (torque_o != torque) {
       torque_o = torque;

       # The PT6A-6 uses a conversion factor of 30.87 X torque in PSI
       var psi = math.abs(torque)/30.87;

       torque_t.setText(sprintf("%3.1f", psi));
#      draw_vario(torque_nt, psi/10 - 4);
    }

    itt = getprop("engines/engine/itt_degf") or 0;
    if (itt_o != itt) {
       itt_o = itt;
       itt = (itt - 32.0)*0.5555555555;

       itt_t.setText(sprintf("%4i", itt));
#      draw_vario(itt_nt, itt/100 - 8);
    }

    ng = getprop("engines/engine/n1") or 0;
    if (ng_o != ng) {
       ng_o = ng;
       ng_t.setText(sprintf("%4.1f", ng));
#      draw_vario(ng_nt, ng/10 - 7.5);
    }

    qty = getprop("consumables/fuel/tank/level-lbs") or 0;
    if (qty_o != qty) {
       if (qty_i <= 0) qty_i = qty;
       qty_o = qty;
       qty_t.setText(sprintf("%4i", qty));
       used_t.setText(sprintf("%4i", qty_i - qty));
    }

    flh = getprop("engines/engine/fuel-flow_pph") or 0;
    if (flh_o != flh) {
       flh_o = flh;
       flh_t.setText(sprintf("%3i", flh*0.568));
    }

    np = getprop("engines/engine/thruster/rpm") or 0;
    if (np_o != np) {
        np_o = np;
        np_t.setText(sprintf("%5i", np));
    }

    oat = getprop("environment/temperature-degc") or 0;
    if (oat_o != oat) {
        oat_o = oat;
        oat_t.setText(sprintf("%3i", oat));
    }
});
rtimer.start();

