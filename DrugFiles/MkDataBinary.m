function[BinDat]=MkDataBinary(RawData)

Inds=RawData(:,1);
Binaries=RawData(:,2:end-1)>0;
Fs=RawData(:,end);
BinDat=[Inds Binaries Fs];
