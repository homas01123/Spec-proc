% SPECTRA IMPORT %
[tar, ref] = importsvc('E:\Soham_Data\Work\NESAC\Hyperspectral_Soil\Non-imaging Spectra Analysis\Non-imaging Spectral Analysis\Yearly Report\ALFI\*.sig');
tar_names = {tar.name};
ref_names = {ref.name};
tar_header = headers(tar);
ref_header = headers(ref);
%openvar tar_header;
%openvar ref_header;
tar_spectra = [tar.data];
ref_spectra = [ref.data];
tar_wavelength = tar(1).wavelength;
ref_wavelength = ref(1).wavelength;
tar_comb_data = [tar(1).wavelength, [tar.data]];
ref_comb_data = [ref(1).wavelength, [ref.data]];

% PLOT OF TARGET AND REFERENCE REFLECTANCE %
plot([tar.wavelength], 100*[tar.data]);
legend(tar.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Target spectra of ALFI soil consisting various LULC in Ri-Bhoi district, Meghalaya');
plot([ref.wavelength], 100*[ref.data]);
legend(ref.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Reference spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');

% DETECTOR OVERLAP REMOVAL %
tar_joined = removeoverlapp(tar, 980, 1900); 
ref_joined = removeoverlapp(ref, 980, 1900);
plot([tar_joined.wavelength], 100*[tar_joined.data]);
legend(tar_joined.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Overlap removed Target spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
plot([ref_joined.wavelength], 100*[ref_joined.data]);
legend(ref_joined.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Overlap removed Reference spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');

% GENERATION AND PLOT OF RELATIVE REFLECTANCE %
rel_reflec = relativereflectance(tar_joined, ref_joined);
plot([rel_reflec.wavelength], [rel_reflec.data]);
legend(rel_reflec.name); xlabel('Wavelength (nm)'); ylabel('Relative Reflectance'); 
title('Relative Reflectance generated from spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');

% GENERATION AND PLOT OF ABSOLUTE RELECTANCE %
subplot(2,2,1)
panel_cal = importpanelcal('E:\Soham_Data\Work\NESAC\Hyperspectral_Soil\Non-imaging Spectra Analysis\Non-imaging Spectral Analysis\Panel_Cal_File_Archive\FSF.xls' , 'SRT #033');
plot(panel_cal.wavelength, 100*panel_cal.data); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)');
title('Panel Reflectance recorded on SVC HR 1024');
abs_reflec = absolutereflectance(rel_reflec, panel_cal);
plot([abs_reflec.wavelength], 100*[abs_reflec.data]);
legend(abs_reflec.name); xlabel('Wavelength (nm)'); ylabel('Absolute Reflectance (%)'); 
title('Absolute Reflectance generated from RAW spectra of ALFI soil consisting various LULC in Ri-Bhoi district, Meghalaya');

% Savitzky–Golay Smoothening and visualization of reflectance curve %
tar_smoothed = sgsmooth(tar);
ref_smoothed = sgsmooth(ref);
plot([tar_smoothed.wavelength], 100*[tar_smoothed.data]);
legend(tar_smoothed.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Smoothened Target spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
plot([ref_smoothed.wavelength], 100*[ref_smoothed.data]);
legend(ref_smoothed.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Smoothened Reference spectra recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
tar_joined_smoothed = sgsmooth(tar_joined);
ref_joined_smoothed = sgsmooth(ref_joined);
rel_reflec_smoothed = sgsmooth(rel_reflec);
abs_reflec_smoothed = sgsmooth(abs_reflec);
plot([rel_reflec_smoothed.wavelength], 100*[rel_reflec_smoothed.data]);
legend(rel_reflec_smoothed.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Smoothened Relative Reflectance recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
plot([abs_reflec_smoothed.wavelength], 100*[abs_reflec_smoothed.data]);
legend(abs_reflec_smoothed.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Smoothened Absolute Reflectance recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');

% Removal of water absorption bands %
tar_nowater = removewater(tar);
ref_nowater = removewater(ref);
tar_smoothed_nowater = removewater(tar_smoothed);
ref_smoothed_nowater = removewater(ref_smoothed);
rel_reflec_nowater = removewater(rel_reflec);
abs_reflec_nowater = removewater(abs_reflec);
rel_reflec_smoothed_nowater = removewater(rel_reflec_smoothed);
abs_reflec_smoothed_nowater = removewater(abs_reflec_smoothed);
plot([rel_reflec_nowater.wavelength], 100*[rel_reflec_nowater.data]);
legend(rel_reflec_nowater.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Water absorption band removed Relative Reflectance recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
plot([abs_reflec_nowater.wavelength], 100*[abs_reflec_nowater.data]);
legend(abs_reflec_nowater.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Water absoption band removed Absolute Reflectance recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
plot([rel_reflec_smoothed_nowater.wavelength], 100*[rel_reflec_smoothed_nowater.data]);
legend(rel_reflec_smoothed_nowater.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Water Absorption band removed Smoothened Relative Reflectance recorded on SVC HR 1024 in Ri-Bhoi on 12-16 February 2018');
subplot(2,2,2)
plot([abs_reflec_smoothed_nowater.wavelength], 100*[abs_reflec_smoothed_nowater.data]);
legend(abs_reflec_smoothed_nowater.name); xlabel('Wavelength (nm)'); ylabel('Reflectance (%)'); 
title('Water Absorption band removed smoothened Absolute Reflectance of ALFI soil consisting various LULC in Ri-Bhoi district, Meghalaya');