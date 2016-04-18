@/cmsaf/nfshome/sstapelb/idl/bright_m.pro

FUNCTION MODIS_BRIGHT,platform_name,RAD, BAND, UNITS

  ; ... Effective central wavenumbers (inverse centimeters)
  cwn_terra = [ $
        2.641767E+03, 2.505274E+03, 2.518031E+03, 2.465422E+03, $
        2.235812E+03, 2.200345E+03, 1.478026E+03, 1.362741E+03, $
        1.173198E+03, 1.027703E+03, 9.081998E+02, 8.315149E+02, $
        7.483224E+02, 7.309089E+02, 7.188677E+02, 7.045309E+02]

  ; ... Temperature correction slopes (no units)
  tcs_terra = [ $
        9.993487E-01, 9.998699E-01, 9.998604E-01, 9.998701E-01, $
        9.998825E-01, 9.998849E-01, 9.994942E-01, 9.994937E-01, $
        9.995643E-01, 9.997499E-01, 9.995880E-01, 9.997388E-01, $
        9.999192E-01, 9.999171E-01, 9.999174E-01, 9.999264E-01]

  ; ... Temperature correction intercepts (Kelvin)
  tci_terra = [ $
        4.744530E-01, 9.091094E-02, 9.694298E-02, 8.856134E-02, $
        7.287017E-02, 7.037161E-02, 2.177889E-01, 2.037728E-01, $
        1.559624E-01, 7.989879E-02, 1.176660E-01, 6.856633E-02, $
        1.903625E-02, 1.902709E-02, 1.859296E-02, 1.619453E-02]

;c-----------------------------------------------------------------------

;;$c     AQUA MODIS DETECTOR-AVERAGED SPECTRAL RESPONSE
;;$c     (LIAM GUMLEY 2003/06/05)
;;$
;;$c     BAND 20 TEMPERATURE RANGE WAS  180.00 K TO  350.00 K
;;$c     BAND 21 TEMPERATURE RANGE WAS  180.00 K TO  400.00 K
;;$c     BAND 22 TEMPERATURE RANGE WAS  180.00 K TO  350.00 K
;;$c     BAND 23 TEMPERATURE RANGE WAS  180.00 K TO  350.00 K
;;$c     BAND 24 TEMPERATURE RANGE WAS  180.00 K TO  320.00 K
;;$c     BAND 25 TEMPERATURE RANGE WAS  180.00 K TO  320.00 K
;;$c     BAND 27 TEMPERATURE RANGE WAS  180.00 K TO  320.00 K
;;$c     BAND 28 TEMPERATURE RANGE WAS  180.00 K TO  320.00 K
;;$c     BAND 29 TEMPERATURE RANGE WAS  180.00 K TO  340.00 K
;;$c     BAND 30 TEMPERATURE RANGE WAS  180.00 K TO  340.00 K
;;$c     BAND 31 TEMPERATURE RANGE WAS  180.00 K TO  340.00 K
;;$c     BAND 32 TEMPERATURE RANGE WAS  180.00 K TO  340.00 K
;;$c     BAND 33 TEMPERATURE RANGE WAS  180.00 K TO  330.00 K
;;$c     BAND 34 TEMPERATURE RANGE WAS  180.00 K TO  320.00 K
;;$c     BAND 35 TEMPERATURE RANGE WAS  180.00 K TO  310.00 K
;;$c     BAND 36 TEMPERATURE RANGE WAS  180.00 K TO  310.00 K
;;$
;;$c     BANDS
;;$c       20,  21,  22,  23,
;;$c       24,  25,  27,  28,
;;$c       29,  30,  31,  32,
;;$c       33,  34,  35,  36,

  ; ... Effective central wavenumbers (inverse centimeters)
      cwn_aqua = [ $
           2.647418E+03, 2.511763E+03, 2.517910E+03, 2.462446E+03, $
           2.248296E+03, 2.209550E+03, 1.474292E+03, 1.361638E+03, $
           1.169637E+03, 1.028715E+03, 9.076808E+02, 8.308397E+02, $
           7.482977E+02, 7.307761E+02, 7.182089E+02, 7.035020E+02]

; ... Temperature correction slopes (no units)
      tcs_aqua = [ $
           9.993438E-01, 9.998680E-01, 9.998649E-01, 9.998729E-01, $
           9.998738E-01, 9.998774E-01, 9.995732E-01, 9.994894E-01, $
           9.995439E-01, 9.997496E-01, 9.995483E-01, 9.997404E-01, $
           9.999194E-01, 9.999071E-01, 9.999176E-01, 9.999211E-01]

; ... Temperature correction intercepts (Kelvin)
      tci_aqua = [ $
           4.792821E-01, 9.260598E-02, 9.387793E-02, 8.659482E-02, $
           7.854801E-02, 7.521532E-02, 1.833035E-01, 2.053504E-01, $
           1.628724E-01, 8.003410E-02, 1.290129E-01, 6.810679E-02, $
           1.895925E-02, 2.128960E-02, 1.857071E-02, 1.733782E-02]

      ;c-----------------------------------------------------------------------

      ; ... Set default return value
      modis_bright = -1.0

      ; ... Check input parameters and return if they are bad
      if (band lt 20 or $
          band gt 36 or $
          band eq 26) then return,modis_bright

; ... Get index into coefficient arrays
      if (band le 25) then begin
         index = band - 19 -1 ; -1 wegen idl
      endif else begin
         index = band - 20 -1 ; -1 wegen idl
      endelse

      ; ... Get the coefficients for Terra or Aqua
      if strlowcase(strmid(platform_name,0,5)) eq 'terra' then begin
         cwn = cwn_terra[index]
         tcs = tcs_terra[index]
         tci = tci_terra[index]
      endif else if strlowcase(strmid(platform_name,0,4)) eq 'aqua' then begin
         cwn = cwn_aqua[index]
         tcs = tcs_aqua[index]
         tci = tci_aqua[index]
      endif

      ; ... Compute brightness temperature
      if (units eq 1) then begin

         ; ...   Radiance units are
         ; ...   Watts per square meter per steradian per micron
         modis_bright = (bright_m(1.0e+4 / cwn, rad) - tci) / tcs

         ;MJ    else

         ; ...   Radiance units are
         ; ...   milliWatts per square meter per steradian per wavenumber
         ;MJ modis_bright = (brite_m(cwn, rad) - tci) / tcs

      endif

      return,modis_bright

 END
