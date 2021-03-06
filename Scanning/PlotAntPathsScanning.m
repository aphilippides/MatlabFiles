PaulPlotAntPaths

s=dir('*_ProgWhole*')
is=[1:length(s)]
for j=is
    f=s(i).name;
	load(f)

% remove any bits on the edges
cent =[180.3034  134.2052];
rad = [160];
ds=CartDist(Cents,cent);
goods=find(ds<rad);

% WhichB=WhichB(goods);
% Cents=Cents(goods,:);
blist=unique(WhichB);
% get the list of labels
% [fr,blist]=Frequencies(WhichB);
% [nis,is]=sort(fr,'descend');
% blist=blist(is)';


GoodAnts=[];
for i = blist
    
    % for each label get the indices of all ants with that label and plot
    % their centroids
    is=find(WhichB==i);
    nis=length(is);
    if(nis>1)
        if(nargin==2) 
            imagesc(im);
            hold on;
        end
    plot(Cents(is,1),Cents(is,2))
	set(gca,'YDir','reverse')
	hold on
	text(Cents(is(1),1),Cents(is(1),2),int2str(i))
    title(['Ant labelled ' int2str(i) ' consisting of ' int2str(nis) ' points'])
    axis equal
    
    % pause and get input as to whether its an ant or not. If so, put the
    % label in GoodAnts and store it in fn
%      ind=input('type 1 if this is an ant trail, anything else to get rid of it');
% % ind=0;
%     if(ind==1)
%         GoodAnts=[GoodAnts i];
%         save(fn,'GoodAnts','-append');
%     end
    end
end

end%j
hold off
GoodAnts