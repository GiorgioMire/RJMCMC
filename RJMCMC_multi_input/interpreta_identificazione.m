%masse aggiunte (Kg)
m_x = 246.334+42.2;
m_y = 4803.505+42.2;
m_z = 5456.562+42.2;
%momenti inerzia masse aggiunte (kg m2)
mxx = 414.927;
myy = 1420.928;
mzz = 6384.146;

MASSA11=inv(bestak(4)/Processed_data.piccoX*Processed_data.piccoU/Processed_data.Ts_undersampled)
m_x
DAMP11=(1-bestak(1))/Processed_data.Ts_undersampled*MASSA11
DAMP11TrueMass=(1-bestak(1))/Processed_data.Ts_undersampled*m_x
MASSA12_VR=bestak(2)/Processed_data.piccoV/Processed_data.piccoR*Processed_data.piccoU*MASSA11/Processed_data.Ts_undersampled
m_y
MASSA13_WQ=bestak(3)/Processed_data.piccoW/Processed_data.piccoQ*Processed_data.piccoU*MASSA11/Processed_data.Ts_undersampled
m_z