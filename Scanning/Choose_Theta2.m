function true_theta=Choose_Theta2(thet1,thet2,initial,Speeds,Cent_Os)

[max_speed,i_max]=max(Speeds);
true_theta=[];
prev_theta = Cent_Os(i_max);
for k=i_max:length(thet1)
    if ((Speeds(k)*300)>7)%trust path
        diff1=ang_diff(thet1(k),Cent_Os(k));
        diff2=ang_diff(thet2(k),Cent_Os(k));
        if ( diff1 < diff2 )
            true_theta(k)=thet1(k);
        else
            true_theta(k)=thet2(k);
        end%if
    else%use prev
        diff1=ang_diff(thet1(k),prev_theta);
        diff2=ang_diff(thet2(k),prev_theta);
        if ( diff1 < diff2 )
            true_theta(k)=thet1(k);
        else
            true_theta(k)=thet2(k);
        end%if
    end%use path or recent

    prev_theta=true_theta(k);
end%k
for k=(i_max-1):-1:1
    if ((Speeds(k)*300)>7)%trust path
        diff1=ang_diff(thet1(k),Cent_Os(k));
        diff2=ang_diff(thet2(k),Cent_Os(k));
        if ( diff1 < diff2 )
            true_theta(k)=thet1(k);
        else
            true_theta(k)=thet2(k);
        end%if
    else%use prev
        diff1=ang_diff(thet1(k),prev_theta);
        diff2=ang_diff(thet2(k),prev_theta);
        if ( diff1 < diff2 )
            true_theta(k)=thet1(k);
        else
            true_theta(k)=thet2(k);
        end%if
    end%use path or recent

    prev_theta=true_theta(k);
end%k
%-------------------
function diff=ang_diff(th1,th2)
diff=abs(th1-th2);
if (diff>pi);
    diff=abs(diff-(2*pi));
end