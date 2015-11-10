function [estimates, model] = fitIRData%(x, y)
dat=load('backsensorPldat.txt');
x=dat(:,1);
y=dat(:,2);
start_p = [0 0 0];
while 1
    
    [sse, f] = mygauss(start_p);
    plotstuff(f);
    start_p=input('enter [a,b,c] in a*exp(-((x-b)/c)^2); return end: ');
    if(isempty(start_p))
        break;
    end
end


% Call fminsearch with a random starting point.
model = @mygauss;
estimates = fminsearch(model, start_p);
[sse, FittedCurve] = mygauss(estimates)
plotstuff(FittedCurve)
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A*exp(-lambda*x)-y,
% and the FittedCurve. FMINSEARCH only needs sse, but we want
% to plot the FittedCurve at the end.
    function [sse, FittedCurve] = mygauss(params)
        FittedCurve = params(1)*exp(-((x-params(2))/params(3)).^2);
        ErrorVector = FittedCurve - y;
        sse = sum(ErrorVector .^ 2);
    end

    function plotstuff(y_est)
        plot(x, y, '*',x, y_est, 'r')
        xlabel('distance')
        ylabel('IR reading')
    end
end

