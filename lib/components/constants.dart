import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors

const scaffoldBackgroundColor = Color.fromARGB(255, 245, 245, 245);
const black = Color.fromARGB(221, 0, 0, 0);
const grey = Color.fromARGB(221, 233, 233, 233);
const darkGrey = Color.fromARGB(221, 150, 150, 150);
const white = Color.fromARGB(255, 255, 255, 255);
const primaryColor = Colors.redAccent;
const secondaryColor = Colors.greenAccent;

//Fonts

xxlStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 51,
    fontWeight: fw,
    color: color,
  );
}

xlStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 41,
    fontWeight: fw,
    color: color,
  );
}

lStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 31,
    fontWeight: fw,
    color: color,
  );
}

bodyStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 21,
    fontWeight: fw,
    color: color,
  );
}

mediumStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 19,
    fontWeight: fw,
    color: color,
  );
}

smallStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 12,
    fontWeight: fw,
    color: color,
  );
}

buttonStyle({fw, color}) {
  return GoogleFonts.dosis(
    fontSize: 23,
    fontWeight: fw,
    color: color,
  );
}

//Const

const gap = SizedBox(
  width: 20,
  height: 20,
);

newSnackBar(BuildContext context, {title}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: secondaryColor,
      content: Text(
        title,
        style: bodyStyle(
          color: black,
          fw: FontWeight.w500,
        ),
      ),
    ),
  );
}
