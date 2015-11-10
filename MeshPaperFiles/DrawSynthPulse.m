function DrawSynthPulse(AxHdl,TLims,PulseLims,NPts)

subplot(AxHdl);
Times=[TLims(1):(TLims(end)-TLims(1))./NPts:TLims(end) PulseLims PulseLims];
Times=sort(Times);
is=find(Times==PulseLims(1));
i2s=find(Times==PulseLims(2));
PulseVals=ones(size(Times));
PulseVals(1:is(1))=PulseVals(1:is(1))*0;
PulseVals(i2s(2):end)=PulseVals(i2s(2):end)*0;
plot(Times,PulseVals);
axis off

