% CRSColorTestfunction CRSColorTest% 3/7/03  jb moved call CRSColorZeroCal from CRSColorMeasXYZ to CRSColorTest% Open up the virtual portCRSColorInit;% need to call CRSColorZeroCalCRSColorZeroCal;% Measure sync timeCRSColorSyncTime;[nil,nil,syncTime,nil] = CRSColorGetInfo;fprintf('CRS says sync time is %g\n',syncTime);% Get a report about the colorimeters[calNumber,romVersion,intTime,serialNo] = CRSColorGetInfo;fprintf('Cal No: %g, romVersion: %g, integration time: %g, serial %d\n',...	calNumber,romVersion,intTime,serialNo);% Read XYZXYZ = CRSColorMeasXYZ;fprintf('Measured X = %g, Y = %g, Z = %g\n',XYZ(1:3));% Try changing the integration timeCRSColorSetIntTime(10);XYZ = CRSColorMeasXYZ;fprintf('Measured X = %g, Y = %g, Z = %g\n',XYZ(1:3));% Close down the portCRSColorClose;