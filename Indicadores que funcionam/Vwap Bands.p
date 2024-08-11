INPUT
    Percentual(0.333);
VAR
    VwapD, Vwap1, Vwap2, Vwap3, VwapM1, VwapM2, VwapM3 : Float;
BEGIN
    VwapD := Vwap(1);

    Vwap1 := VwapD+(VwapD*((Percentual*1)/100));
    Vwap2 := VwapD+(VwapD*((Percentual*2)/100));
    Vwap3 := VwapD+(VwapD*((Percentual*3)/100));

    VwapM1 := VwapD-(VwapD*((Percentual*1)/100));
    VwapM2 := VwapD-(VwapD*((Percentual*2)/100));
    VwapM3 := VwapD-(VwapD*((Percentual*3)/100));

    plot(Vwap1);
    plot2(Vwap2);
    plot3(Vwap3);

    plot4(VwapD);

    plot5(VwapM1);
    plot6(VwapM2);
    plot7(VwapM3);

    SetPlotColor(1, clRed);
    SetPlotColor(2, clRed);
    SetPlotColor(3, clRed);

    SetPlotColor(4, clAqua);
    SetPlotStyle(4, 2);
    SetPlotWidth(4, 2);

    SetPlotColor(5, clGreen);
    SetPlotColor(6, clGreen);
    SetPlotColor(7, clGreen);
END;